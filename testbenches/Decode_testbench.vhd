library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- define the interface between the alu and its external environment
entity decode_testbench is
end decode_testbench;

-- define the internal organisation and operation of the alu
architecture behaviour of decode_testbench is
	-- architecture declarations
	constant clock_delay	: time := 10 ns;
	signal current_pc : std_logic_vector(31 downto 0) := (others => '0');

    signal clk, clk_en, reg_write                   : std_logic                      := '0';
    signal rd_addr, rd                              : std_logic_vector(4 downto 0)   := (others => '0');
    signal inst                                     : std_logic_vector(29 downto 0)  := (others => '0');
    signal pc_in, next_pc_in, rd_data, rs1d, rs2d,
            imm, pc_out, next_pc_out                : std_logic_vector(31 downto 0)  := (others => '0');
    signal control	                                : std_logic_vector(8 downto 0)   := (others => '0');
	signal funct                                    : std_logic_vector(3 downto 0)   := (others => '0');
	
	function check_control(
		opcode : std_logic_vector(4 downto 0);
		control_signal : std_logic_vector(8 downto 0)
	)
        return std_ulogic is
	begin
		case opcode is
			when "01101" => -- LUI
				if control_signal = "100001000" then
					return '1';
				else
					return '0';
				end if;
			when "00101" => -- AUIPC
				if control_signal = "100010000" then
					return '1';
				else
					return '0';
				end if;
			when "11011" => -- JAL
				if control_signal = "100000001" then
					return '1';
				else
					return '0';
				end if;
			when "11001" => -- JALR
				if control_signal = "100000101" then
					return '1';
				else
					return '0';
				end if;
			when "11000" => -- BRANCH
				if control_signal = "000011010" then
					return '1';
				else
					return '0';
				end if;
			when "00000" => -- LOAD
				if control_signal = "110110100" then
					return '1';
				else
					return '0';
				end if;
			when "01000" => -- STORE
				if control_signal = "001011100" then
					return '1';
				else
					return '0';
				end if;
			when "01100" => -- OP
				if control_signal = "100101100" then
					return '1';
				else
					return '0';
				end if;
			when others => -- OP-IMM
				if control_signal = "100100000" then
					return '1';
				else
					return '0';
				end if;
		end case;
	end check_control;
-- concurrent statements
begin
	-- instantiate alu_controller
	decode : entity work.u32_decode
	port map (
        -- inputs
		clk => clk,
		clk_en => clk_en,
		reg_write => reg_write,
		rd_addr => rd_addr,
		inst => inst,
		pc_in => pc_in,
        next_pc_in => next_pc_in,
        rd_data => rd_data,
        -- outputs
        rd => rd,
        rs1d => rs1d,
        rs2d => rs2d,
        pc_out => pc_out,
        next_pc_out => next_pc_out,
        control => control,
		funct => funct,
		imm => imm
	);
	
	process
		procedure test(
			constant instruction, data	: in std_logic_vector(31 downto 0);
            constant address            : in std_logic_vector(4 downto 0);
            constant regwrite           : in std_logic
		) is
			
		begin		
			pc_in <= next_pc_out;
			next_pc_in <= next_pc_out + x"00000004";
            reg_write <= regwrite;
            rd_data <= data;
			rd_addr <= address;
            inst <=  instruction(31 downto 2);
			current_pc <= next_pc_out;
			clk_en <= '1';

			wait for clock_delay;
			clk <= '1';
			wait for clock_delay;
			clk <= '0';

			wait for 1 ps;
			assert (pc_out = current_pc and next_pc_out = (current_pc + x"00000004"))
			report "Unexcpected PC: " &
			"pc_out = 0x" & to_hex_string(pc_out) & "; " &
			"current_pc = 0x" & to_hex_string(current_pc) & "; "
			severity error;

			assert check_control(instruction(6 downto 2), control)
			report "Unexcpected Control: " &
			"pc_out = 0x" & to_hex_string(pc_out) & "; " &
			"current_pc = 0x" & to_hex_string(current_pc) & "; "
			severity error;

			report "Tested inst: " &
			"rs1d = 0x" & to_hex_string(rs1d) & "; " &
			"rs2d = 0x" & to_hex_string(rs2d) & "; " &
			"funct = " & to_string(funct) & "; " &
			"imm = 0x" & to_hex_string(imm) & "; " &
			"rd = " & to_string(rd) & "; "
			severity note;
		end procedure test;
	begin
		test(x"401000B3", x"FFFFFFFF", "00001", '1');
		test(x"401000B3", x"00000000", "00001", '0');
		test(x"401000B3", x"00000000", "00001", '1');
		test(x"401000B3", x"FFFFFFFF", "00000", '1');
		wait for 10 ns;
		wait;
	end process;
end behaviour;