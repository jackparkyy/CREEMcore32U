library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the immediate decoder and its external environment
entity u32_immediate_decoder is
	port (
		inst    : in inst_vector;
		imm	    : out word_vector
	);
end u32_immediate_decoder;

-- define the internal organisation and operation of the immediate decoder
architecture behaviour of u32_immediate_decoder is
    signal opcode : opcode_vector;
begin
    opcode <= inst(6 downto 2); -- isolate opcode from instrcution
    
    with opcode select 
    imm <=  inst(31 downto 12) & (11 downto 0 => '0')                                               when lui, -- U-type
            inst(31 downto 12) & (11 downto 0 => '0')                                               when auipc, -- U-type
            (31 downto 20 => inst(31)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0'   when jal, -- J-type
            (31 downto 12 => inst(31)) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0'     when branch, -- B-type
            (31 downto 11 => inst(31)) & inst(30 downto 25) & inst(11 downto 7)                     when store, -- S-type
            (31 downto 11 => inst(31)) & inst(30 downto 20)                                         when others; -- I-type
end behaviour;