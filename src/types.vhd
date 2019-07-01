library ieee;
use ieee.std_logic_1164.all;

package types is
	type ALU_INSTR_ENUM is 
	(
		ALU_INSTR_ADD,
		ALU_INSTR_AND,
		ALU_INSTR_OR,
		ALU_INSTR_SLL,
		ALU_INSTR_SLT,
		ALU_INSTR_SLTU,
		ALU_INSTR_SRA,
		ALU_INSTR_SRL,
		ALU_INSTR_SUB,
		ALU_INSTR_XOR,
		ALU_INSTR_ZERO
	);

	type ALU_OP_ENUM is
	(
		ALU_OP_I,
		ALU_OP_R,
		ALU_OP_S
	);

end package types;
