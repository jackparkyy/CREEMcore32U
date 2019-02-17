library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory_testbench is
end instruction_memory_testbench;

-- define the internal organisation and operation of the instruction memory
architecture behaviour of instruction_memory_testbench is
	-- architecture declarations
	constant clock_delay	: time := 50 ns;

    signal clk, write_en, clk_out           : std_logic := '0';
	signal read_addr, write_inst, write_addr, inst : std_logic_vector(31 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate instruction memory
	instruction_memory : entity work.u32_instruction_memory
	port map (
		clk => clk,
        write_en => write_en,
        read_addr => read_addr,
		write_inst => write_inst,
		write_addr => write_addr,
		inst => inst,
		clk_out => clk_out
	);
	
	process
		procedure test_read(
			constant address, expected	: in std_logic_vector(31 downto 0)
		) is begin
			read_addr <= address;
			write_en <= '0';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';

			assert inst = expected
            report "Unexpected data: " &
            "operation = READ ; " &
			"inst = 0x" & to_hex_string(inst) & "; " &
			"expected = 0x" & to_hex_string(expected) & "; "
			severity error;
		end procedure test_read;

		procedure test_write(
			constant address, instruction   :in std_logic_vector(31 downto 0)
		) is begin
            write_addr <= address;
            read_addr <= address;
			write_en <= '1';
			write_inst <= instruction;

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
            clk <= '0';
            assert inst = instruction
            report "Unexpected data: " &
            "operation = WRITE ; " &
			"inst = 0x" & to_hex_string(inst) & "; " &
			"expected = 0x" & to_hex_string(instruction) & "; "
			severity error;
		end procedure test_write;
	begin
		-- test vectors set based on data mem size of 256B
        for i in 0 to 31 loop
            test_write(std_logic_vector(to_unsigned(i, 32)), x"FFFFFFFF");
        end loop;
        for i in 32 to 63 loop
            test_write(std_logic_vector(to_unsigned(i, 32)), x"AAAAAAAA");
        end loop;
        for i in 0 to 31 loop
            test_read(std_logic_vector(to_unsigned(i, 32)), x"FFFFFFFF");
        end loop;
        for i in 32 to 63 loop
            test_read(std_logic_vector(to_unsigned(i, 32)), x"AAAAAAAA");
        end loop;
		wait;
	end process;
end behaviour;