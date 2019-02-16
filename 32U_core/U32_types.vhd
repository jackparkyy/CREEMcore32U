library ieee;
use ieee.std_logic_1164.all;

package u32_types is
    -- set bit length of architecture
    constant xlen			: natural := 31;
    
    subtype word_vector is std_logic_vector(31 downto 0);
    subtype half_word_vector is std_logic_vector(15 downto 0);
    subtype byte_vector is std_logic_vector(7 downto 0);
    subtype nibble_vector is std_logic_vector(3 downto 0);
    subtype inst_vector is std_logic_vector(31 downto 2);
    subtype opcode_vector is std_logic_vector(6 downto 2);
    subtype inst_mem_addr is std_logic_vector(5 downto 0);

    -- opcode suffix, always 11 for rx32i architectures
    constant suffix : std_logic_vector(1 downto 0) := "11";

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

    constant inst_mem_len   : integer := 63;
end package u32_types;