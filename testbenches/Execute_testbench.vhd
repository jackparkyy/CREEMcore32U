library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- define the interface between the alu and its external environment
entity execute_testbench is
end execute_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of execute_testbench is
	-- architecture declarations
	constant clock_delay	: time := 50 ns;
    signal current_pc       : std_logic_vector(31 downto 0) := (others => '0');

    signal clk, pcsrc                       : std_logic                      := '0';
    signal control                          : std_logic_vector(8 downto 0)   := (others => '0');
    signal rd, control_out, rd_out          : std_logic_vector(4 downto 0)   := (others => '0');
    signal funct, funct_out                 : std_logic_vector(3 downto 0)   := (others => '0');
    signal rs1d, rs2d, imm, pc, next_pc,
            alu_result, add_result,
            add_result_out, addr_const      : std_logic_vector(31 downto 0)  := (others => '0');
-- concurrent statements
begin
	-- instantiate alu_controller
	execute : entity work.u32_execute
	port map (
        -- inputs
		clk => clk,
        control => control,
        rd => rd,
        funct => funct,
        rs1d => rs1d,
        rs2d => rs2d,
        imm => imm,
        pc => pc,
        next_pc => next_pc,
        -- outputs
        control_out => control_out,
        rd_out => rd_out,
        funct_out => funct_out,
        alu_result => alu_result,
        add_result => add_result,
        add_result_out => add_result_out,
        addr_const => addr_const,
        pcsrc => pcsrc
	);
	
	process
		procedure test(
            constant passed_rs1d, passed_rs2d, passed_imm   : in std_logic_vector(31 downto 0);
            constant passed_pcsrc                           : in std_logic;
            constant passed_funct                           : in std_logic_vector(3 downto 0)
		) is
        begin
            funct <= passed_funct;
            rs1d <= passed_rs1d;
            rs2d <= passed_rs2d;
            imm <= passed_imm;
            rd <= "11111";
			clk <= '1';

			wait for clock_delay;
            clk <= '0';
			wait for clock_delay;
			clk <= '1';
            
            assert funct_out = passed_funct
			report "Unexcpected result: " &
			"funct_out = " & to_string(funct_out) & "; " &
			"expected = 1111; "
            severity error;
            
            assert rd_out = "11111"
			report "Unexcpected result: " &
			"rd_out = " & to_string(rd_out) & "; " &
			"expected = 11111; "
            severity error;
            
            assert pcsrc = passed_pcsrc
			report "Unexcpected result: " &
			"pcsrc = " & to_string(pcsrc) & "; " &
			"expected = " & to_string(passed_pcsrc) & "; "
			severity error;
        end procedure test;

        procedure test_lui(
            constant passed_imm    : in std_logic_vector(31 downto 0)
		) is
        begin
            control <= "100001000";
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '0', "1111");
            assert addr_const = passed_imm
			report "Unexcpected result: " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = " & to_hex_string(passed_imm) & "; "
			severity error;
        end procedure test_lui;

        procedure test_auipc(
            constant passed_imm, passed_pc, expected   : in std_logic_vector(31 downto 0)
		) is
        begin
            control <= "100010000";
            pc <= passed_pc;
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '0', "1111");
            assert add_result = expected
			report "Unexcpected result: " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
			severity error;
        end procedure test_auipc;

        procedure test_jal(
            constant passed_imm, passed_pc, expected   : in std_logic_vector(31 downto 0)
		) is
        begin
            control <= "100000001";
            pc <= passed_pc;
            next_pc <= passed_pc + x"00000004";
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '1', "1111");
            assert addr_const = (passed_pc + x"00000004")
			report "Unexcpected result: " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = " & to_hex_string(passed_pc + x"00000004") & "; "
            severity error;
            assert add_result_out = expected
			report "Unexcpected result: " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_jal;

        procedure test_jalr(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0)
		) is
        begin
            control <= "100000101";
            next_pc <= x"FFFFFFFF";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '1', "1111");
            assert addr_const = x"FFFFFFFF"
			report "Unexcpected result: " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = 0xFFFFFFFF; "
            severity error;
            assert add_result_out = expected
			report "Unexcpected result: " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_jalr;

        procedure test_branch(
            constant passed_rs1d, passed_rs2d, passed_imm, passed_pc, expected  : in std_logic_vector(31 downto 0);
            constant branch_taken  : in std_logic;
            constant passed_funct   : in std_logic_vector(3 downto 0)
		) is
        begin
            control <= "000011010";
            pc <= passed_pc;
            test(passed_rs1d, passed_rs2d, passed_imm, branch_taken, passed_funct);
            assert add_result_out = expected
			report "Unexcpected result: " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_branch;

        procedure test_load(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0)
		) is
        begin
            control <= "110110100";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '0', "1111");
            assert add_result = expected
			report "Unexcpected result: " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_load;

        procedure test_store(
            constant passed_rs1d, passed_rs2d, passed_imm, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
		) is	
        begin
            control <= "001011100";
            test(passed_rs1d, passed_rs2d, passed_imm, '0', passed_funct);
            assert add_result = expected
			report "Unexcpected result: " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
            assert alu_result = passed_rs2d
			report "Unexcpected result: " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(passed_rs2d) & "; "
            severity error;
        end procedure test_store;

        procedure test_opimm(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
		) is
        begin
            control <= "100100000";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '0', passed_funct);
            assert alu_result = expected
			report "Unexcpected result: " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_opimm;

        procedure test_op(
            constant passed_rs1d, passed_rs2d, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
        ) is
        begin
            control <= "100101100";
            test(passed_rs1d, passed_rs2d, x"FFFFFFFF", '0', passed_funct);
            assert alu_result = expected
			report "Unexcpected result: " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_op;
	begin
        test_lui(x"401000B3");
        test_auipc(x"401000B3", x"00000002", x"401000B5");
        test_jal(x"401000B3", x"00000001", x"401000B4");
        test_jalr(x"401000B3", x"00000001", x"401000B4");
        test_branch(x"401000B3", x"401000B3", x"00000001", x"00000001", x"00000002", '1', "1000");
        test_branch(x"401000B3", x"401000B4", x"10000002", x"30000002", x"40000004", '0', "1000");
        test_load(x"55555555", x"AAAAAAAA", x"FFFFFFFF");
        test_store(x"55555555", x"00000001", x"AAAAAAAA", x"FFFFFFFF", "1010");
        test_opimm(x"55555555", x"AAAAAAAA", x"FFFFFFFF", "1000");
        test_op(x"55555555", x"AAAAAAAA", x"FFFFFFFF", "0000");
        wait for clock_delay;
		wait;
	end process;
end behaviour;