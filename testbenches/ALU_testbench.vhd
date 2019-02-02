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
	u32_alu : entity work.u32_alu
	port map (
		operand1 => operand1,
		operand2 => operand2,
		alu_control => alu_control,
		result => result,
		zero => zero
	);
	
	process
		procedure test(
			constant operation : in string;
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
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

		procedure test_add(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "ADD";	
		begin
			alu_control <= "0000";
			test(operation, value1, value2, expected);
		end procedure test_add;

		procedure test_slt(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SLT";	
		begin
			alu_control <= "0001";
			test(operation, value1, value2, expected);
		end procedure test_slt;
		
		procedure test_sltu(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SLTU";	
		begin
			alu_control <= "0010";
			test(operation, value1, value2, expected);
		end procedure test_sltu;

		procedure test_and(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "AND";	
		begin
			alu_control <= "0011";
			test(operation, value1, value2, expected);
		end procedure test_and;

		procedure test_or(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "OR";	
		begin
			alu_control <= "0100";
			test(operation, value1, value2, expected);
		end procedure test_or;

		procedure test_xor(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "XOR";	
		begin
			alu_control <= "0101";
			test(operation, value1, value2, expected);
		end procedure test_xor;

		procedure test_sll(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SLL";	
		begin
			alu_control <= "0110";
			test(operation, value1, value2, expected);
		end procedure test_sll;

		procedure test_srl(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SRL";	
		begin
			alu_control <= "0111";
			test(operation, value1, value2, expected);
		end procedure test_srl;

		procedure test_sra(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SRA";	
		begin
			alu_control <= "1000";
			test(operation, value1, value2, expected);
		end procedure test_sra;

		procedure test_sub(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "SUB";	
		begin
			alu_control <= "1001";
			test(operation, value1, value2, expected);
		end procedure test_sub;

		procedure test_pass(
			constant value1 : in integer;
			constant value2 : in integer;
			constant expected : in integer
		) is
			constant operation : string := "PASS";	
		begin
			alu_control <= "1010";
			test(operation, value1, value2, expected);
		end procedure test_pass;
	begin
		test_add(0, 0, 0);
		test_add(10, 10, 20);
		test_add(-10, -10, -20);
		test_add(-10, 10, 0);
		test_add(2147483647, -2147483648, -1);
		test_add(-2147483648, -1, 2147483647); -- overflow
		test_add(2147483647, 1, -2147483648); -- overflow

		test_slt(-1, 0, 1);
		test_slt(0, -1, 0);
		test_slt(-2147483648, 2147483647, 1);
		test_slt(2147483647, -2147483648, 0);
		test_slt(0, 0, 0);

		test_sltu(-1, 0, 0);
		test_sltu(0, -1, 1);
		test_sltu(-2147483648, 2147483647, 0);
		test_sltu(2147483647, -2147483648, 1);
		test_sltu(0, 0, 0);

		test_and(9, 13, 9);
		test_and(-1, -1, -1); -- all 1's
		test_and(0, 0, 0); -- all 0's
		test_and(-1, 0, 0);
		test_and(0, -1, 0);

		test_or(9, 13, 13);
		test_or(-1, -1, -1); -- all 1's
		test_or(0, 0, 0); -- all 0's
		test_or(-1, 0, -1);
		test_or(0, -1, -1);

		test_xor(9, 13, 4);
		test_xor(-1, -1, 0);
		test_xor(0, 0, 0);
		test_xor(-1, 0, -1);
		test_xor(0, -1, -1);

		test_sll(5, 10, 5120);
		test_sll(-1, -1, -2147483648);
		test_sll(-1, 31, -2147483648);
		test_sll(0, 0, 0);
		test_sll(1431655765, 1, -1431655766);

		test_srl(-65538, 15, 131069);
		test_srl(-1, -1, 1);
		test_srl(-1, 31, 1);
		test_srl(0, 0, 0);
		test_srl(-1431655766, 1, 1431655765);

		test_sra(-1431655766, 1, -715827883);
		test_sra(-1, -1, -1);
		test_sra(-1, 31, -1);
		test_sra(0, 0, 0);
		test_sra(-715827883, 1, -357913942);

		test_sub(0, 0, 0);
		test_sub(10, 10, 0);
		test_sub(-10, -10, 0);
		test_sub(-10, 10, -20);
		test_sub(-2147483648, -2147483648, 0);
		test_sub(2147483647, 2147483647, 0);
		test_sub(2147483647, -1, -2147483648); -- overflow
		test_sub(-2147483648, 1, 2147483647); -- overflow

		test_pass(-100, 8, 8);
		wait;
	end process;
end behaviour;