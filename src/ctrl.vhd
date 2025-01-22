--------------------------------------------------------------------------------
--! @file
--! @brief Control Unit
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library

library ieee;
  --! use std_logic_1164 for std_logic and std_logic_vector.
  use ieee.std_logic_1164.all;
  --! use std_logic_unsigned for arithmetic operations with std_logic.
  use ieee.std_logic_unsigned.all;
  --! use numeric_std for unsigned.
  use ieee.numeric_std.all;
  --! use types library
  use work.cpu_types.all;

--! Interface for Control Unit

entity ctrl is
  port (
    opcode     : in    std_logic_vector(6 downto 0); --! 7 bit OpCode Vector.
    branch     : out   std_logic;                    --! Indicates branch shall be taken.
    imm_in     : out   std_logic;                    --! Indicates load immediate.
    jump       : out   std_logic;                    --! Indicates JMP instruction.
    mem_read   : out   std_logic;                    --! Indicates to read from memory.
    mem_to_reg : out   std_logic;                    --! Indicates to load from memory to register.
    alu_op     : out   alu_op_enum;                  --! Indicates ALU Operation.
    mem_write  : out   std_logic;                    --! Indicates to write to memory.
    alu_src    : out   std_logic;                    --! Indicates ALU src.
    reg_write  : out   std_logic;                    --! Indicates to write to register.
    pc_imm     : out   std_logic                     --! Indicates load immediate to PC.
  );
end entity ctrl;

--! @brief Control Implementation
--! @details Setting Control Signals depending on the OpCode asynchron.
--! R-Instructions, I-Instructions, B-Instructions, S-Instructions,
--! J-Instructions and U-Instructions are supported.

architecture behaviour of ctrl is

begin

  --! Asynchron OpCode Decoding.
  --! @vhdlflow
  decode : process (opcode) is
  begin

    case (opcode) is

      -- R-Instruction 0110011
      when "0110011" =>

        branch     <= '0';
        imm_in     <= '0';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_R;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '1';
        pc_imm     <= '0';

      -- I-Instruction 0010011
      when "0010011" =>

        branch     <= '0';
        imm_in     <= '0';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_I;
        mem_write  <= '0';
        alu_src    <= '1';
        reg_write  <= '1';
        pc_imm     <= '0';

      -- I-Instruction 1100111 jalr
      when "1100111" =>

        branch     <= '0';
        imm_in     <= '0';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_I;
        mem_write  <= '0';
        alu_src    <= '1';
        reg_write  <= '1';
        pc_imm     <= '0';

      -- B-Instruction 1100011
      when "1100011" =>

        branch     <= '1';
        imm_in     <= '0';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_B;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '0';
        pc_imm     <= '0';

      -- S-Instruction 0100011
      when "0100011" =>

        branch     <= '0';
        imm_in     <= '0';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_S;
        mem_write  <= '1';
        alu_src    <= '1';
        reg_write  <= '0';
        pc_imm     <= '0';

      -- J-Instruction 1101111
      when "1101111" =>

        branch     <= '0';
        imm_in     <= '0';
        jump       <= '1';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_R;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '1';
        pc_imm     <= '0';

      -- U-Instruction lui 0110111
      when "0110111" =>

        branch     <= '0';
        imm_in     <= '1';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_R;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '1';
        pc_imm     <= '0';

      -- U-Instruction auipc 0010111
      when "0010111" =>

        branch     <= '0';
        imm_in     <= '1';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_U;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '1';
        pc_imm     <= '1';

      -- Others not implemented yet
      when others =>

        branch     <= '0';
        imm_in     <= '1';
        jump       <= '0';
        mem_read   <= '0';
        mem_to_reg <= '0';
        alu_op     <= ALU_OP_R;
        mem_write  <= '0';
        alu_src    <= '0';
        reg_write  <= '0';
        pc_imm     <= '0';

    end case;

  end process decode;

end architecture behaviour;

