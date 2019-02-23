library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- define the interface between the core and its external environment
entity getto_compiler is
end getto_compiler;
    
-- define the internal organisation and operation of the core
architecture behaviour of getto_compiler is
    -- architecture declarations
    constant clock_delay	: time := 50 ns;
    
    signal clk, write_en, reg_write_out                 : std_logic                     := '0';
    signal write_inst, write_addr, rd_data_out, pc_out  : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_addr_out                                  : std_logic_vector(4 downto 0)  := (others => '0');

    signal addr : std_logic_vector(31 downto 0) := (others => '0');
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
        pc_out => pc_out,
        rd_data_out => rd_data_out,
        rd_addr_out => rd_addr_out,
        reg_write_out => reg_write_out
    );
    
    process
        procedure load_inst(
            constant inst   : in std_logic_vector(31 downto 0)
        ) is begin
            write_en <= '1';
            write_inst <= inst;
            write_addr <= addr;

            wait for clock_delay;
            clk <= '1';
            addr <= addr + x"00000001";
            wait for clock_delay;
            clk <= '0';

            write_en <= '0';
            write_inst <= x"00000000";
            write_addr <= x"00000000";
            
        end procedure load_inst;

        procedure lui(
            constant rd     : in std_logic_vector(11 downto 7);
            constant imm    : in std_logic_vector(31 downto 12)
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "0110111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rd & opcode;
            load_inst(inst);
        end procedure lui;

        procedure auipc(
            constant rd     : in std_logic_vector(11 downto 7);
            constant imm    : in std_logic_vector(31 downto 12)
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "0010111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rd & opcode;
            load_inst(inst);
        end procedure auipc;

        procedure jal(
            constant rd     : in std_logic_vector(11 downto 7);
            constant imm    : in std_logic_vector(31 downto 12)
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "1101111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rd & opcode;
            load_inst(inst);
        end procedure jal;

        procedure jalr(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure jalr;

        procedure beq(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure beq;

        procedure bne(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure bne;

        procedure blt(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure blt;

        procedure bge(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure bge;

        procedure bltu(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure bltu;

        procedure bgeu(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant offset    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
            load_inst(inst);
        end procedure bgeu;

        procedure lb(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure lb;

        procedure lh(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure lh;

        procedure lw(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure lw;

        procedure lbu(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure lbu;

        procedure lhu(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure lhu;

        procedure sb(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant imm    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sb;

        procedure sh(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant imm    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sh;

        procedure sw(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant imm    : in std_logic_vector(11 downto 0)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sw;

        procedure addi(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure addi;

        procedure slti(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure slti;

        procedure sltiu(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "011";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure sltiu;

        procedure xori(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure xori;

        procedure ori(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure ori;

        procedure andi(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant imm    : in std_logic_vector(31 downto 20)            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := imm & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure andi;

        procedure slli(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant shamt    : in std_logic_vector(24 downto 20)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure slli;

        procedure srli(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant shamt    : in std_logic_vector(24 downto 20)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure srli;

        procedure srai(
            constant rd     : in std_logic_vector(11 downto 7);
            constant rs1    : in std_logic_vector(19 downto 15);
            constant shamt    : in std_logic_vector(24 downto 20)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure srai;

        procedure op_add(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_add;

        procedure op_sub(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_sub;

        procedure op_sll(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_sll;

        procedure op_slt(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_slt;

        procedure op_sltu(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "011";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_sltu;

        procedure op_xor(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_xor;

        procedure op_srl(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_srl;

        procedure op_sra(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_sra;

        procedure op_or(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_or;

        procedure op_and(
            constant rs1    : in std_logic_vector(19 downto 15);
            constant rs2    : in std_logic_vector(24 downto 20);
            constant rd    : in std_logic_vector(11 downto 7)            
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
            load_inst(inst);
        end procedure op_and;

        procedure run is begin
            for i in 0 to 66 loop
                wait for clock_delay;
                clk <= '1';
                wait for clock_delay;
                clk <= '0';
            end loop;
            wait;
        end procedure run;
    begin
        lui("00001", x"00001");
        addi("00000", "00000", x"000"); -- NOP
        addi("00000", "00000", x"000"); -- NOP
        srli("00001", "00001", "01100");
        addi("00000", "00000", x"000"); -- NOP
        addi("00000", "00000", x"000"); -- NOP
        addi("00010", "00001", x"001");
        run;
	end process;
end behaviour;