library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

-- define the interface between the alu and its external environment
entity immediate_decoder_testbench is
end immediate_decoder_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of immediate_decoder_testbench is
	-- architecture declarations
	constant time_delta	: time := 100 ns;
	
	signal inst		: std_logic_vector(31 downto 2) := (others => '0');
	signal imm		: std_logic_vector(31 downto 0) := (others => '0');

-- concurrent statements
begin
	-- instantiate alu
	u32_immediate_decoder : entity work.u32_immediate_decoder
	port map (
		inst => inst,
		imm => imm
	);
	
	process
		procedure test(
			constant inst_type : in string;
			constant opcode : std_logic_vector(6 downto 2);
			constant instruction : in std_logic_vector(31 downto 2);
			constant expected : in integer
		) is
			variable res : integer;
		begin
			-- assign values to circuit inputs
			inst <= instruction;
				
			wait for time_delta;

			res := conv_integer(imm);

			assert res = expected
			report "unexpected result: " &
			"instruction_type = " & inst_type & "; " &
			"opcode = " & to_string(opcode) & "; " &
			"result = " & integer'image(res) & "; " &
			"expected = " & integer'image(expected)
			severity error;
		end procedure test;

		procedure test_itype(
			constant immediate : in std_logic_vector(31 downto 20);
			constant expected : in integer
		) is
			constant inst_type 	: string := "i";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "00100";
			inst := immediate & (19 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, expected);
			opcode := "11001";
			inst := immediate & (19 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, expected);
			opcode := "00000";
			inst := immediate & (19 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, expected);
		end procedure test_itype;

		procedure test_utype(
			constant immediate : in std_logic_vector(31 downto 12);
			constant expected : in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "u";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "01101";
			inst := immediate & (11 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, conv_integer(expected));
			opcode := "00101";
			inst := immediate & (11 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, conv_integer(expected));
		end procedure test_utype;

		procedure test_jtype(
			constant immediate : in std_logic_vector(31 downto 12);
			constant expected : in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "j";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "11011";
			inst := immediate & (11 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, conv_integer(expected));
		end procedure test_jtype;

		procedure test_btype(
			constant immediate : in std_logic_vector(11 downto 0);
			constant expected : in std_logic_vector(31 downto 0)
		) is
			constant inst_type 	: string := "b";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "11000";
			inst := immediate(11 downto 5) & (24 downto 12 => '1') & immediate(4 downto 0) & opcode;
			test(inst_type, opcode, inst, conv_integer(expected));
		end procedure test_btype;

		procedure test_stype(
			constant immediate : in std_logic_vector(11 downto 0);
			constant expected : in integer
		) is
			constant inst_type 	: string := "s";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "01000";
			inst := immediate(11 downto 5) & (24 downto 12 => '1') & immediate(4 downto 0) & opcode;
			test(inst_type, opcode, inst, expected);
		end procedure test_stype;
	begin
		test_itype(x"000", 0);
		test_itype(x"aaa", -1366);
		test_itype(x"555", 1365);
		test_itype(x"fff", -1);

		test_utype(x"00000", x"00000000");
		test_utype(x"aaaaa", x"aaaaa000");
		test_utype(x"55555", x"55555000");
		test_utype(x"fffff", x"fffff000");

		test_jtype(x"00000", x"00000000");
		test_jtype(x"aaaaa", x"fffaa2aa");
		test_jtype(x"55555", x"00055d54");
		test_jtype(x"fffff", x"fffffffe");

		test_btype(x"000", x"00000000");
		test_btype(x"aaa", x"fffff2aa");
		test_btype(x"555", x"00000d54");
		test_btype(x"fff", x"fffffffe");

		test_stype(x"000", 0);
		test_stype(x"aaa", -1366);
		test_stype(x"555", 1365);
		test_stype(x"fff", -1);
		wait;
	end process;
end behaviour;