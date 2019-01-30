library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-- define the interface between the alu and its external environment
entity alu is
	port (
		operand1, operand2		: in std_logic_vector(31 downto 0);
		alu_control	: in std_logic_vector(3 downto 0);
		result		: out std_logic_vector(31 downto 0);
		zero		: out std_logic := '0'
	);
end alu;

-- define the internal organisation and operation of the alu
architecture behaviour of alu is
	-- architecture declarations
	signal shamt		: std_logic_vector(4 downto 0);
	signal aluresult	: std_logic_vector(31 downto 0);

-- concurrent statements
begin
	shamt <= operand2(4 downto 0);
	result <= aluresult;
	zero <= '1' when aluresult = (31 downto 0 => '0') else '0';
	
	process (alu_control, operand1, operand2, shamt)
	begin
		case alu_control is
			-- slt
			when "0001" => 
				if operand1 < operand2 then
					aluresult <= (31 downto 1 => '0') & '1';
				else
					aluresult <= (others => '0');
				end if;
			-- sltu
			when "0010" => 
				if unsigned(operand1) < unsigned(operand2) then
					aluresult <= (31 downto 1 => '0') & '1';
				else
					aluresult <= (others => '0');
				end if;
			-- and
			when "0011" => 
				aluresult <= operand1 and operand2;
			-- or
			when "0100" => 
				aluresult <= operand1 or operand2;
			-- xor
			when "0101" => 
				aluresult <= operand1 xor operand2;
			-- sll
			when "0110" => 
				aluresult <= std_logic_vector(shift_left(unsigned(operand1), to_integer(unsigned(shamt))));
			-- srl
			when "0111" => 
				aluresult <= std_logic_vector(shift_right(unsigned(operand1), to_integer(unsigned(shamt))));
			-- sra
			when "1000" =>
				aluresult <= std_logic_vector(shift_right(signed(operand1), to_integer(unsigned(shamt))));
			-- sub
			when "1001" =>
				aluresult <= operand1 - operand2;
			-- pass
			when "1010" => 
				aluresult <= operand2;
			-- add
			when others => 
				aluresult <= operand1 + operand2;
		end case;
	end process;
end behaviour;