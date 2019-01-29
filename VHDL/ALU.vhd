library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

-- define the interface between the ALU and its external environment
ENTITY ALU IS
	PORT (
		a, b			: IN std_logic_vector(31 downto 0);
		ALUcontrol	: IN std_logic_vector(3 downto 0);
		result		: OUT std_logic_vector(31 downto 0);
		zero			: OUT std_logic
	);
END ALU;

-- define the internal organisation and operation of the ALU
ARCHITECTURE behaviour OF ALU IS
	-- architecture declarations
	SIGNAL shamt		: natural;
	SIGNAL ALUresult	: std_logic_vector(31 downto 0);

	-- concurrent statements
	BEGIN
		shamt <= conv_integer(b(4 downto 0));
		result <= ALUresult;
		zero <= '1' WHEN ALUresult = (31 downto 0 => '0') ELSE '0';
		
		PROCESS (ALUcontrol, a, b) BEGIN
			CASE ALUcontrol IS
				-- SLT
				WHEN "0001" => 
					IF a < b THEN
						ALUresult <= (31 downto 1 => '0') & '1';
					ELSE
						ALUresult <= (others => '0');
					END IF;
				-- SLTU
				WHEN "0010" => 
					IF a < b THEN
						ALUresult <= (31 downto 1 => '0') & '1';
					ELSE
						ALUresult <= (others => '0');
					END IF;
				-- AND
				WHEN "0011" => 
					ALUresult <= a and b;
				-- OR
				WHEN "0100" => 
					ALUresult <= a or b;
				-- XOR
				WHEN "0101" => 
					ALUresult <= a xor b;
				-- SLL
				WHEN "0110" => 
					ALUresult <= std_logic_vector(shift_left(unsigned(a), shamt));
				-- SRL
				WHEN "0111" => 
					ALUresult <= std_logic_vector(shift_right(unsigned(a), shamt));
				-- SRA
				WHEN "1000" =>
					ALUresult <= std_logic_vector(shift_left(signed(a), shamt));
				-- SUB
				WHEN "1001" =>
					ALUresult <= a - b;
				-- PASS
				WHEN "1010" => 
					ALUresult <= b;
				-- ADD
				WHEN others => 
					ALUresult <= a + b;
			END CASE;
		END PROCESS;
END behaviour;