library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- define the interface between the alu and its external environment
entity gp_registers_testbench is
end gp_registers_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of gp_registers_testbench is
	-- architecture declarations
	constant clock_delay	: time := 10 ns;

    signal clk, reg_write              	: std_logic := '0';
	signal rs1_addr, rs2_addr, rd_addr	: std_logic_vector(4 downto 0) := (others => '0');
    signal rd_data                     	: std_logic_vector(31 downto 0) := (others => '0');
    signal rs1_data, rs2_data          	: std_logic_vector(31 downto 0) := (others => '0');
-- concurrent statements
begin
	-- instantiate alu_controller
	gp_registers : entity work.u32_gp_registers
	port map (
		clk => clk,
		reg_write => reg_write,
		rs1_addr => rs1_addr,
		rs2_addr => rs2_addr,
		rd_addr => rd_addr,
		rd_data => rd_data,
		rs1_data => rs1_data,
		rs2_data => rs2_data
	);
	
	process
		procedure test_read(
			constant addr1, addr2  	: in std_logic_vector(4 downto 0);
			constant expected1, expected2	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			rs1_addr <= addr1;
			rs2_addr <= addr2;
			reg_write <= '0';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';

			assert rs1_data = expected1
			report "Unexpected data"
			severity error;

			assert rs2_data = expected2
			report "Unexpected data"
			severity error;
		end procedure test_read;

		procedure test_write(
			constant addr	: in std_logic_vector(4 downto 0);
			constant data  	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			rd_addr <= addr;
			rd_data <= data;
			reg_write <= '1';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';
		end procedure test_write;

		procedure test_rw(
			constant addr	: in std_logic_vector(4 downto 0);
			constant data  	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			rd_addr <= addr;
			rd_data <= data;
			rs1_addr <= addr;
			reg_write <= '1';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';
			
			assert rs1_data = data
			report "Unexpected data"
			severity error;
		end procedure test_rw;

		procedure test_read_all(
			constant expected  	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			for i in 0 to 15 loop
				if (i = 0) then
					test_read(std_logic_vector(to_unsigned(i, 5)), std_logic_vector(to_unsigned((31 - i), 5)), x"00000000", expected);
				else
					test_read(std_logic_vector(to_unsigned(i, 5)), std_logic_vector(to_unsigned((31 - i), 5)), expected, expected);
				end if;
			end loop;
		end procedure test_read_all;

		procedure test_write_all(
			constant data	: in std_logic_vector(31 downto 0)
		) is
			
		begin
			for i in 0 to 31 loop
				test_write(std_logic_vector(to_unsigned(i, 5)), data);
			end loop;
		end procedure test_write_all;
	begin
		test_rw("00001", x"FFFFFFFF");
		test_rw("01000", x"FFFFFFFF");
		--test_read_all(x"00000000");
		--test_write_all(x"FFFFFFFF");
		--test_read_all(x"FFFFFFFF");
		--test_write_all(x"AAAAAAAA");
		--test_read_all(x"AAAAAAAA");
		--(x"55555555");
		--test_read_all(x"55555555");
		--test_write_all(x"00000000");
		--test_read_all(x"00000000");
		wait;
	end process;
end behaviour;