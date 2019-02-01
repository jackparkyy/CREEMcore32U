library ieee;
use ieee.std_logic_1164.all;

package rv32i_types is
    subtype word is std_logic_vector(31 downto 0);
    subtype half_word is std_logic_vector(15 downto 0);
    subtype byte is std_logic_vector(7 downto 0);
end package rv32i_types;