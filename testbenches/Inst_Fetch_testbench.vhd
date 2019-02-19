library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- define the interface between the instruction fetch pipeline stage and its external environment
entity inst_fetch_testbench is
end inst_fetch_testbench;

-- define the internal organisation and operation of the instruction fetch pipeline stage
architecture behaviour of inst_fetch_testbench is
	-- architecture declarations
	signal clk, write_en, pc_src, clk_out   : in std_logic      := '0';
    signal write_inst, write_addr, new_pc,
            inst, pc_out, next_pc_out       : out word_vector   := (others => '0');
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
        next_pc_out => next_pc_out,
        clk_out =>  clk_out
    );
	
	process
		procedure test(
            constant program_counter    : in std_logic_vector(31 downto 0);
            constant expected           : out std_logic_vector(31 downto 0);
            constant source             : in std_logic
		) is
			
		begin		
            pc_src <= source;
			new_pc <= program_counter;

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
            clk <= '0';
            
            wait for 1 ps;
            if source = '1'
                assert (inst = expected)
                report "Unexcpected PC: " &
                "inst = 0x" & to_hex_string(inst) & "; " &
                "expected = 0x" & to_hex_string(expected) & "; "
                severity error;
            else
                assert (inst = x"FFFFFFFF")
                report "Unexcpected PC: " &
                "pc_out = 0x" & to_hex_string(pc_out) & "; " &
                "current_pc = 0x" & to_hex_string(current_pc) & "; "
                severity error;
            end if;
        end procedure test;
        
        procedure test_write(
			constant address, instruction   :in std_logic_vector(31 downto 0)
        ) is begin
            write_en <= '1';
            write_addr <= address;
			write_inst <= instruction;

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
            clk <= '0';
		end procedure test_write;
    begin
        -- test vectors set based on data mem size of 256B
        for i in 0 to 31 loop
            test_write(std_logic_vector(to_unsigned(i, 32)), x"FFFFFFFF");
        end loop;
        for i in 32 to 63 loop
            test_write(std_logic_vector(to_unsigned(i, 32)), x"AAAAAAAA");
        end loop;

        test(x"00000023", x"AAAAAAAA", "00001", '1');
		wait for 10 ns;
		wait;
	end process;
end behaviour;