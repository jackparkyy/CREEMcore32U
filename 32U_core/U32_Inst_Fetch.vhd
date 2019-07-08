library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.u32_types.all;

-- define the interface between the instruction fetch pipeline stage and its external environment
entity u32_inst_fetch is
    port (
        clk, write_en, pc_src           : in std_logic      := '0';
        write_inst, write_addr, new_pc  : in word_vector    := (others => '0');
        inst, pc_out, next_pc_out       : out word_vector   := (others => '0');
        clk_en                          : out std_logic     := '0'
    );
end u32_inst_fetch;
    
-- define the internal organisation and operation of the instruction fetch pipeline stage
architecture rtl of u32_inst_fetch is
    constant increment      : std_logic_vector(xlen downto 0)   := ((xlen downto 3 => '0') & "100");
    constant inst_mem_xlen  : natural                           := ((inst_mem_size / 4) - 1);

    type ram is array (0 to inst_mem_xlen) of word_vector;

    signal next_pc, pc, inst_reg            : word_vector   := (others => '0');
    signal inst_mem                         : ram           := (others => (others => '0'));
    signal true_write_addr, true_read_addr  : natural       := 0;
begin
    -- concurrent statements
    -- convert byte address into word address
    true_read_addr <= to_integer(unsigned(pc)) / 4;
    true_write_addr <= to_integer(unsigned(write_addr)) / 4;

    -- read instruction out of instruction memory
    inst_reg <= inst_mem(true_read_addr);

    -- update program counter
    next_pc <=    new_pc when pc_src = '1' else
                    pc + increment;

    -- sequential statements
    process (clk)
        variable count  : natural range 0 to inst_mem_xlen  := 0;
    begin
        if rising_edge(clk) then
            -- stall pipeline until instruction memory filled
            if count = inst_mem_xlen then
                clk_en <= '1';
            else 
                count := count + 1;
            end if;

            -- write instruction into instruction memory
            if write_en = '1' then
                inst_mem(true_write_addr) <= write_inst;
            end if;
        elsif falling_edge(clk) then
            -- pipeline registers
            if clk_en = '1' then
                pc <= next_pc;
                pc_out <= pc;
                next_pc_out <= pc + increment;
                inst <= inst_reg;
            end if;
        end if;
    end process;
end rtl;