--------------------------------------------------------------------------------
--! @file types.vhd
--! @brief Additional Types for CPU
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! @brief Additional Types used in CPU.
--! @details Enumerations for ALU Intructions and ALU Opcodes.
package cpu_types is

--! @brief Enum for ALU Instruction.
--! @details ADD, AND, OR, SLL, SLT, SLTU, SRA, SRL, SUB, XOR and ZERO are supported.
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

	--! @brief Enum for ALU Opcode.
	--! @details B-Instructions, I-Instructions, R-Instructions, S-Instructions
	--! and U-Instructions are supported.
	type ALU_OP_ENUM is 
	(
		ALU_OP_B,
		ALU_OP_I,
		ALU_OP_R,
		ALU_OP_S,
		ALU_OP_U
	);

end package cpu_types;
