library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the alu and its external environment
entity u32_alu_controller is
	port (
		aluop	: in std_logic_vector(1 downto 0) := (others => '0');
		funct	: in nibble_vector := (others => '0');
		alu_control	: out nibble_vector := (others => '0')
	);
end u32_alu_controller;

-- define the internal organisation and operation of the alu
architecture rtl of u32_alu_controller is
	-- architecture declarations
	subtype aluop_vector is std_logic_vector(1 downto 0);
	subtype alu_inst_vector is std_logic_vector(5 downto 0);

	-- aluop
	constant branch_aluop   : aluop_vector := "10";
	constant store_aluop    : aluop_vector := "11";
	constant opimm_aluop    : aluop_vector := "00";
	constant op_aluop       : aluop_vector := "01";

	-- instructions that use the ALU
	constant beq_inst0		: alu_inst_vector := branch_aluop & "0000";
	constant beq_inst1		: alu_inst_vector := branch_aluop & "1000";
	constant bne_inst0		: alu_inst_vector := branch_aluop & "0001";
	constant bne_inst1		: alu_inst_vector := branch_aluop & "1001";
	constant blt_inst0		: alu_inst_vector := branch_aluop & "0100";
	constant blt_inst1		: alu_inst_vector := branch_aluop & "1100";
	constant bge_inst0		: alu_inst_vector := branch_aluop & "0101";
	constant bge_inst1		: alu_inst_vector := branch_aluop & "1101";
	constant bltu_inst0		: alu_inst_vector := branch_aluop & "0110";
	constant bltu_inst1		: alu_inst_vector := branch_aluop & "1110";
	constant bgeu_inst0		: alu_inst_vector := branch_aluop & "0111";
	constant bgeu_inst1		: alu_inst_vector := branch_aluop & "1111";

	constant sb_inst0		: alu_inst_vector := store_aluop & "0000";
	constant sb_inst1		: alu_inst_vector := store_aluop & "1000";
	constant sh_inst0		: alu_inst_vector := store_aluop & "0001";
	constant sh_inst1		: alu_inst_vector := store_aluop & "1001";
	constant sw_inst0		: alu_inst_vector := store_aluop & "0010";
	constant sw_inst1		: alu_inst_vector := store_aluop & "1010";

	constant addi_inst0		: alu_inst_vector := opimm_aluop & "0000";
	constant addi_inst1		: alu_inst_vector := opimm_aluop & "1000";
	constant slti_inst0		: alu_inst_vector := opimm_aluop & "0010";
	constant slti_inst1		: alu_inst_vector := opimm_aluop & "1010";
	constant sltiu_inst0	: alu_inst_vector := opimm_aluop & "0011";
	constant sltiu_inst1	: alu_inst_vector := opimm_aluop & "1011";
	constant xori_inst0		: alu_inst_vector := opimm_aluop & "0100";
	constant xori_inst1		: alu_inst_vector := opimm_aluop & "1100";
	constant ori_inst0		: alu_inst_vector := opimm_aluop & "0110";
	constant ori_inst1		: alu_inst_vector := opimm_aluop & "1110";
	constant andi_inst0		: alu_inst_vector := opimm_aluop & "0111";
	constant andi_inst1		: alu_inst_vector := opimm_aluop & "1111";
	constant slli_inst		: alu_inst_vector := opimm_aluop & "0001";
	constant srli_inst		: alu_inst_vector := opimm_aluop & "0101";
	constant srai_inst		: alu_inst_vector := opimm_aluop & "1101";
	
	constant add_inst		: alu_inst_vector := op_aluop & "0000";
	constant sub_inst		: alu_inst_vector := op_aluop & "1000";
	constant sll_inst		: alu_inst_vector := op_aluop & "0001";
	constant slt_inst		: alu_inst_vector := op_aluop & "0010";
	constant sltu_inst		: alu_inst_vector := op_aluop & "0011";
	constant xor_inst		: alu_inst_vector := op_aluop & "0100";
	constant srl_inst		: alu_inst_vector := op_aluop & "0101";
	constant sra_inst		: alu_inst_vector := op_aluop & "1101";
	constant or_inst		: alu_inst_vector := op_aluop & "0110";
	constant and_inst		: alu_inst_vector := op_aluop & "0111";

	signal inst_alu 		: alu_inst_vector := (others => '0');

-- concurrent statements
begin
	inst_alu <= aluop & funct;

	with inst_alu select 
	alu_control <=  alu_slt		when blt_inst1  | bge_inst1  | slti_inst1 | blt_inst0  | bge_inst0  | slti_inst0  | slt_inst,
					alu_sltu	when bltu_inst1 | bgeu_inst1 | sltiu_inst1 | bltu_inst0 | bgeu_inst0 | sltiu_inst0 | sltu_inst,
					alu_and		when andi_inst1 | andi_inst0 | and_inst,
					alu_or		when ori_inst1  | ori_inst0 | or_inst,
					alu_xor		when xori_inst1 | xori_inst0 | xor_inst,
					alu_sll		when slli_inst | sll_inst,
					alu_srl		when srli_inst | srl_inst,
					alu_sra		when srai_inst | sra_inst,
					alu_sub		when sub_inst | beq_inst0 | beq_inst1 | bne_inst0 | bne_inst1,
					alu_pass	when sb_inst1 | sh_inst1 | sw_inst1 | sb_inst0 | sh_inst0 | sw_inst0,
					alu_add		when others;
end rtl;