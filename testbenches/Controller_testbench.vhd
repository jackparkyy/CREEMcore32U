library ieee;
use ieee.std_logic_1164.all;

entity controller_testbench is
end controller_testbench;

architecture behaviour of controller_testbench is
    -- architecture declarations
    constant time_delta	: time := 100 ns;

    signal opcode   : std_logic_vector(4 downto 0) := (others => '0');
    signal control  : std_logic_vector(8 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate controller
	controller : entity work.u32_controller
	port map (
		opcode => opcode,
		control => control
	);
	
	process
		procedure test(
			constant operation  : in std_logic_vector(4 downto 0);
            constant expected       : in std_logic_vector(8 downto 0)
		) is
			
		begin
			-- assign values to circuit inputs
			opcode <= operation;
				
			wait for time_delta;

			assert control = expected
			report "Unexpected result: " &
			"operation = " & to_string(operation) & "; " &
			"result = " & to_string(control) & "; " &
			"expected = " & to_string(expected)
			severity error;
		end procedure test;
    begin
        test("01101", "100001000"); -- LUI
        test("00101", "100010000"); -- AUIPC
        test("11011", "100000001"); -- JAL
        test("11001", "100000101"); -- JALR
        test("11000", "000011010"); -- BRANCH
        test("00000", "110110100"); -- LOAD
        test("01000", "001011100"); -- STORE
        test("00100", "100100000"); -- OP-IMM
        test("01100", "100101100"); -- OP
		wait;
	end process;
end behaviour;