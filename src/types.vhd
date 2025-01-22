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

  type alu_instr_enum is
	(
    alu_instr_add,
    alu_instr_and,
    alu_instr_or,
    alu_instr_sll,
    alu_instr_slt,
    alu_instr_sltu,
    alu_instr_sra,
    alu_instr_srl,
    alu_instr_sub,
    alu_instr_xor,
    alu_instr_zero
  );

  --! @brief Enum for ALU Opcode.
  --! @details B-Instructions, I-Instructions, R-Instructions, S-Instructions
  --! and U-Instructions are supported.

  type alu_op_enum is
	(
    alu_op_b,
    alu_op_i,
    alu_op_r,
    alu_op_s,
    alu_op_u
  );

end package cpu_types;
