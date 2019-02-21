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

    signal clk, clk_en, pc_src              : std_logic                      := '0';
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
        clk_en => clk_en,
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
        pc_src => pc_src
	);
	
	process
		procedure test(
            constant passed_rs1d, passed_rs2d, passed_imm   : in std_logic_vector(31 downto 0);
            constant passed_pc_src                           : in std_logic;
            constant passed_funct                           : in std_logic_vector(3 downto 0);
            constant inst_type                              : in string
		) is
        begin
            funct <= passed_funct;
            rs1d <= passed_rs1d;
            rs2d <= passed_rs2d;
            imm <= passed_imm;
            rd <= "11111";
            clk_en <= '1';

			wait for clock_delay;
            clk <= '1';
			wait for clock_delay;
			clk <= '0';
            
            wait for 1 ps;
            assert funct_out = passed_funct
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"funct_out = " & to_string(funct_out) & "; " &
			"expected = 1111; "
            severity error;
            
            assert rd_out = "11111"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"rd_out = " & to_string(rd_out) & "; " &
			"expected = 11111; "
            severity error;
            
            assert pc_src = passed_pc_src
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"pc_src = " & to_string(pc_src) & "; " &
			"expected = " & to_string(passed_pc_src) & "; "
			severity error;
        end procedure test;

        procedure test_lui(
            constant passed_imm    : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "LUI";
        begin
            control <= "100001000";
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '0', "1111", inst_type);
            assert addr_const = passed_imm
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = " & to_hex_string(passed_imm) & "; "
			severity error;
        end procedure test_lui;

        procedure test_auipc(
            constant passed_imm, passed_pc, expected   : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "AUIPC";
        begin
            control <= "100010000";
            pc <= passed_pc;
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '0', "1111", inst_type);
            assert add_result = expected
            report "Unexcpected result: " &
            "instruction type = AUIPC; " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
			severity error;
        end procedure test_auipc;

        procedure test_jal(
            constant passed_imm, passed_pc, expected   : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "JAL";
        begin
            control <= "100000001";
            pc <= passed_pc;
            next_pc <= passed_pc + x"00000004";
            test(x"FFFFFFFF", x"FFFFFFFF", passed_imm, '1', "1111", inst_type);
            assert addr_const = (passed_pc + x"00000004")
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = " & to_hex_string(passed_pc + x"00000004") & "; "
            severity error;
            assert add_result_out = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_jal;

        procedure test_jalr(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "JALR";
        begin
            control <= "100000101";
            next_pc <= x"FFFFFFFF";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '1', "1111", inst_type);
            assert addr_const = x"FFFFFFFF"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"addr_const = " & to_hex_string(addr_const) & "; " &
			"expected = 0xFFFFFFFF; "
            severity error;
            assert add_result_out = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_jalr;

        procedure test_branch(
            constant passed_rs1d, passed_rs2d, passed_imm, passed_pc, expected  : in std_logic_vector(31 downto 0);
            constant branch_taken  : in std_logic;
            constant passed_funct   : in std_logic_vector(3 downto 0)
        ) is
            constant inst_type : string := "BRANCH";
        begin
            control <= "000011010";
            pc <= passed_pc;
            test(passed_rs1d, passed_rs2d, passed_imm, branch_taken, passed_funct, inst_type);
            assert add_result_out = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "funct = " & to_string(passed_funct) & "; " &
			"add_result_out = " & to_hex_string(add_result_out) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_branch;

        procedure test_load(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "LOAD";
        begin
            control <= "110110100";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '0', "1111", inst_type);
            assert add_result = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_load;

        procedure test_store(
            constant passed_rs1d, passed_rs2d, passed_imm, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
        ) is	
            constant inst_type : string := "STORE";
        begin
            control <= "001011100";
            test(passed_rs1d, passed_rs2d, passed_imm, '0', passed_funct, inst_type);
            assert add_result = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "funct = " & to_string(passed_funct) & "; " &
			"add_result = " & to_hex_string(add_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
            assert alu_result = passed_rs2d
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "funct = " & to_string(passed_funct) & "; " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(passed_rs2d) & "; "
            severity error;
        end procedure test_store;

        procedure test_opimm(
            constant passed_rs1d, passed_imm, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
        ) is
            constant inst_type : string := "OP-IMM";
        begin
            control <= "100100000";
            test(passed_rs1d, x"FFFFFFFF", passed_imm, '0', passed_funct, inst_type);
            assert alu_result = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "funct = " & to_string(passed_funct) & "; " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_opimm;

        procedure test_op(
            constant passed_rs1d, passed_rs2d, expected  : in std_logic_vector(31 downto 0);
            constant passed_funct   : in std_logic_vector(3 downto 0)
        ) is
            constant inst_type : string := "OP";
        begin
            control <= "100101100";
            test(passed_rs1d, passed_rs2d, x"FFFFFFFF", '0', passed_funct, inst_type);
            assert alu_result = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "funct = " & to_string(passed_funct) & "; " &
			"alu_result = " & to_hex_string(alu_result) & "; " &
			"expected = " & to_hex_string(expected) & "; "
            severity error;
        end procedure test_op;
	begin
        test_lui(x"401000B3");

        test_auipc(x"401000B3", x"00000002", x"401000B5");

        test_jal(x"401000B3", x"00000001", x"401000B4");

        test_jalr(x"401000B3", x"00000001", x"401000B4");

        test_branch(x"401000B3", x"401000B3", x"00000001", x"00000001", x"00000002", '1', "0000"); -- BEQ
        test_branch(x"401000B3", x"401000B4", x"10000002", x"30000002", x"40000004", '0', "1000"); -- BEQ
        test_branch(x"401000B3", x"401000B3", x"00000001", x"00000001", x"00000002", '0', "0001"); -- BNE
        test_branch(x"401000B3", x"401000B4", x"10000002", x"30000002", x"40000004", '1', "1001"); -- BNE
        test_branch(x"FFFFFFFF", x"00000000", x"00000001", x"00000001", x"00000002", '1', "0100"); -- BLT
        test_branch(x"00000000", x"00000000", x"10000002", x"30000002", x"40000004", '0', "1100"); -- BLT
        test_branch(x"FFFFFFFF", x"00000000", x"00000001", x"00000001", x"00000002", '0', "0101"); -- BGE
        test_branch(x"00000000", x"00000000", x"10000002", x"30000002", x"40000004", '1', "1101"); -- BGE
        test_branch(x"FFFFFFFF", x"00000000", x"00000001", x"00000001", x"00000002", '0', "0110"); -- BLTU
        test_branch(x"00000000", x"00000000", x"10000002", x"30000002", x"40000004", '0', "1110"); -- BLTU
        test_branch(x"FFFFFFFF", x"00000000", x"00000001", x"00000001", x"00000002", '1', "0111"); -- BGEU
        test_branch(x"00000000", x"00000000", x"10000002", x"30000002", x"40000004", '1', "1111"); -- BGEU

        test_load(x"55555555", x"AAAAAAAA", x"FFFFFFFF");

        test_store(x"00000000", x"00000000", x"00000000", x"00000000", "0000"); -- SB
        test_store(x"00000000", x"00000001", x"00000001", x"00000001", "1000"); -- SB
        test_store(x"00000001", x"10000000", x"00000001", x"00000002", "0001"); -- SH
        test_store(x"55555555", x"55555555", x"AAAAAAAA", x"FFFFFFFF", "1001"); -- SH
        test_store(x"AAAAAAAA", x"AAAAAAAA", x"55555555", x"FFFFFFFF", "0010"); -- SW
        test_store(x"FFFFFFFE", x"FFFFFFFF", x"00000001", x"FFFFFFFF", "1010"); -- SW

        test_opimm(x"55555555", x"AAAAAAAA", x"FFFFFFFF", "0000"); -- ADDI
        test_opimm(x"55555555", x"AAAAAAAA", x"FFFFFFFF", "1000"); -- ADDI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000001", "0010"); -- SLTI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000001", "1010"); -- SLTI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000000", "0011"); -- SLTUI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000000", "1011"); -- SLTUI
        test_opimm(x"FFFFFFFF", x"FFFFFFFF", x"00000000", "0100"); -- XORI
        test_opimm(x"FFFFFFFF", x"FFFFFFFF", x"00000000", "1100"); -- XORI
        test_opimm(x"FFFFFFFF", x"00000000", x"FFFFFFFF", "0110"); -- ORI
        test_opimm(x"FFFFFFFF", x"00000000", x"FFFFFFFF", "1110"); -- ORI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000000", "0111"); -- ANDI
        test_opimm(x"FFFFFFFF", x"00000000", x"00000000", "1111"); -- ANDI
        test_opimm(x"55555555", x"00000001", x"AAAAAAAA", "0001"); -- SLLI
        test_opimm(x"AAAAAAAA", x"00000001", x"55555555", "0101"); -- SRLI
        test_opimm(x"AAAAAAAA", x"00000001", x"D5555555", "1101"); -- SRAI

        test_op(x"55555555", x"AAAAAAAA", x"FFFFFFFF", "0000"); -- ADD
        test_op(x"FFFFFFFF", x"55555555", x"AAAAAAAA", "1000"); -- SUB
        test_op(x"55555555", x"00000001", x"AAAAAAAA", "0001"); -- SLL
        test_op(x"FFFFFFFF", x"00000000", x"00000001", "0010"); -- SLT
        test_op(x"FFFFFFFF", x"00000000", x"00000000", "0011"); -- SLTU
        test_op(x"FFFFFFFF", x"FFFFFFFF", x"00000000", "0100"); -- XOR
        test_op(x"AAAAAAAA", x"00000001", x"55555555", "0101"); -- SRL
        test_op(x"AAAAAAAA", x"00000001", x"D5555555", "1101"); -- SRA
        test_op(x"FFFFFFFF", x"00000000", x"FFFFFFFF", "0110"); -- OR
        test_op(x"FFFFFFFF", x"00000000", x"00000000", "0111"); -- AND
        wait for 10 ns;
		wait;
	end process;
end behaviour;