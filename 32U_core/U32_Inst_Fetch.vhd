library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.u32_types.all;

entity u32_inst_fetch is
    port (
        clk, write_en, pc_src           : in std_logic      := '0';
        write_inst, write_addr, new_pc  : in word_vector    := (others => '0');
        inst, pc_out, next_pc_out       : out word_vector   := (others => '0');
        clk_out                         : out std_logic     := '0'
    );
end u32_inst_fetch;
    
architecture rtl of u32_inst_fetch is
    signal pc_reg_in, pc_reg_out, inst_reg  : word_vector   := (others => '0');
    signal clock                            : std_logic      := '0';

    constant increment  : std_logic_vector(xlen downto 0)   := ((xlen downto 1 => '0') & '1');
begin
    u32_instruction_memory : entity work.u32_instruction_memory
	port map (
        clk => clk,
        write_en => write_en,
        read_addr => pc_reg_out,
        write_inst => write_inst,
        write_addr => write_addr,
        inst => inst_reg,
        clk_out => clock
    );

    pc_reg_in <=    new_pc when pc_src = '1' else
                    pc_reg_out + increment;

    clk_out <= clock;
    -- sequential statements
    process begin
        wait until falling_edge(clock);
        pc_reg_out <= pc_reg_in;
        pc_out <= pc_reg_out;
        next_pc_out <= pc_reg_out + increment;
        inst <= inst_reg;
    end process;
end rtl;