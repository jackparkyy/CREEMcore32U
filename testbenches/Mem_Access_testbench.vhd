library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mem_access_testbench is
end mem_access_testbench;

-- define the internal organisation and operation of the memory access pipeline stage testbench
architecture behaviour of mem_access_testbench is
	-- architecture declarations
	constant clock_delay	: time := 50 ns;

    signal clk, clk_en                          : std_logic                     := '0';
    signal control, rd, rd_out                  : std_logic_vector(4 downto 0)  := (others => '0');
    signal funct                                : std_logic_vector(3 downto 0)  := (others => '0');
    signal alu_result, add_result, addr_const,
                oper, funct_rdd                 : std_logic_vector(31 downto 0) := (others => '0');
    signal control_out                          : std_logic_vector(1 downto 0)  := (others => '0');
-- concurrent statements
begin
	-- instantiate u32 memory access
	mem_access : entity work.u32_mem_access
	port map (
        clk => clk,
        clk_en => clk_en,
        control => control,
        rd => rd,
        funct => funct,
        alu_result => alu_result,
        add_result => add_result,
        addr_const => addr_const,
        oper => oper,
        funct_rdd => funct_rdd,
        rd_out => rd_out,
        control_out => control_out
    );
	
	process
		procedure test(
            constant passed_alu_result, passed_add_result,
                        passed_addr_const                   : in std_logic_vector(31 downto 0);
            constant passed_funct                           : in std_logic_vector(3 downto 0);
            constant inst_type                              : in string
		) is
        begin
            alu_result <= passed_alu_result;
            add_result <= passed_add_result;
            addr_const <= passed_addr_const;
            funct <= passed_funct;
            rd <= "11111";
            clk_en <= '1';

			wait for clock_delay;
            clk <= '1';
			wait for clock_delay;
			clk <= '0';
            
            wait for 1 ps;
            assert rd_out = "11111"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"rd_out = " & to_string(rd_out) & "; " &
			"expected = 11111; "
            severity error;
        end procedure test;

        procedure test_lui_jal_jalr is
            constant inst_type : string := "LUI";
        begin
            control <= "10000";
            test(x"FFFFFFFF", x"000000AA", x"55555555", "1111", inst_type);
            assert funct_rdd = x"55555555"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"funct_rdd = " & to_hex_string(funct_rdd) & "; " &
			"expected = 0x55555555; "
			severity error;
        end procedure test_lui_jal_jalr;

        procedure test_auipc is
            constant inst_type : string := "AUIPC";
        begin
            control <= "10001";
            test(x"FFFFFFFF", x"000000AA", x"55555555", "1111", inst_type);
            assert funct_rdd = x"000000AA"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"funct_rdd = " & to_hex_string(funct_rdd) & "; " &
			"expected = 0x000000AA; "
			severity error;
        end procedure test_auipc;

        procedure test_load(
            constant passed_add_result, expected  : in std_logic_vector(31 downto 0)
        ) is
            constant inst_type : string := "LOAD";
        begin
            control <= "11011";
            test(x"FFFFFFFF", passed_add_result, x"55555555", "1110", inst_type);
            assert oper = expected
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
            "addr = " & to_hex_string(passed_add_result) & "; " &
			"oper = 0x" & to_hex_string(oper) & "; " &
			"expected = 0x" & to_hex_string(expected) & "; "
            severity error;
            assert funct_rdd = x"0000000E"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"funct_rdd = " & to_hex_string(funct_rdd) & "; " &
			"expected = 0x0000000E; "
			severity error;
        end procedure test_load;

        procedure test_store(
            constant passed_add_result, passed_alu_result : in std_logic_vector(31 downto 0)
        ) is	
            constant inst_type : string := "STORE";
        begin
            control <= "00101";
            test(passed_alu_result, passed_add_result, x"55555555", "1110", inst_type);
        end procedure test_store;

        procedure test_op_opimm is
            constant inst_type : string := "OP";
        begin
            control <= "10010";
            test(x"FFFFFFFF", x"000000AA", x"55555555", "1111", inst_type);
            assert funct_rdd = x"FFFFFFFF"
            report "Unexcpected result: " &
            "instruction type = " & inst_type & "; " &
			"funct_rdd = " & to_hex_string(funct_rdd) & "; " &
			"expected = 0xFFFFFFFF; "
			severity error;
        end procedure test_op_opimm;
    begin
        test_lui_jal_jalr; -- check the addr_const is propgated output of funct_rdd

        test_auipc; -- check the add_result is propgated output of funct_rdd

        test_op_opimm; -- check the alu_result is propgated output of funct_rdd

        test_load(x"00000004", x"00000000"); -- check no data stored in byte address 4

        test_store(x"00000004", x"AAAAAAAA"); -- store data in byte address 4

        test_load(x"00000004", x"AAAAAAAA"); -- check data stored in byte address 4
        wait for 10 ns;
		wait;
	end process;
end behaviour;