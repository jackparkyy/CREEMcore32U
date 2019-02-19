library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the alu and its external environment
entity u32_branch_controller is
	port (
		zero, branch, jump	: in std_logic := '0';
        funct	            : in std_logic_vector(2 downto 0) := (others => '0');
        pc_src               : out std_logic := '0'
	);
end u32_branch_controller;

-- define the internal organisation and operation of the alu
architecture rtl of u32_branch_controller is
-- concurrent statements
begin
	pc_src <=    '1' when jump = '1' else
                '1' when branch & zero & funct = "11000" else -- BEQ and equal
                '1' when branch & zero & funct = "10001" else -- BNE and not equal
                '1' when branch & zero & funct = "10100" else -- BLT and less than
                '1' when branch & zero & funct = "11101" else -- BGE and greater than or equal
                '1' when branch & zero & funct = "10110" else -- BLTU and less than
                '1' when branch & zero & funct = "11111" else -- BGEU and greater than or equal
                '0';
end rtl;