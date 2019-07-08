library ieee;
use ieee.std_logic_1164.all;
use work.getto_compiler.all;

entity core_testbench is
end core_testbench;

-- define the internal organisation and operation of the core testbench
architecture behaviour of core_testbench is
	-- architecture declarations
    signal clk, write_en, reg_write, pc_src : std_logic                     := '0';
    signal write_inst, write_addr, rd_data,
            addr_const, alu_result,
            add_result, new_pc              : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_addr                          : std_logic_vector(4 downto 0)  := (others => '0');
    signal signals                          : std_logic_vector(65 downto 0) := (others => '0');
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
        addr_const_out => addr_const,
        alu_result_out => alu_result,
        add_result_out => add_result,
        new_pc_out => new_pc,
        pc_src_out => pc_src,
        rd_data_out => rd_data,
        rd_addr_out => rd_addr,
        reg_write_out => reg_write
    );

    -- combine signals to pass to make it easier to pass to the compiler
    clk <= signals(65);
    write_en <= signals(64);
    write_inst <= signals(63 downto 32);
    write_addr <= signals(31 downto 0);
	
    process begin
        -- 0
        lui(31, 1, signals); -- x31 = 4096 (imm<<12)
        -- 4
        nop(signals);
        -- 8
        jal(1, 8, signals); -- PC = 24 (PC + (2 * imm))
        -- 12
        nop(signals);
        -- 16
        sw(30, 31, 0, signals); -- data_addr[16 + 0] = 4096 (data_addr[rs1 + imm] = rs2)
        -- 20
        lw(29, 30, 0, signals); -- x29 = data_addr[16 + 0] (data_addr[rs1 + imm] = rs2)
        -- 24
        srli(30, 31, 8, signals); -- x30 = 4096 >> 8 (x31 >> imm) = 16
        -- 28
        nop(signals);
        -- 32
        nop(signals);
        -- 36
        bne(30, 31, -10, signals); -- if x30 != x31, PC = 16 (PC + (2 * imm))
        run(signals);
	end process;
end behaviour;