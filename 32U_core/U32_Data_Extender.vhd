library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_data_extender is
	port (
        funct       : in std_logic_vector(2 downto 0)   := (others => '0');
        oper        : in word_vector                    := (others => '0');
		oper_out    : out word_vector                   := (others => '0')
	);
end u32_data_extender;

architecture rtl of u32_data_extender is
    
begin
    with funct select
    oper_out <= (xlen downto 7 => oper(7)) & oper(6 downto 0) when "000",
                (xlen downto 15 => oper(15)) & oper(14 downto 0) when "001",
                (xlen downto 8 => '0') & oper(7 downto 0) when "100",
                (xlen downto 16 => '0') & oper(15 downto 0) when "101",
                oper when others;
end rtl;