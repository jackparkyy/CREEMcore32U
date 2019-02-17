library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.u32_types.all;

entity u32_instruction_memory is
    port (
        clk, write_en               : in std_logic      := '0';
        read_addr, write_inst, write_addr  : in word_vector    := (others => '0');
        inst                        : out word_vector   := (others => '0');
        clk_out                     : out std_logic     := '0'
    );
end u32_instruction_memory;
    
architecture rtl of u32_instruction_memory is
    constant inst_mem_xlen : natural := ((inst_mem_size / 4) - 1);

    type ram is array (0 to inst_mem_xlen) of word_vector;

    signal inst_ram     : ram       := (others => (others => '0'));
    signal booted       : std_logic := '0';
begin
    -- concurrent statements (read)
    inst <= inst_ram(to_integer(unsigned(read_addr)));

    clk_out <= clk when booted = '1';

    -- sequential statements (write)
    process 
        variable count : natural range 0 to inst_mem_xlen := 0;
    begin
        wait until rising_edge(clk);
        if booted = '0' then
            if count = inst_mem_xlen then
                booted <= '1';
            else
                count := count + 1;
            end if;
        end if;
        if write_en = '1' then
            inst_ram(to_integer(unsigned(write_addr))) <= write_inst;
        end if;
    end process;
end rtl;