library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_writeback is
    port(
        control             : in std_logic_vector(1 downto 0)   := (others => '0');
        oper, funct_rdd     : in word_vector                    := (others => '0');
        rd                  : in std_logic_vector(4 downto 0)   := (others => '0');
        rd_out              : out std_logic_vector(4 downto 0)  := (others => '0');
        rd_data             : out word_vector                   := (others => '0');
        reg_write           : out std_logic                     := '0'
    );
end u32_writeback;

architecture rtl of u32_writeback is
    signal oper_out : word_vector := (others => '0');
begin
    -- concurrent statements
    u32_data_extender : entity work.u32_data_extender
    port map (
        funct => funct_rdd(2 downto 0),
        oper => oper,
        oper_out => oper_out
    );  
    
    rd_data <= oper_out when control(0) else funct_rdd;
    reg_write <= control(1);
    rd_out <= rd;
end rtl;