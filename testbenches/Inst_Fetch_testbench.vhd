library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- define the interface between the instruction fetch pipeline stage and its external environment
entity inst_fetch_testbench is
end inst_fetch_testbench;

-- define the internal organisation and operation of the instruction fetch pipeline stage
architecture behaviour of inst_fetch_testbench is
    -- architecture declarations
    constant clock_delay	: time := 10 ns;

	signal clk, write_en, pc_src            : std_logic      := '0';
    signal write_inst, write_addr, new_pc,
            inst, pc_out, next_pc_out       : std_logic_vector(31 downto 0)   := (others => '0');
    signal current_pc                       : std_logic_vector(31 downto 0)   := (others => '0');
-- concurrent statements
begin
	-- instantiate instruction fetch pipeline stage
	inst_fetch : entity work.u32_inst_fetch
	port map (
        clk => clk,
        write_en => write_en,
        pc_src => pc_src,
        write_inst => write_inst,
        write_addr => write_addr,
        new_pc => new_pc,
        inst => inst,
        pc_out => pc_out,
        next_pc_out => next_pc_out
    );
	
	process
		procedure test(
            constant jump   : in std_logic_vector(31 downto 0);
            constant source : in std_logic
		) is
            variable expected   : std_logic_vector(31 downto 0) := (others => '0');
        begin
            pc_src <= source;
            new_pc <= jump;
            write_en <= '0';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
            clk <= '0';
            
            wait for 1 ps;

            expected := x"0000003F" - current_pc;

            assert (pc_out = current_pc)
            report "Unexcpected PC: " &
            "pc = 0x" & to_hex_string(pc_out) & "; " &
            "pc_src = " & to_string(pc_src) & "; " &
            "expected = 0x" & to_hex_string(current_pc) & "; "
            severity error;

            assert (inst = expected)
            report "Unexcpected result: " &
            "inst = 0x" & to_hex_string(inst) & "; " &
            "expected = 0x" & to_hex_string(expected) & "; "
            severity error;

            if source = '1' then
                current_pc <= jump;
            else
                current_pc  <= current_pc + x"00000001";
            end if;
        end procedure test;
        
        procedure fill_inst_mem is begin
            for i in 0 to 63 loop
                write_en <= '1';
                write_inst <= std_logic_vector(to_unsigned(i, 32));
                write_addr <= std_logic_vector(to_unsigned((63 - i), 32));

                wait for clock_delay;
                clk <= '1';
                wait for clock_delay;
                clk <= '0';
            end loop;

            wait for 1 ps;
            assert (pc_out = x"00000000")
            report "Unexcpected PC: " &
            "pc = 0x" & to_hex_string(pc_out) & "; " &
            "pc_src = " & to_string(pc_src) & "; " &
            "expected = 0x00000000; "
            severity error;

            assert (inst = x"0000003F")
            report "Unexcpected result: " &
            "inst = 0x" & to_hex_string(inst) & "; " &
            "expected = 0x0000003F; "
            severity error;

            current_pc  <= current_pc + x"00000001";
		end procedure fill_inst_mem;
    begin
        -- test vectors set based on data mem size of 256B
        fill_inst_mem;

        test(x"00000000", '0');
        test(x"00000000", '0');
        test(x"00000023", '1');
        test(x"00000000", '0');
		wait for 10 ns;
		wait;
	end process;
end behaviour;