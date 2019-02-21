library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package u32_types is
    -- set bit length of architecture
    constant xlen			: natural := 31;

    -- opcode suffix, always 11 for rx32i architectures
    constant suffix : std_logic_vector(1 downto 0) := "11";

    -- size of ram in bytes (should be a power of 2 e.g. 256, 512, 1024, etc)
    constant data_mem_size : natural := 256;
    constant inst_mem_size : natural := 256;
    
    -- subtypes used throughout the u32 core
    subtype word_vector is std_logic_vector(31 downto 0);
    subtype half_word_vector is std_logic_vector(15 downto 0);
    subtype byte_vector is std_logic_vector(7 downto 0);
    subtype nibble_vector is std_logic_vector(3 downto 0);
    subtype inst_vector is std_logic_vector(31 downto 2);
    subtype opcode_vector is std_logic_vector(6 downto 2);
    subtype addr_vector is std_logic_vector(4 downto 0);

    -- opcodes reduced down from 7 bits to 5 by excluding the architectures suffix
    constant lui    : opcode_vector := "01101";
    constant auipc  : opcode_vector := "00101";
    constant opimm  : opcode_vector := "00100";
    constant op     : opcode_vector := "01100";
    constant jal    : opcode_vector := "11011";
    constant jalr   : opcode_vector := "11001";
    constant branch : opcode_vector := "11000";
    constant load   : opcode_vector := "00000";
    constant store  : opcode_vector := "01000";

    -- alu cotnrol
    constant alu_add    : nibble_vector := "0000";
    constant alu_slt    : nibble_vector := "0001";
    constant alu_sltu   : nibble_vector := "0010";
    constant alu_and    : nibble_vector := "0011";
    constant alu_or     : nibble_vector := "0100";
    constant alu_xor    : nibble_vector := "0101";
    constant alu_sll    : nibble_vector := "0110";
    constant alu_srl    : nibble_vector := "0111";
    constant alu_sra    : nibble_vector := "1000";
    constant alu_sub    : nibble_vector := "1001";
    constant alu_pass   : nibble_vector := "1010";

    function log2 (x : natural) return natural;
end package u32_types;

package body u32_types is
    function log2 (x : natural) return natural is
        variable i : natural := 0;
    begin
        i := 0;
        while (2**i < x) and i < 31 loop
            i := i + 1;
        end loop;
        return i;
    end function;
end package body u32_types;