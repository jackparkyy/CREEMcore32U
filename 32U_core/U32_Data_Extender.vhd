library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the data extender and its external environment
entity u32_data_extender is
	port (
        funct       : in std_logic_vector(2 downto 0)   := (others => '0');
        oper        : in word_vector                    := (others => '0');
		oper_out    : out word_vector                   := (others => '0')
	);
end u32_data_extender;

-- define the internal organisation and operation of the data extender
architecture rtl of u32_data_extender is
    constant lb   : std_logic_vector(2 downto 0) := "000";
    constant lh   : std_logic_vector(2 downto 0) := "001";
    constant lbu   : std_logic_vector(2 downto 0) := "100";
    constant lhu   : std_logic_vector(2 downto 0) := "101";
begin
    with funct select
    oper_out <= (xlen downto 7 => oper(7)) & oper(6 downto 0) when lb, -- sign extend byte
                (xlen downto 15 => oper(15)) & oper(14 downto 0) when lh, -- sign extend half word
                (xlen downto 8 => '0') & oper(7 downto 0) when lbu, -- zero extend byte
                (xlen downto 16 => '0') & oper(15 downto 0) when lhu, -- zero extend half word
                oper when others; -- passthrough
end rtl;