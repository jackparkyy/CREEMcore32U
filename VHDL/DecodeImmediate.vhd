library ieee;
use ieee.std_logic_1164.all;

entity decodeimmediate is
	port (
		inst    : in std_logic_vector(31 downto 2);
		imm	    : out std_logic_vector(31 downto 0)
	);
end decodeimmediate;

architecture behaviour of decodeimmediate is
    signal opcode : std_logic_vector(4 downto 0);

begin
    opcode <= inst(6 downto 2);
    
    with opcode select 
    imm <=  inst(31 downto 12) & (11 downto 0 => '0') when "01101", -- U-type
            inst(31 downto 12) & (11 downto 0 => '0') when "00101", -- U-type
            (31 downto 20 => inst(31)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0' when "11011", -- J-type
            (31 downto 12 => inst(31)) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0' when "11000", -- B-type
            (31 downto 11 => inst(31)) & inst(30 downto 25) & inst(11 downto 7) when "00100", -- S-type
            (31 downto 11 => inst(31)) & inst(30 downto 20) when others; -- I-type
end behaviour;