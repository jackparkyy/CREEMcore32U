library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.u32_types.all;

-- define the interface between the general-purpose registers and its external environment
entity u32_gp_registers is
    port(
        clk, reg_write              : in std_logic := '0';
        rs1_addr, rs2_addr, rd_addr : in opcode_vector := (others => '0');
        rd_data                     : in word_vector := (others => '0');
        rs1_data, rs2_data          : out word_vector := (others => '0')
    );
end u32_gp_registers;

-- define the internal organisation and operation of the general-purpose registers
architecture rtl of u32_gp_registers is
    type word_matrix is array (0 to 31) of word_vector;
    signal gp_registers : word_matrix := (others => (others => '0'));
begin
    -- concurrent statements (read)
    rs1_data <= gp_registers(to_integer(unsigned(rs1_addr)));
    rs2_data <= gp_registers(to_integer(unsigned(rs2_addr)));
    -- sequential statements (write)
    process begin
        wait until rising_edge(clk);
        if (reg_write = '1' and rd_addr /= "00000") then
            gp_registers(to_integer(unsigned(rd_addr))) <= rd_data;
        end if;
    end process;
end rtl;