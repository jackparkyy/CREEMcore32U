library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_core is
    port (
        clk, write_en                               : in std_logic      := '0';
        write_inst, write_addr                      : in word_vector    := (others => '0');
        rd_data_out, imm_out, rs1d_out, rs2d_out,
        alu_result_out, add_result_out, new_pc_out  : out word_vector   := (others => '0');
        rd_addr_out                                 : out addr_vector   := (others => '0');
        reg_write_out, pc_src_out                   : out std_logic     := '0'
    );
end u32_core;

-- define the internal organisation and operation of the U32 Core
architecture rtl of u32_core is
    signal  pc_src,
            clk_en,
            reg_write       : std_logic                     := '0';
    signal  new_pc,
            inst,
            pc_if_d,
            pc_d_e,
            next_pc_if_d,
            next_pc_d_e,
            rd_data,
            funct_rdd,
            rs1d,
            rs2d,
            imm,
            alu_result,
            add_result,
            addr_const,
            oper            : word_vector   := (others => '0');
    signal  control_d_e     : std_logic_vector(8 downto 0)  := (others => '0');
    signal  control_e_ma,
            rd_addr,
            rd_d_e,
            rd_e_ma,
            rd_ma_w         : addr_vector                   := (others => '0');
    signal  control_ma_w    : std_logic_vector(1 downto 0)  := (others => '0');
    signal  funct_d_e,
            funct_e_ma      : nibble_vector                 := (others => '0');
begin
    -- instantiate instruction fetch pipeline stage
    u32_inst_fetch : entity work.u32_inst_fetch
    port map (
        -- inputs
        clk => clk,
        write_en => write_en,
        pc_src => pc_src,
        write_inst => write_inst,
        write_addr => write_addr,
        new_pc => new_pc,
        -- outputs
        inst => inst,
        pc_out => pc_if_d,
        next_pc_out => next_pc_if_d,
        clk_en => clk_en
    );

    -- instantiate decode pipeline stage
    u32_decode : entity work.u32_decode
    port map (
        -- inputs
        clk => clk,
        clk_en => clk_en,
        reg_write => reg_write,
        rd_addr => rd_addr,
        inst => inst(31 downto 2),
        pc_in => pc_if_d,
        next_pc_in => next_pc_if_d,
        rd_data => rd_data,
        -- outputs
        control => control_d_e,
        funct => funct_d_e,
        rs1d => rs1d,
        rs2d => rs2d,
        imm => imm,
        pc_out => pc_d_e,
        next_pc_out => next_pc_d_e,
        rd => rd_d_e
    );

    -- instantiate execute pipeline stage
    u32_execute : entity work.u32_execute
    port map (
        -- inputs
        clk => clk,
        clk_en => clk_en,
        control => control_d_e,
        rd => rd_d_e,
        funct => funct_d_e,
        rs1d => rs1d,
        rs2d => rs2d,
        imm => imm,
        pc => pc_d_e,
        next_pc => next_pc_d_e,
        -- outputs
        control_out => control_e_ma,
        rd_out => rd_e_ma,
        funct_out => funct_e_ma,
        alu_result => alu_result,
        add_result => add_result,
        add_result_out => new_pc,
        addr_const => addr_const,
        pc_src => pc_src
    ); 

    -- instantiate memory access pipeline stage
    u32_mem_access : entity work.u32_mem_access
    port map (
        -- inputs
        clk => clk,
        clk_en => clk_en,
        control => control_e_ma,
        rd => rd_e_ma,
        funct => funct_e_ma,
        alu_result => alu_result,
        add_result => add_result,
        addr_const => addr_const,
        -- outputs
        oper => oper,
        funct_rdd => funct_rdd,
        rd_out => rd_ma_w,
        control_out => control_ma_w
    ); 
    
    -- instantiate writeback pipeline stage
    u32_writeback : entity work.u32_writeback
    port map (
        -- inputs
        control => control_ma_w,
        oper => oper,
        funct_rdd => funct_rdd,
        rd => rd_ma_w,
        -- outputs
        rd_out => rd_addr,
        rd_data => rd_data,
        reg_write => reg_write
    );


    imm_out <= imm;
    rs1d_out <= rs1d;
    rs2d_out <= rs2d;
    alu_result_out <= alu_result;
    add_result_out <= add_result;
    new_pc_out <= new_pc;
    pc_src_out <= pc_src;
    rd_data_out <= rd_data;
    rd_addr_out <= rd_addr;
    reg_write_out <= reg_write;
end rtl;