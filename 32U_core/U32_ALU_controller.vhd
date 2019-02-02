library ieee;
use ieee.std_logic_1164.all;
use work.u32_types.all;

-- define the interface between the alu and its external environment
entity u32_alu_controller is
	port (
		aluop	: in std_logic_vector(1 downto 0) := (others => '0');
		funct	: in std_logic_vector(3 downto 0) := (others => '0');
		alu_control	: out nibble_vector := (others => '0')
	);
end u32_alu_controller;

-- define the internal organisation and operation of the alu
architecture behaviour of u32_alu_controller is
	-- architecture declarations
	-- aluop
	constant branch_aluop   : std_logic_vector(1 downto 0) := "10";
	constant store_aluop    : std_logic_vector(1 downto 0) := "11";
	constant opimm_aluop    : std_logic_vector(1 downto 0) := "00";
	constant op_aluop       : std_logic_vector(1 downto 0) := "01";

	-- instructions that use the ALU
	constant beq_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-000";
	constant bne_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-001";
	constant blt_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-100";
	constant bge_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-101";
	constant bltu_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-110";
	constant bgeu_inst	: std_logic_vector(5 downto 0) := branch_aluop & "-111";

	constant sb_inst	: std_logic_vector(5 downto 0) := store_aluop & "-000";
	constant sh_inst	: std_logic_vector(5 downto 0) := store_aluop & "-001";
	constant sw_inst	: std_logic_vector(5 downto 0) := store_aluop & "-010";

	constant addi_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-000";
	constant slti_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-010";
	constant sltiu_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-011";
	constant xori_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-100";
	constant ori_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-110";
	constant andi_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "-111";
	constant slli_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "0001";
	constant srli_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "0101";
	constant srai_inst	: std_logic_vector(5 downto 0) := opimm_aluop & "1101";
	
	constant add_inst	: std_logic_vector(5 downto 0) := op_aluop & "0000";
	constant sub_inst	: std_logic_vector(5 downto 0) := op_aluop & "1000";
	constant sll_inst	: std_logic_vector(5 downto 0) := op_aluop & "0001";
	constant slt_inst	: std_logic_vector(5 downto 0) := op_aluop & "0010";
	constant sltu_inst	: std_logic_vector(5 downto 0) := op_aluop & "0011";
	constant xor_inst	: std_logic_vector(5 downto 0) := op_aluop & "0100";
	constant srl_inst	: std_logic_vector(5 downto 0) := op_aluop & "0101";
	constant sra_inst	: std_logic_vector(5 downto 0) := op_aluop & "1101";
	constant or_inst	: std_logic_vector(5 downto 0) := op_aluop & "0110";
	constant and_inst	: std_logic_vector(5 downto 0) := op_aluop & "0111";

	signal inst_alu : std_logic_vector(5 downto 0) := (others => '0');

-- concurrent statements
begin
	inst_alu <= aluop & funct;

	with inst_alu select 
	alu_control <=  alu_slt		when blt_inst  | bge_inst  | slti_inst  | slt_inst,
					alu_sltu	when bltu_inst | bgeu_inst | sltiu_inst | sltu_inst,
					alu_and		when andi_inst | and_inst,
					alu_or		when ori_inst  | or_inst,
					alu_xor		when xori_inst | xor_inst,
					alu_sll		when slli_inst | sll_inst,
					alu_srl		when srli_inst | srl_inst,
					alu_sra		when srai_inst | sra_inst,
					alu_sub		when sub_inst,
					alu_pass	when sb_inst | sh_inst | sw_inst,
					alu_add		when others;
end behaviour;