library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity data_extender_testbench is
end data_extender_testbench;

architecture behaviour of data_extender_testbench is
	-- architecture declarations
	constant time_delta	: time := 100 ns;
	
	signal oper, oper_out   : std_logic_vector(31 downto 0) := (others => '0');
	signal funct		    : std_logic_vector(2 downto 0)  := (others => '0');
begin
	
	data_extender : entity work.u32_data_extender
	port map (
		funct => funct,
        oper => oper,
        oper_out => oper_out
	);
	
	process
		procedure test(
			constant inst_type 	    : in string;
			constant passed_funct 	: in std_logic_vector(2 downto 0);
            constant operand        : in std_logic_vector(31 downto 0);
            constant expected       : in std_logic_vector(31 downto 0)
		) is
			variable res : integer;
        begin
            funct <= passed_funct;
			oper <= operand;
				
			wait for time_delta;

			assert oper_out = expected
			report "unexpected result: " &
			inst_type & "; " &
			"operand = " & to_hex_string(oper_out) & "; " &
			"expected = " & to_hex_string(expected)
			severity error;
		end procedure test;

		procedure test_lb(
            constant operand    : in std_logic_vector(31 downto 0);
            constant expected 	: in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "instruction_type = LB";
		begin
			test(inst_type, "000", operand, expected);
		end procedure test_lb;

		procedure test_lh(
			constant operand    : in std_logic_vector(31 downto 0);
            constant expected 	: in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "instruction_type = LH";
		begin
			test(inst_type, "001", operand, expected);
		end procedure test_lh;

		procedure test_lw(
			constant operand    : in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "instruction_type = LW";
		begin
			test(inst_type, "010", operand, operand);
		end procedure test_lw;

		procedure test_lbu(
			constant operand    : in std_logic_vector(31 downto 0);
            constant expected 	: in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "instruction_type = LBU";
		begin
			test(inst_type, "100", operand, expected);
		end procedure test_lbu;

		procedure test_lhu(
			constant operand    : in std_logic_vector(31 downto 0);
            constant expected 	: in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "instruction_type = LHU";
		begin
			test(inst_type, "101", operand, expected);
		end procedure test_lhu;
	begin
        test_lb(x"00000000", x"00000000");
        test_lb(x"55555555", x"00000055");
        test_lb(x"AAAAAAAA", x"FFFFFFAA");
        test_lb(x"FFFFFFFF", x"FFFFFFFF");

        test_lh(x"00000000", x"00000000");
        test_lh(x"55555555", x"00005555");
        test_lh(x"AAAAAAAA", x"FFFFAAAA");
        test_lh(x"FFFFFFFF", x"FFFFFFFF");
        
        test_lw(x"00000000");
        test_lw(x"55555555");
        test_lw(x"AAAAAAAA");
        test_lw(x"FFFFFFFF");

        test_lbu(x"00000000", x"00000000");
        test_lbu(x"55555555", x"00000055");
        test_lbu(x"AAAAAAAA", x"000000AA");
        test_lbu(x"FFFFFFFF", x"000000FF");

        test_lhu(x"00000000", x"00000000");
        test_lhu(x"55555555", x"00005555");
        test_lhu(x"AAAAAAAA", x"0000AAAA");
        test_lhu(x"FFFFFFFF", x"0000FFFF");
		wait;
	end process;
end behaviour;