library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the immediate decoder and its external environment
entity u32_immediate_decoder is
	port (
		inst    : in inst_vector := (others => '0');
		imm	    : out word_vector := (others => '0')
	);
end u32_immediate_decoder;

-- define the internal organisation and operation of the immediate decoder
architecture rtl of u32_immediate_decoder is
    signal opcode : opcode_vector := (others => '0');
begin
    opcode <= inst(6 downto 2); -- isolate opcode from instrcution
    
    -- decode immediate
    with opcode select 
    imm <=  inst(xlen downto 12) & (11 downto 0 => '0')                                                 when lui | auipc, -- U-type
            (xlen downto 20 => inst(xlen)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0'   when jal, -- J-type
            (xlen downto 12 => inst(xlen)) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0'     when branch, -- B-type
            (xlen downto 11 => inst(xlen)) & inst(30 downto 25) & inst(11 downto 7)                     when store, -- S-type
            (xlen downto 11 => inst(xlen)) & inst(30 downto 20)                                         when others; -- I-type
end rtl;