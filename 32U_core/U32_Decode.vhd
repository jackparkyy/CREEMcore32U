library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_decode is
    port(
        clk, reg_write                          : in std_logic                      := '0';
        rd_addr                                : in std_logic_vector(4 downto 0)   := (others => '0');
        inst                                    : in inst_vector                    := (others => '0');
        pc_in, next_pc_in, rd_data              : in word_vector                    := (others => '0');
        control	                                : out std_logic_vector(8 downto 0)  := (others => '0');
        funct                                   : out nibble_vector                 := (others => '0');
        rs1d, rs2d, imm, pc_out, next_pc_out    : out word_vector                   := (others => '0');
        rd                                      : out std_logic_vector(11 downto 7) := (others => '0')
    );
end u32_decode;

-- define the internal organisation and operation of the decode pipeline stage
architecture behaviour of u32_decode is
    signal imm_reg      : word_vector                   := (others => '0');
    signal rs1d_reg     : word_vector                   := (others => '0');
    signal rs2d_reg     : word_vector                   := (others => '0');
    signal control_reg  : std_logic_vector(8 downto 0)  := (others => '0');
begin
    -- concurrent statements
    -- instantiate controller
    u32_controller : entity work.u32_controller
    port map (
        opcode => inst(6 downto 2),
        control => control_reg
    );

    -- instantiate general purpose registers
    u32_gp_registers : entity work.u32_gp_registers
    port map (
        clk => clk,
        reg_write => reg_write,
        rs1_addr => inst(19 downto 15),
        rs2_addr => inst(24 downto 20),
        rd_addr => rd_addr,
        rd_data => rd_data,
        rs1_data => rs1d_reg,
        rs2_data => rs2d_reg
    );

    -- instantiate immediate decoder
    u32_immediate_decoder : entity work.u32_immediate_decoder
    port map (
        inst => inst,
        imm => imm_reg
    );    
    
    -- sequential statements
    process begin
        wait until falling_edge(clk);
        control <= control_reg;
        funct <= inst(30) & inst(14 downto 12);
        rs1d <= rs1d_reg;
        rs2d <= rs2d_reg;
        imm <= imm_reg;
        pc_out <= pc_in;
        rd <= inst(11 downto 7);
        next_pc_out <= next_pc_in;
    end process;
end behaviour;