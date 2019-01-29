library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-- define the interface between the alu and its external environment
entity alu_testbench is
end alu_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of alu_testbench is
	-- architecture declarations
	constant xlen			: natural := 31;
	constant time_delta	: time := 100 ns;
	
	signal operand1, operand2		: std_logic_vector(xlen downto 0);
	signal alu_control		: std_logic_vector(3 downto 0);
	signal result			: std_logic_vector(xlen downto 0);
	signal zero			: std_logic;

-- concurrent statements
begin
	-- instantiate alu
	alu : entity work.alu
	port map (
		operand1 => operand1,
		operand2 => operand2,
		alu_control => alu_control,
		result => result,
		zero => zero
	);
	
	simulation : process
		procedure test(constant operation : in string; constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			variable res : integer;
		begin
			-- assign values to circuit inputs
			operand1 <= std_logic_vector(to_signed(value1, operand1'length));
			operand2 <= std_logic_vector(to_signed(value2, operand2'length));
				
			wait for time_delta;

			res := conv_integer(result);
			assert res = expected
			report "Unexpected result: " &
			"operation = " & operation & "; " &
			"operand1 = " & integer'image(value1) & "; " &
			"operand2 = " & integer'image(value2) & "; " &
			"result = " & integer'image(res) & "; " &
			"expected = " & integer'image(expected)
			severity error;
		end procedure test;

		procedure test_add(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "ADD";	
		begin
			alu_control <= "0000";
			test(operation, value1, value2, expected);
		end procedure test_add;

		procedure test_slt(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SLT";	
		begin
			alu_control <= "0001";
			test(operation, value1, value2, expected);
		end procedure test_slt;
		
		procedure test_sltu(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SLTU";	
		begin
			alu_control <= "0010";
			test(operation, value1, value2, expected);
		end procedure test_sltu;

		procedure test_and(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "AND";	
		begin
			alu_control <= "0011";
			test(operation, value1, value2, expected);
		end procedure test_and;

		procedure test_or(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "OR";	
		begin
			alu_control <= "0100";
			test(operation, value1, value2, expected);
		end procedure test_or;

		procedure test_xor(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "XOR";	
		begin
			alu_control <= "0101";
			test(operation, value1, value2, expected);
		end procedure test_xor;

		procedure test_sll(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SLL";	
		begin
			alu_control <= "0110";
			test(operation, value1, value2, expected);
		end procedure test_sll;

		procedure test_srl(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SRL";	
		begin
			alu_control <= "0111";
			test(operation, value1, value2, expected);
		end procedure test_srl;

		procedure test_sra(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SRA";	
		begin
			alu_control <= "1000";
			test(operation, value1, value2, expected);
		end procedure test_sra;

		procedure test_sub(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "SUB";	
		begin
			alu_control <= "1001";
			test(operation, value1, value2, expected);
		end procedure test_sub;

		procedure test_pass(constant value1 : in integer; constant value2 : in integer; constant expected : in integer) is
			constant operation : string := "PASS";	
		begin
			alu_control <= "1010";
			test(operation, value1, value2, expected);
		end procedure test_pass;
	begin
		test_add(10, 10, 20);
		test_slt(3, 4, 1);
		test_sltu(4, 3, 0);
		test_and(9, 13, 9);
		test_or(9, 13, 13);
		test_xor(9, 13, 4);
		test_sll(1, 2, 4);
		test_srl(5, 2 ,1);
		test_sra(5, 2, 1);
		test_sub(-13, -13, 0);
		test_pass(-100, 8, 8);
		wait;
	end process simulation;
end behaviour;