library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.u32_types.all;

entity u32_data_memory is
    port (
        clk, mem_write, mem_read   : in std_logic := '0';
        funct                      : in std_logic_vector(2 downto 0) := (others => '0');
        addr, write_data           : in word_vector := (others => '0');
        read_data                  : out word_vector := (others => '0')
    );
end u32_data_memory;
    
architecture behavioral of u32_data_memory is
    type data_mem is array (0 to 255) of byte_vector;

    signal ram_addr : byte_vector := (others => '0');
    signal ram      : data_mem := (others => (others => '0'));
    signal word     : word_vector := (others => '0');

    signal half_word : std_logic := '0';
begin
    half_word <= funct(0);

    ram_addr <= x"FC" when (mem_read = '1' or (funct /= "000" or funct /= "001")) and addr(7 downto 0) = x"FD" else
                x"FC" when (mem_read = '1' or (funct /= "000" or funct /= "001")) and addr(7 downto 0) = x"FE" else
                x"FC" when (mem_read = '1' or (funct /= "000" or funct /= "001")) and addr(7 downto 0) = x"FF" else
                x"FE" when half_word = '1' and addr(7 downto 0) = x"FF" else
                addr(7 downto 0);

    word <= x"000000" & ram(to_integer(unsigned(ram_addr))) when (to_integer(unsigned(ram_addr)) mod 4) = 0 else;
            ram(to_integer(unsigned(ram_addr)) + 3) &
            ram(to_integer(unsigned(ram_addr)) + 2) &
            ram(to_integer(unsigned(ram_addr)) + 1) &
            ram(to_integer(unsigned(ram_addr)));

    read_data <= word when (mem_read = '1') else x"00000000";

    process begin
        wait until rising_edge(clk);
        if (mem_write = '1') then
            ram(to_integer(unsigned(ram_addr))) <= write_data(7 downto 0);
            ram(to_integer(unsigned(ram_addr)) + 1) <= write_data(15 downto 8);
            ram(to_integer(unsigned(ram_addr)) + 2) <= write_data(23 downto 16);
            ram(to_integer(unsigned(ram_addr)) + 3) <= write_data(31 downto 24);
        end if;
    end process;
end behavioral;