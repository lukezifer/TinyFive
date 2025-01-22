--------------------------------------------------------------------------------
--! @file
--! @brief ALU Control
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library

library ieee;
  --! use std_logic_1164 for std_logic_vector.
  use ieee.std_logic_1164.all;
  --! use std_logic_unsigned for arithmetic operations with std_logic.
  use ieee.std_logic_unsigned.all;
  --! use numeric_std for unsigned.
  use ieee.numeric_std.all;
  --! use types library
  use work.cpu_types.all;

--! Interface for ALU Control

entity alu_ctrl is
  port (
    alu_op    : in    alu_op_enum;                   --! Input ALU Operation.
    instr_in  : in    std_logic_vector(31 downto 0); --! Input Instruction 32 bit.
    alu_instr : out   alu_instr_enum                 --! Indicates ALU Instruction.
  );
end entity alu_ctrl;

--! @brief ALU Control Implementation
--! @details Indicates the ALU Instruction depending on ALU Operation and
--! Instruction asynchron. R-Type, I-Type, S-Type and U-Type are supported.

architecture behaviour of alu_ctrl is

  signal funct3 : std_logic_vector(2 downto 0); --! Funct3 Slice of Instruction.
  signal funct7 : std_logic;                    --! Funct7 Slice of Instruction.

begin

  funct3 <= instr_in(14 downto 12);
  funct7 <= instr_in(30);

  --! Asynchronous ALU Instruction Encoding.
  --! @vhdlflow
  control : process (alu_op, funct3, funct7) is
  begin

    case alu_op is

      -- R-Type
      when ALU_OP_R =>

        -- ADD
        if (funct3 = "000" and funct7 = '0') then
          alu_instr <= ALU_INSTR_ADD;
        -- SUB
        elsif (funct3 = "000" and funct7 = '1') then
          alu_instr <= ALU_INSTR_SUB;
        -- SLL
        elsif (funct3 = "001" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SLL;
        -- SLT
        elsif (funct3 = "010" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SLT;
        -- SLTU
        elsif (funct3 = "011" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SLTU;
        -- XOR
        elsif (funct3 = "100" and funct7 = '0') then
          alu_instr <= ALU_INSTR_XOR;
        -- SRL
        elsif (funct3 = "101" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SRL;
        -- SRA
        elsif (funct3 = "101" and funct7 = '1') then
          alu_instr <= ALU_INSTR_SRA;
        -- OR
        elsif (funct3 = "110" and funct7 = '0') then
          alu_instr <= ALU_INSTR_OR;
        -- AND
        elsif (funct3 = "111" and funct7 = '0') then
          alu_instr <= ALU_INSTR_AND;
        else
          alu_instr <= ALU_INSTR_ZERO;
        end if;

      -- I-Type
      when ALU_OP_I =>

        -- ADDI, lb
        if (funct3 = "000") then
          alu_instr <= ALU_INSTR_ADD;
        -- SLLI
        elsif (funct3 = "001" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SLL;
        -- SLTI
        elsif (funct3 = "010") then
          alu_instr <= ALU_INSTR_SLT;
        -- SLTUI
        elsif (funct3 = "011") then
          alu_instr <= ALU_INSTR_SLTU;
        -- XORI
        elsif (funct3 = "100") then
          alu_instr <= ALU_INSTR_XOR;
        -- SRLI
        elsif (funct3 = "101" and funct7 = '0') then
          alu_instr <= ALU_INSTR_SRL;
        -- SRAI
        elsif (funct3 = "101" and funct7 = '1') then
          alu_instr <= ALU_INSTR_SRA;
        -- ORI
        elsif (funct3 = "110") then
          alu_instr <= ALU_INSTR_OR;
        -- ANDI
        elsif (funct3 = "111") then
          alu_instr <= ALU_INSTR_AND;
        else
          alu_instr <= ALU_INSTR_ZERO;
        end if;

      -- S-Type
      when ALU_OP_S =>

        alu_instr <= ALU_INSTR_ADD;

      -- U-Type
      when ALU_OP_U =>

        alu_instr <= ALU_INSTR_ADD;

      -- default
      when others =>

        alu_instr <= ALU_INSTR_ZERO;

    end case;

  end process control;

end architecture behaviour;
