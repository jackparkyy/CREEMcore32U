library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package getto_compiler is
    constant clock_delay	: time := 50 ns;

    procedure run(
        signal signals  : out std_logic_vector(65 downto 0)
    );

    procedure lui(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    );

    procedure auipc(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    );

    procedure jal(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    );

    procedure jalr(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)           
    );

    procedure beq(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure bne(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure blt(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure bge(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure bltu(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure bgeu(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure lb(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure lh(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure lw(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure lbu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure lhu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure sb(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure sh(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure sw(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure addi(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);
        
        signal signals  : out std_logic_vector(65 downto 0)
    );

    procedure slti(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure sltiu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure xori(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure ori(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure andi(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure slli(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure srli(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure srai(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_add(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_sub(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_sll(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_slt(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_sltu(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_xor(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_srl(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_sra(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_or(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );

    procedure op_and(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    );
end package getto_compiler;

package body getto_compiler is
    -- procedure only used with the package iteself
    procedure load_inst(
        constant inst     : in std_logic_vector(31 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)
    ) is begin
        signals(64) <= '1';
        signals(63 downto 32) <= inst;
        report "laoded inst (" & to_string(inst) & ")" severity note;

        wait for clock_delay;
        signals(65) <= '1';
        wait for clock_delay;
        signals(65) <= '0';

        signals(31 downto 0) <= signals(31 downto 0) + x"00000001";
    end procedure load_inst;

    procedure run(
        signal signals  : out std_logic_vector(65 downto 0)
    ) is begin
        signals(64 downto 0) <= (others => '0');
        for i in 0 to 66 loop
            wait for clock_delay;
            signals(65) <= '1';
            wait for clock_delay;
            signals(65) <= '0';
        end loop;
        wait;
    end procedure run;

    procedure lui(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    ) is
        constant opcode     : std_logic_vector(6 downto 0)  := "0110111";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rd & opcode;
        load_inst(inst, signals);
    end procedure lui;

    procedure auipc(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    ) is
        constant opcode     : std_logic_vector(6 downto 0)  := "0010111";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rd & opcode;
        load_inst(inst, signals);
    end procedure auipc;

    procedure jal(
        constant rd     : in std_logic_vector(11 downto 7);
        constant imm    : in std_logic_vector(31 downto 12);

        signal signals  : out std_logic_vector(65 downto 0)
    ) is
        constant opcode     : std_logic_vector(6 downto 0)  := "1101111";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rd & opcode;
        load_inst(inst, signals);
    end procedure jal;

    procedure jalr(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)           
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100111";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure jalr;

    procedure beq(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure beq;

    procedure bne(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "001";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure bne;

    procedure blt(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "100";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure blt;

    procedure bge(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure bge;

    procedure bltu(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "110";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure bltu;

    procedure bgeu(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant offset    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "111";
        constant opcode     : std_logic_vector(6 downto 0)      := "1100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := offset(11 downto 5) & rs2 & rs1 & funct3 & offset(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure bgeu;

    procedure lb(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure lb;

    procedure lh(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "001";
        constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure lh;

    procedure lw(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "010";
        constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure lw;

    procedure lbu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "100";
        constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure lbu;

    procedure lhu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "0000011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure lhu;

    procedure sb(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure sb;

    procedure sh(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "001";
        constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure sh;

    procedure sw(
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);
        constant imm    : in std_logic_vector(11 downto 0);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "010";
        constant opcode     : std_logic_vector(6 downto 0)      := "0100011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;
        load_inst(inst, signals);
    end procedure sw;

    procedure addi(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);
        
        signal signals  : out std_logic_vector(65 downto 0)
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure addi;

    procedure slti(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "010";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure slti;

    procedure sltiu(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "011";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure sltiu;

    procedure xori(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "100";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure xori;

    procedure ori(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "110";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure ori;

    procedure andi(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant imm    : in std_logic_vector(31 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct3     : std_logic_vector(14 downto 12)    := "111";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := imm & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure andi;

    procedure slli(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "001";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure slli;

    procedure srli(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure srli;

    procedure srai(
        constant rd     : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant shamt    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "0010011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & shamt & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure srai;

    procedure op_add(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_add;

    procedure op_sub(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
        constant funct3     : std_logic_vector(14 downto 12)    := "000";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_sub;

    procedure op_sll(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "001";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_sll;

    procedure op_slt(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "010";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_slt;

    procedure op_sltu(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "011";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_sltu;

    procedure op_xor(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "100";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_xor;

    procedure op_srl(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_srl;

    procedure op_sra(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0100000";
        constant funct3     : std_logic_vector(14 downto 12)    := "101";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_sra;

    procedure op_or(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "110";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_or;

    procedure op_and(
        constant rd    : in std_logic_vector(11 downto 7);
        constant rs1    : in std_logic_vector(19 downto 15);
        constant rs2    : in std_logic_vector(24 downto 20);

        signal signals  : out std_logic_vector(65 downto 0)            
    ) is
        constant funct7     : std_logic_vector(31 downto 25)    := "0000000";
        constant funct3     : std_logic_vector(14 downto 12)    := "111";
        constant opcode     : std_logic_vector(6 downto 0)      := "0110011";
        variable inst       : std_logic_vector(31 downto 0);
    begin
        inst := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        load_inst(inst, signals);
    end procedure op_and;
end package body getto_compiler;