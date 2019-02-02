library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use work.u32_types.all;

-- define the interface between the alu and its external environment
entity u32_alu is
	port (
		operand1, operand2		: in word_vector := (others => '0');
		alu_control	: in nibble_vector := (others => '0');
		result		: out word_vector := (others => '0');
		zero		: out std_logic := '0'
	);
end u32_alu;

-- define the internal organisation and operation of the alu
architecture behaviour of u32_alu is
	-- architecture declarations
	signal shamt		: std_logic_vector(4 downto 0) := (others => '0');
	signal aluresult	: word_vector := (others => '0');

-- concurrent statements
begin
	shamt <= operand2(4 downto 0);
	result <= aluresult;
	zero <= '1' when aluresult = (31 downto 0 => '0') else '0';
	
	process (alu_control, operand1, operand2, shamt)
	begin
		case alu_control is
			when alu_slt => 
				if operand1 < operand2 then
					aluresult <= (31 downto 1 => '0') & '1';
				else
					aluresult <= (others => '0');
				end if;
			when alu_sltu => 
				if unsigned(operand1) < unsigned(operand2) then
					aluresult <= (31 downto 1 => '0') & '1';
				else
					aluresult <= (others => '0');
				end if;
			when alu_and => 
				aluresult <= operand1 and operand2;
			when alu_or => 
				aluresult <= operand1 or operand2;
			when alu_xor => 
				aluresult <= operand1 xor operand2;
			when alu_sll => 
				aluresult <= std_logic_vector(shift_left(unsigned(operand1), to_integer(unsigned(shamt))));
			when alu_srl => 
				aluresult <= std_logic_vector(shift_right(unsigned(operand1), to_integer(unsigned(shamt))));
			when alu_sra =>
				aluresult <= std_logic_vector(shift_right(signed(operand1), to_integer(unsigned(shamt))));
			when alu_sub =>
				aluresult <= operand1 - operand2;
			when alu_pass => 
				aluresult <= operand2;
			when others => 
				aluresult <= operand1 + operand2;
		end case;
	end process;
end behaviour;