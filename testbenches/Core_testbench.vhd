library ieee;
use ieee.std_logic_1164.all;
use work.getto_compiler.all;

-- define the interface between the core and its external environment
entity core_testbench is
end core_testbench;

-- define the internal organisation and operation of the core
architecture behaviour of core_testbench is
	-- architecture declarations
    signal clk, write_en, reg_write, pc_src : std_logic                     := '0';
    signal write_inst, write_addr, rd_data,
            imm, rs1d, rs2d, alu_result,
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
        imm_out => imm,
        rs1d_out => rs1d,
        rs2d_out => rs2d,
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
        lui(31, 1, signals); -- x31 = 4096
        -- 1
        nop(signals);
        -- 2
        nop(signals);
        -- 3
        auipc(30, 1, signals); -- x29 = 3 + 4096 (PC + constant) = 4099
        -- 4
        jal(0, 3, signals);
        -- 5
        srli(31, 31, 12, signals); -- x31 = 4096 >> 12 (x31 >> constant) = 1
        -- 4
        op_sub(28, 31, 30, signals); -- x28 = 1 + -2147483648 (x31 + x30) = -2147483647
        -- 5
        addi(27, 31, 50, signals); -- x27 = 1 + 50 (x31 - constant) = 51
        -- 5
        jal(0, 3, signals);
        -- 6
        op_add(28, 31, 30, signals); -- x28 = 1 + -2147483648 (x31 + x30) = -2147483647
        -- 7        
        nop(signals);
        -- 8
        bne(31, 30, -1, signals);
        -- 10
        sw(27, 30, 0, signals); -- data_addr[51 + 0] = 4097 (data_addr[rs1 + imm] = rs2)
        -- 11
        lw(26, 27, 0, signals);
        run(signals);
        --beq(31, 31, -1, signals);
        --jalr("00000", "11111", x"002", signals);
        --lui(30, -524288, signals); -- x30 = -2147483648
	end process;
end behaviour;