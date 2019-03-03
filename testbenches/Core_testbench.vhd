library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- define the interface between the core and its external environment
entity core_testbench is
end core_testbench;

-- define the internal organisation and operation of the core
architecture behaviour of core_testbench is
    constant clock_delay	: time := 10 ns;

    subtype reg_addr is natural range 0 to 31;
    subtype i_imm is integer range -2048 to 2047;
    subtype load_store_imm is natural range 0 to 4096;
    subtype u_imm is integer range -524288 to 524287;
    subtype j_imm is integer range -524288 to 524287;
    subtype b_imm is integer range  -2048 to 2047;
    subtype shamt_imm is natural range 0 to 31;

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
	
    process
        procedure load_inst(
            constant inst     : in std_logic_vector(31 downto 0)


        ) is begin
            signals(64) <= '1';
            signals(63 downto 32) <= inst;

            wait for clock_delay;
            signals(65) <= '1';
            wait for clock_delay;
            signals(65) <= '0';

            signals(31 downto 0) <= signals(31 downto 0) + x"00000001";
        end procedure load_inst;

        procedure run is begin
            signals(64 downto 0) <= (others => '0');
            for i in 0 to 66 loop
                wait for clock_delay;
                signals(65) <= '1';
                wait for clock_delay;
                signals(65) <= '0';
            end loop;
            wait;
        end procedure run;

        -- instructions
        procedure lui(
            constant rd     : in reg_addr;
            constant imm    : in u_imm

            
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "0110111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 20)) & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lui;

        procedure auipc(
            constant rd     : in reg_addr;
            constant imm    : in u_imm

            
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "0010111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 20)) & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure auipc;

        procedure jal(
            constant rd     : in reg_addr;
            constant imm    : in j_imm

            
        ) is
            constant opcode     : std_logic_vector(6 downto 0)  := "1101111";
            variable inst       : std_logic_vector(31 downto 0);
            variable tmp_imm    : std_logic_vector(20 downto 1);
        begin
            tmp_imm := std_logic_vector(to_signed(imm, 20));
            inst := tmp_imm(20) & tmp_imm(10 downto 1) & tmp_imm(11) & tmp_imm(19 downto 12) & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure jal;

        procedure jalr(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                       
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100111";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure jalr;

        procedure beq(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure beq;

        procedure bne(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure bne;

        procedure blt(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure blt;

        procedure bge(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure bge;

        procedure bltu(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure bltu;

        procedure bgeu(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm : in b_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable offset    : std_logic_vector(12 downto 1);
        begin
            offset := std_logic_vector(to_unsigned(imm, 12));
            inst := offset(12) & offset(10 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & offset(4 downto 1) & offset(11) & opcode;
            load_inst(inst);
        end procedure bgeu;

        procedure lb(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_unsigned(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lb;

        procedure lh(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_unsigned(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lh;

        procedure lw(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_unsigned(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lw;

        procedure lbu(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_unsigned(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lbu;

        procedure lhu(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_unsigned(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure lhu;

        procedure sb(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable tmp_imm    : std_logic_vector(11 downto 0);
        begin
            tmp_imm := std_logic_vector(to_unsigned(imm, 12));
            inst := tmp_imm(11 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & tmp_imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sb;

        procedure sh(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable tmp_imm    : std_logic_vector(11 downto 0);
        begin
            tmp_imm := std_logic_vector(to_unsigned(imm, 12));
            inst := tmp_imm(11 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & tmp_imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sh;

        procedure sw(
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr;
            constant imm    : in load_store_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
            variable inst       : std_logic_vector(31 downto 0);
            variable tmp_imm    : std_logic_vector(11 downto 0);
        begin
            tmp_imm := std_logic_vector(to_unsigned(imm, 12));
            inst := tmp_imm(11 downto 5) & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & tmp_imm(4 downto 0) & opcode;
            load_inst(inst);
        end procedure sw;

        procedure addi(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm
            
            
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure addi;

        procedure slti(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure slti;

        procedure sltiu(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "011";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure sltiu;

        procedure xori(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure xori;

        procedure ori(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure ori;

        procedure andi(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant imm    : in i_imm

                        
        ) is
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure andi;

        procedure slli(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant shamt  : in shamt_imm

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(shamt, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure slli;

        procedure srli(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant shamt  : in shamt_imm

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(shamt, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure srli;

        procedure srai(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant shamt  : in shamt_imm

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(shamt, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure srai;

        procedure op_add(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_add;

        procedure op_sub(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "000";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_sub;

        procedure op_sll(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "001";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_sll;

        procedure op_slt(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "010";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_slt;

        procedure op_sltu(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "011";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_sltu;

        procedure op_xor(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "100";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_xor;

        procedure op_srl(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_srl;

        procedure op_sra(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
            constant funct3     : std_logic_vector(14 downto 12)    := "101";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_sra;

        procedure op_or(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "110";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_or;

        procedure op_and(
            constant rd     : in reg_addr;
            constant rs1    : in reg_addr;
            constant rs2    : in reg_addr

                        
        ) is
            constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
            constant funct3     : std_logic_vector(14 downto 12)    := "111";
            constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
            variable inst       : std_logic_vector(31 downto 0);
        begin
            inst := funct7 & std_logic_vector(to_unsigned(rs2, 5)) & std_logic_vector(to_unsigned(rs1, 5)) & funct3 & std_logic_vector(to_unsigned(rd, 5)) & opcode;
            load_inst(inst);
        end procedure op_and;

        -- pseudo instructions
        procedure nop is begin
            addi(0, 0, 0);
        end procedure nop;
    begin
        -- 0
        lui(31, 1); -- x31 = 4096
        -- 1
        lui(30, -524288); -- x30 = -2147483648
        -- 2
        --auipc(29, 1); -- x29 = 2 + 4096 (PC + constant) = 4098
        -- 3
        -- srli(31, 31, 12); -- x31 = 4096 >> 12 (x31 >> constant) = 1
        -- 4
        nop;
        -- 5
        nop;
        -- 6
        --addi(27, 31, 50); -- x27 = 1 + 50 (x31 - constant) = 51
        -- 7
        op_add(28, 31, 30); -- x28 = 1 + -2147483648 (x31 + x30) = -2147483647
        -- 8        
        --nop;
        -- 9
        --sw(27, 29, 0); -- data_addr[51 + 0] = 4098 (data_addr[rs1 + imm] = rs2)
        -- 10
        --lw(26, 27, 0);
        run;
        --beq(31, 31, -1, signals);
        --jal(0, -1, signals);
        --jalr("00000", "11111", x"002", signals);
	end process;
end behaviour;