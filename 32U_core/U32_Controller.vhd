library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_controller is
    port(
        opcode  : in opcode_vector := (others => '0');
        control	: out std_logic_vector(8 downto 0) := (others => '0')
    );
end u32_controller;

-- define the internal organisation and operation of the general purpose registers
architecture behaviour of u32_controller is
    
begin
    -- concurrent statements
    with opcode select 
	control <=  "100001000"	when lui,
				"100010000"	when auipc,
				"100101100"	when op,
				"100000001"	when jal,
				"100000101"	when jalr,
				"000011010"	when branch,
				"110110100"	when load,
				"001011100"	when store,
				"100100000"	when others; --opimm
end behaviour;