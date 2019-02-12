library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.u32_types.all;

entity u32_execute is
    port(
        clk                             : in std_logic                      := '0';
        control                         : in std_logic_vector(8 downto 0)   := (others => '0');
        rd	                            : in std_logic_vector(4 downto 0)   := (others => '0');
        funct                           : in nibble_vector                  := (others => '0');
        rs1d, rs2d, imm, pc, next_pc    : in word_vector                    := (others => '0');
        control_out, rd_out             : out std_logic_vector(4 downto 0)  := (others => '0');
        funct_out                       : out nibble_vector                 := (others => '0');
        alu_result, add_result,
        add_result_out, addr_const      : out word_vector                   := (others => '0');
        pcsrc                           : out std_logic                     := '0'
    );
end u32_execute;

-- define the internal organisation and operation of the decode pipeline stage
architecture behaviour of u32_execute is
    signal jump, branch, addsrc_aluop0,
            addrsrc_alusrc, aluop1, zero  : std_logic     := '0';

    signal operand2, result, add_result_reg,
            addr_const_reg, addoperand2         : word_vector    := (others => '0');
    signal alu_control                          : nibble_vector := (others => '0');
begin
    -- concurrent statements
    jump <= control(0);
    branch <= control(1);
    addsrc_aluop0 <= control(2);
    addrsrc_alusrc <= control(3);
    aluop1 <= control(4);

    add_result_out <= add_result_reg;

    operand2 <= rs2d when addrsrc_alusrc = '1' else imm;
    addoperand2 <= rs1d when addsrc_aluop0 = '1' else pc;
    addr_const_reg <= imm when addrsrc_alusrc = '1' else next_pc;

    add_result_reg <= imm + addoperand2;

    -- instantiate ALU
    u32_alu : entity work.u32_alu
    port map (
        operand1 => rs1d,
        operand2 => operand2,
		alu_control => alu_control,
		result => result,
		zero => zero
    );

    -- instantiate ALU controller
    u32_alu_controller : entity work.u32_alu_controller
    port map (
        aluop => aluop1 & addsrc_aluop0,
		funct => funct,
		alu_control => alu_control
    );

    -- instantiate Branch
    u32_branch_controller : entity work.u32_branch_controller
    port map (
        jump => jump,
        branch => branch,
        zero => zero,
        funct => funct(2 downto 0),
		pcsrc => pcsrc
    );
    
    -- sequential statements
    process begin
        wait until falling_edge(clk);
        control_out <= control(8 downto 4);
        funct_out <= funct;
        alu_result <= result;
        add_result <= add_result_reg;
        rd_out <= rd;
        addr_const <= addr_const_reg;
    end process;
end behaviour;