library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.u32_types.all;

-- define the interface between the data memory and its external environment
entity u32_data_memory is
    port (
        clk, write_en, read_en  : in std_logic := '0';
        funct                   : in std_logic_vector(1 downto 0) := (others => '0');
        addr, write_data        : in word_vector := (others => '0');
        read_data               : out word_vector := (others => '0')
    );
end u32_data_memory;
    
-- define the internal organisation and operation of the data memory
architecture behavioral of u32_data_memory is
    -- define array
    type byte_ram is array (0 to (data_mem_size - 1)) of byte_vector;

    subtype byte_addr is natural range 0 to (data_mem_size - 1);

    signal ram_addr : byte_addr := 0;
    signal data_mem : byte_ram := (others => (others => '0'));
    signal data     : word_vector := (others => '0');

    constant third_last_byte    : byte_addr := (data_mem_size - 3);
    constant second_last_byte   : byte_addr := (data_mem_size - 2);
    constant last_byte          : byte_addr := (data_mem_size - 1);

    constant byte           : std_logic_vector(1 downto 0) := "00";
    constant half_word      : std_logic_vector(1 downto 0) := "01";
    constant word           : std_logic_vector(1 downto 0) := "10";
begin
    ram_addr <= to_integer(unsigned(addr((log2(data_mem_size) - 1) downto 0)));

    -- read word from data memory, padding with zeros if the address is the last, second to last or third to
    -- last byte address
    data <= x"000000"   & data_mem(ram_addr)       when ram_addr = last_byte else
            x"0000"     & data_mem(ram_addr + 1)
                        & data_mem(ram_addr)       when ram_addr = second_last_byte else
            x"00"       & data_mem(ram_addr + 2)
                        & data_mem(ram_addr + 1)
                        & data_mem(ram_addr)       when ram_addr = third_last_byte else
            data_mem(ram_addr + 3) &
            data_mem(ram_addr + 2) &
            data_mem(ram_addr + 1) &
            data_mem(ram_addr);

    read_data <= data when (read_en = '1') else x"00000000"; -- do not return data unless read enable is high

    process begin
        wait until rising_edge(clk);
        -- write word into data memory when address is anything other than the last, second to last or
        -- third to last byte address
        if (write_en = '1' and funct = word and ram_addr /= last_byte and ram_addr /= second_last_byte and
            ram_addr /= third_last_byte) then
            data_mem(ram_addr) <= write_data(7 downto 0);
            data_mem(ram_addr + 1) <= write_data(15 downto 8);
            data_mem(ram_addr + 2) <= write_data(23 downto 16);
            data_mem(ram_addr + 3) <= write_data(31 downto 24);
        -- write first three bytes of word into data mem when address is third to last byte address
        elsif (write_en = '1' and funct = word and ram_addr /= last_byte and ram_addr /= second_last_byte) then
            data_mem(ram_addr) <= write_data(7 downto 0);
            data_mem(ram_addr + 1) <= write_data(15 downto 8);
            data_mem(ram_addr + 2) <= write_data(23 downto 16);
        -- write half-word into data mem or last two byte of a word when address is second to last byte address
        elsif (write_en = '1' and funct /= byte and ram_addr /= last_byte) then
            data_mem(ram_addr) <= write_data(7 downto 0);
            data_mem(ram_addr + 1) <= write_data(15 downto 8);
        -- write byte into data memory
        elsif (write_en = '1') then
            data_mem(ram_addr) <= write_data(7 downto 0);
        end if;
    end process;
end behavioral;