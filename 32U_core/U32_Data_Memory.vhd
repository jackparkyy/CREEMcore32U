library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.u32_types.all;

entity u32_data_memory is
    port (
        clk, mem_write, mem_read   : in std_logic := '0';
        funct                      : in std_logic_vector(1 downto 0) := (others => '0');
        addr, write_data           : in word_vector := (others => '0');
        read_data                  : out word_vector := (others => '0')
    );
end u32_data_memory;
    
architecture behavioral of u32_data_memory is
    type data_mem is array (0 to 255) of byte_vector;

    signal ram_addr : byte_vector := (others => '0');
    signal ram      : data_mem := (others => (others => '0'));
    signal data     : word_vector := (others => '0');

    constant third_last_byte    : byte_vector := x"FD";
    constant second_last_byte   : byte_vector := x"FE";
    constant last_byte          : byte_vector := x"FF";

    constant byte           : std_logic_vector(1 downto 0) := "00";
    constant half_word      : std_logic_vector(1 downto 0) := "01";
    constant word           : std_logic_vector(1 downto 0) := "10";
begin
    ram_addr <= addr(7 downto 0);

    data <= x"000000"   & ram(to_integer(unsigned(ram_addr)))       when ram_addr = last_byte else
            x"0000"     & ram(to_integer(unsigned(ram_addr)) + 1)
                        & ram(to_integer(unsigned(ram_addr)))       when ram_addr = second_last_byte else
            x"00"       & ram(to_integer(unsigned(ram_addr)) + 2)
                        & ram(to_integer(unsigned(ram_addr)) + 1)
                        & ram(to_integer(unsigned(ram_addr)))       when ram_addr = third_last_byte else
            ram(to_integer(unsigned(ram_addr)) + 3) &
            ram(to_integer(unsigned(ram_addr)) + 2) &
            ram(to_integer(unsigned(ram_addr)) + 1) &
            ram(to_integer(unsigned(ram_addr)));

    read_data <= data when (mem_read = '1') else x"00000000";

    process begin
        wait until rising_edge(clk);
        if (mem_write = '1' and funct = word and ram_addr /= last_byte and ram_addr /= second_last_byte and ram_addr /= third_last_byte) then
            ram(to_integer(unsigned(ram_addr))) <= write_data(7 downto 0);
            ram(to_integer(unsigned(ram_addr)) + 1) <= write_data(15 downto 8);
            ram(to_integer(unsigned(ram_addr)) + 2) <= write_data(23 downto 16);
            ram(to_integer(unsigned(ram_addr)) + 3) <= write_data(31 downto 24);
        elsif (mem_write = '1' and funct = word and ram_addr /= last_byte and ram_addr /= second_last_byte) then
            ram(to_integer(unsigned(ram_addr))) <= write_data(7 downto 0);
            ram(to_integer(unsigned(ram_addr)) + 1) <= write_data(15 downto 8);
            ram(to_integer(unsigned(ram_addr)) + 2) <= write_data(23 downto 16);
        elsif (mem_write = '1' and funct /= byte and ram_addr /= last_byte) then
            ram(to_integer(unsigned(ram_addr))) <= write_data(7 downto 0);
            ram(to_integer(unsigned(ram_addr)) + 1) <= write_data(15 downto 8);
        elsif (mem_write = '1') then
            ram(to_integer(unsigned(ram_addr))) <= write_data(7 downto 0);
        end if;
    end process;
end behavioral;