library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the interface between the alu and its external environment
entity data_memory_testbench is
end data_memory_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of data_memory_testbench is
	-- architecture declarations
	constant clock_delay	: time := 50 ns;

    signal clk, mem_write, mem_read     : std_logic := '0';
	signal addr, write_data, read_data 	: std_logic_vector(31 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate alu_controller
	data_memory : entity work.u32_data_memory
	port map (
		clk => clk,
		mem_write => mem_write,
		mem_read => mem_read,
		addr => addr,
		write_data => write_data,
		read_data => read_data
	);
	
	process
		procedure test_read(
			constant address, expected : in std_logic_vector(31 downto 0)
		) is
			
		begin
			addr <= address;
			mem_read <= '1';
			mem_write <= '0';

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
			constant address, data	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			addr <= address;
			mem_read <= '0';
			mem_write <= '1';
			write_data <= data;

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';
		end procedure test_write;
	begin
		test_read(x"00000000", x"00000000");
		test_write(x"00000000", x"FFFFFFFF");
		test_read(x"00000000", x"FFFFFFFF");
		test_write(x"00000000", x"00000000");
		test_read(x"00000000", x"00000000");
		test_write(x"000000FC", x"AAAAAAAA");
		test_read(x"000000FC", x"AAAAAAAA");
		test_write(x"000000FF", x"AAAAAAAA");
		test_read(x"000000FF", x"AAAAAAAA");
		wait;
	end process;
end behaviour;