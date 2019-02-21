library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

entity u32_mem_access is
    port (
        clk, clk_en                         : in std_logic                      := '0';
        control, rd                         : in std_logic_vector(4 downto 0)   := (others => '0');
        funct                               : in nibble_vector                  := (others => '0');
        alu_result, add_result, addr_const  : in word_vector                    := (others => '0');
        oper, funct_rdd                     : out word_vector                   := (others => '0');
        rd_out                              : out addr_vector                   := (others => '0');
        control_out                         : out std_logic_vector(1 downto 0)  := (others => '0')
    );
end u32_mem_access;

-- define the internal organisation and operation of the memory access pipeline stage
architecture rtl of u32_mem_access is
    signal wbsrc                    : std_logic_vector(1 downto 0)  := (others => '0');
    signal write_en, read_en        : std_logic                     := '0';
    signal funct_rdd_reg, oper_reg  : word_vector                   := (others => '0');
begin
    -- concurrent statements
    wbsrc <= control(1 downto 0);
    write_en <= control(2);
    read_en <= control(3);

    -- instantiate data memory
	u32_data_memory : entity work.u32_data_memory
	port map (
		clk => clk,
		write_en => write_en,
		read_en => read_en,
		funct => funct(1 downto 0),
		addr => add_result,
		write_data => alu_result,
		read_data => oper_reg
    );
    
    with wbsrc select 
    funct_rdd_reg <=    addr_const when "00",
                        add_result when "01",
                        alu_result when "10",
                        (31 downto 4 => '0') & funct when others;
    
    -- sequential statements
    process begin
        wait until falling_edge(clk);
        if clk_en = '1' then
            control_out <= control(4 downto 3);
            funct_rdd <= funct_rdd_reg;
            oper <= oper_reg;
            rd_out <= rd;
        end if;
    end process;
end rtl;