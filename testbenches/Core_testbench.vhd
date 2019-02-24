library ieee;
use ieee.std_logic_1164.all;
use work.getto_compiler.all;

-- define the interface between the core and its external environment
entity core_testbench is
end core_testbench;

-- define the internal organisation and operation of the core
architecture behaviour of core_testbench is
	-- architecture declarations
    signal clk, write_en, reg_write_out                 : std_logic                     := '0';
    signal write_inst, write_addr, rd_data_out, pc_out  : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_addr_out                                  : std_logic_vector(4 downto 0)  := (others => '0');

    signal signals : std_logic_vector(65 downto 0) := (others => '0');
-- concurrent statements
begin    
    -- instantiate core
	core : entity work.u32_core
	port map (
        -- inputs
        clk => clk,
        write_en => write_en,
        write_inst => write_inst,
        write_addr => write_addr,
        -- outputs
        pc_out => pc_out,
        rd_data_out => rd_data_out,
        rd_addr_out => rd_addr_out,
        reg_write_out => reg_write_out
    );

    -- combine signals to pass to make it easier to pass to the compiler
    clk <= signals(65);
    write_en <= signals(64);
    write_inst <= signals(63 downto 32);
    write_addr <= signals(31 downto 0);
	
    process begin
        lui("00001", x"00001", signals);
        addi("00000", "00000", x"000", signals); -- NOP
        addi("00000", "00000", x"000", signals); -- NOP
        srli("00001", "00001", "01100", signals);
        addi("00000", "00000", x"000", signals); -- NOP
        addi("00000", "00000", x"000", signals); -- NOP
        addi("00010", "00001", x"001", signals);
        run(signals);
	end process;
end behaviour;