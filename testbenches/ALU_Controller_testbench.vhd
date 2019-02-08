library ieee;
use ieee.std_logic_1164.all;

-- define the interface between the alu and its external environment
entity alu_controller_testbench is
end alu_controller_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of alu_controller_testbench is
    -- architecture declarations
    constant time_delta	: time := 100 ns;

    signal aluop                : std_logic_vector(1 downto 0) := (others => '0');
    signal funct, alu_control	: std_logic_vector(3 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate alu_controller
	u32_alu_controller : entity work.u32_alu_controller
	port map (
		aluop => aluop,
		funct => funct,
		alu_control => alu_control
	);
	
	process
		procedure test(
			constant alu_operation  : in std_logic_vector(1 downto 0);
            constant alu_function   : in std_logic_vector(3 downto 0);
            constant expected       : in std_logic_vector(3 downto 0)
		) is
			
		begin
			-- assign values to circuit inputs
			aluop <= alu_operation;
			funct <= alu_function;
				
			wait for time_delta;

			assert alu_control = expected
			report "Unexpected result: " &
			"operation = " & to_string(alu_operation) & "; " &
			"function = " & to_string(alu_function) & "; " &
			"result = " & to_string(alu_control) & "; " &
			"expected = " & to_string(expected)
			severity error;
		end procedure test;
    begin
        -- ADD
        test("10", "0000", "0000"); -- BEQ
        test("10", "1000", "0000"); -- BEQ
        test("10", "0001", "0000"); -- BNE
        test("10", "1001", "0000"); -- BNE
        test("00", "0000", "0000"); -- ADDI
        test("00", "1000", "0000"); -- ADDI
        test("01", "0000", "0000"); -- ADD

        -- SLT
        test("10", "0100", "0001"); -- BLT
        test("10", "1100", "0001"); -- BLT
        test("10", "0101", "0001"); -- BGE
        test("10", "1101", "0001"); -- BGE
        test("00", "0010", "0001"); -- SLTI
        test("00", "1010", "0001"); -- SLTI
        test("01", "0010", "0001"); -- SLT 

        -- SLTU
        test("10", "0110", "0010"); -- BLTU
        test("10", "1110", "0010"); -- BLTU
        test("10", "0111", "0010"); -- BGEU
        test("10", "1111", "0010"); -- BGEU
        test("00", "0011", "0010"); -- SLTIU
        test("00", "1011", "0010"); -- SLTIU
        test("01", "0011", "0010"); -- SLTU

        -- PASS
        test("11", "0000", "1010"); -- SB
        test("11", "1000", "1010"); -- SB
        test("11", "0001", "1010"); -- SH
        test("11", "1001", "1010"); -- SH
        test("11", "0010", "1010"); -- SW
        test("11", "1010", "1010"); -- SW

        -- XOR
        test("00", "0100", "0101"); -- XORI
        test("00", "1100", "0101"); -- XORI
        test("01", "0100", "0101"); -- XOR

        -- OR
        test("00", "0110", "0100"); -- ORI
        test("00", "1110", "0100"); -- ORI
        test("01", "0110", "0100"); -- OR

        -- AND
        test("00", "0111", "0011"); -- ANDI
        test("00", "1111", "0011"); -- ANDI
        test("01", "0111", "0011"); -- AND

        -- SLL
        test("00", "0001", "0110"); -- SLLI
        test("01", "0001", "0110"); -- SLL

        -- SRL
        test("00", "0101", "0111"); -- SRLI
        test("01", "0101", "0111"); -- SRL

        -- SRA
        test("00", "1101", "1000"); -- SRAI
        test("01", "1101", "1000"); -- SRA

        -- SUB
        test("01", "1000", "1001"); -- SUB
		wait;
	end process;
end behaviour;