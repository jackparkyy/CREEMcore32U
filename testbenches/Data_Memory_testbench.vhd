library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the interface between the alu and its external environment
entity data_memory_testbench is
end data_memory_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of data_memory_testbench is
	-- architecture declarations
	constant clock_delay	: time := 10 ns;

    signal clk, write_en, read_en     : std_logic := '0';
	signal addr, write_data, read_data 	: std_logic_vector(31 downto 0) := (others => '0');
	signal funct 						: std_logic_vector(1 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate alu_controller
	data_memory : entity work.u32_data_memory
	port map (
		clk => clk,
		write_en => write_en,
		read_en => read_en,
		funct => funct,
		addr => addr,
		write_data => write_data,
		read_data => read_data
	);
	
	process
		procedure test_read(
			constant address, expected	: in std_logic_vector(31 downto 0)
		) is begin
			addr <= address;
			read_en <= '1';
			write_en <= '0';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';

			assert read_data = expected
			report "Unexpected data: " &
			"data = 0x" & to_hex_string(read_data) & "; " &
			"expected = 0x" & to_hex_string(expected) & "; "
			severity error;
		end procedure test_read;

		procedure test_write(
			constant address, data	: in std_logic_vector(31 downto 0);
			constant size           : in std_logic_vector(1 downto 0)
		) is begin
			addr <= address;
			read_en <= '0';
			write_en <= '1';
			write_data <= data;
			funct <= size;

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';
		end procedure test_write;
	begin
		-- test vectors set based on data mem size of 256B
		test_read(x"00000000", x"00000000");
		test_write(x"00000000", x"FFFFFFFF", "10");
		test_read(x"00000000", x"FFFFFFFF");

		test_read(x"00000009", x"00000000");
		test_write(x"00000009", x"FFFFFFFF", "10");
		test_read(x"00000009", x"FFFFFFFF");

		test_read(x"000000FC", x"00000000");
		test_read(x"000000FD", x"00000000");
		test_read(x"000000FE", x"00000000");
		test_read(x"000000FF", x"00000000");
		test_write(x"000000FC", x"FF55AA11", "10");
		test_read(x"000000FC", x"FF55AA11");
		test_read(x"000000FD", x"00FF55AA");
		test_read(x"000000FE", x"0000FF55");
		test_read(x"000000FF", x"000000FF");

		test_write(x"000000FD", x"44444444", "10");
		test_read(x"000000FD", x"00444444");
		test_read(x"000000FC", x"44444411");
		test_write(x"000000FE", x"AAAAAAAA", "10");
		test_read(x"000000FE", x"0000AAAA");
		test_read(x"000000FC", x"AAAA4411");
		test_write(x"000000FF", x"FFFFFFFF", "10");
		test_read(x"000000FF", x"000000FF");
		test_read(x"000000FC", x"FFAA4411");
		
		test_write(x"000000FC", x"FFFFFFFF", "01");
		test_read(x"000000FC", x"FFAAFFFF");
		test_write(x"000000FD", x"55555555", "01");
		test_read(x"000000FC", x"FF5555FF");
		test_write(x"000000FE", x"AAAAAAAA", "01");
		test_read(x"000000FC", x"AAAA55FF");
		test_write(x"000000FF", x"11111111", "01");
		test_read(x"000000FC", x"11AA55FF");

		test_write(x"000000FC", x"44444444", "00");
		test_read(x"000000FC", x"11AA5544");
		test_write(x"000000FD", x"FFFFFFFF", "00");
		test_read(x"000000FC", x"11AAFF44");
		test_write(x"000000FE", x"55555555", "00");
		test_read(x"000000FC", x"1155FF44");
		test_write(x"000000FF", x"AAAAAAAA", "00");
		test_read(x"000000FC", x"AA55FF44");
		wait;
	end process;
end behaviour;