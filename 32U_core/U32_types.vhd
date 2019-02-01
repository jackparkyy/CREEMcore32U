library ieee;
use ieee.std_logic_1164.all;

package u32_types is
    constant alu_add    : std_logic_vector(3 downto 0) := "0000";
    constant alu_slt    : std_logic_vector(3 downto 0) := "0001";
    constant alu_sltu   : std_logic_vector(3 downto 0) := "0010";
    constant alu_and    : std_logic_vector(3 downto 0) := "0011";
    constant alu_or     : std_logic_vector(3 downto 0) := "0100";
    constant alu_xor    : std_logic_vector(3 downto 0) := "0101";
    constant alu_sll    : std_logic_vector(3 downto 0) := "0110";
    constant alu_srl    : std_logic_vector(3 downto 0) := "0111";
    constant alu_sra    : std_logic_vector(3 downto 0) := "1000";
    constant alu_sub    : std_logic_vector(3 downto 0) := "1001";
    constant alu_pass   : std_logic_vector(3 downto 0) := "1010";
end package u32_types;