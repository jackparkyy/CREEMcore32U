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
	
	signal inst		: std_logic_vector(31 downto 2);
	signal imm		: std_logic_vector(31 downto 0);

-- concurrent statements
begin
	-- instantiate alu
	u32_immediate_decoder : entity work.u32_immediate_decoder
	port map (
		inst => inst,
		imm => imm
	);
	
	simulation : process
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
			report "Unexpected result: " &
			"instruction type = " & inst_type & "; " &
			"opcode = " & to_string(opcode) & "; " &
			"result = " & integer'image(res) & "; " &
			"expected = " & integer'image(expected)
			severity error;
		end procedure test;

		procedure test_itype(
			constant immediate : in std_logic_vector(31 downto 20);
			constant expected : in integer
		) is
			constant inst_type 	: string := "I";
			variable opcode 	: std_logic_vector(6 downto 2);
			variable inst		: std_logic_vector(31 downto 2);
		begin
			opcode := "00100";
			inst := immediate & (19 downto 7 => '1') & opcode;
			test(inst_type, opcode, inst, expected);
			opcode := "11001";
			test(inst_type, opcode, inst, expected);
			opcode := "00000";
			test(inst_type, opcode, inst, expected);
		end procedure test_itype;
	begin
		test_itype("000000000100", 5);
		wait;
	end process simulation;
end behaviour;