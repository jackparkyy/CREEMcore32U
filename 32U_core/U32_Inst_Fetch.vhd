library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.u32_types.all;

entity u32_inst_fetch is
    port (
        clk, write_en, pc_src           : in std_logic      := '0';
        write_inst, write_addr, new_pc  : in word_vector    := (others => '0');
        inst, pc_out, next_pc_out       : out word_vector   := (others => '0')
    );
end u32_inst_fetch;
    
architecture rtl of u32_inst_fetch is
    constant increment      : std_logic_vector(xlen downto 0)   := ((xlen downto 1 => '0') & '1');
    constant inst_mem_xlen  : natural                           := ((inst_mem_size / 4) - 1);

    type ram is array (0 to inst_mem_xlen) of word_vector;

    signal pc_reg_in, pc_reg_out, inst_reg  : word_vector   := (others => '0');
    signal inst_ram                         : ram           := (others => (others => '0'));
begin
    -- concurrent statements (read)
    inst_reg <= inst_ram(to_integer(unsigned(pc_reg_out)));

    pc_reg_in <=    new_pc when pc_src = '1' else
                    pc_reg_out + increment;

    -- sequential statements
    process (clk) begin
        if rising_edge(clk) then
            if write_en = '1' then
                inst_ram(to_integer(unsigned(write_addr))) <= write_inst;
            end if;
        elsif falling_edge(clk) then
            pc_reg_out <= pc_reg_in;
            pc_out <= pc_reg_out;
            next_pc_out <= pc_reg_out + increment;
            inst <= inst_reg;
        end if;
    end process;
end rtl;