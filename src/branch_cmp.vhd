--------------------------------------------------------------------------------
--! @file
--! @brief Branch Compare
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library.

library ieee;
  --! use std_logic_1164 for std_logic and std_logic_vector.
  use ieee.std_logic_1164.all;
  --! use std_ for arithmetic operations with std_logic.
  use ieee.std_logic_unsigned.all;
  --! use numeric_std for unsigned.
  use ieee.numeric_std.all;
  --! use types library
  use work.cpu_types.all;

--! Interface for Branch Compare

entity branch_cmp is
  port (
    alu_op   : in    alu_op_enum;                   --! Input ALU Operation.
    instr_in : in    std_logic_vector(31 downto 0); --! Input Instruction Vector
    rs1_data : in    std_logic_vector(31 downto 0); --! Input Data 1 Vector.
    rs2_data : in    std_logic_vector(31 downto 0); --! Input Data 2 Vector.
    branch   : out   std_logic                      --! Output Signal: '0' no branch, '1' take branch.
  );
end entity branch_cmp;

--! @brief Branch Compare Implementation
--! @details Branch Compare is asynchron. Compares `rs1_data` with `rs2_data`,
--! depending on `alu_op` and `instr_in`. `branch` indicates if a branch shall
--! be taken.
--! Branch Equal, Branch Not Equal, Branch Less Than, Branch Greater Than,
--! Branch Less Than Unsigned and Branch Greater Than Unsigned are supported.

architecture behaviour of branch_cmp is

  signal funct3 : std_logic_vector(2 downto 0); --! Funct3 Slice of Instruction.

begin

  funct3 <= instr_in(14 downto 12);

  --! Asynchronous Branch Compare.
  --! @vhdlflow
  compare : process (alu_op, funct3, rs1_data, rs2_data) is
  begin

    if (alu_op = ALU_OP_B) then

      case funct3 is

        -- beq 000
        when "000" =>

          if (rs1_data = rs2_data) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        -- bne 001
        when "001" =>

          if (rs1_data /= rs2_data) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        -- blt 100
        when "100" =>

          if (signed(rs1_data) < signed(rs2_data)) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        -- bge 101
        when "101" =>

          if (signed(rs1_data) >= signed(rs2_data)) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        -- bltu 110
        when "110" =>

          if (unsigned(rs1_data) < unsigned(rs2_data)) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        -- bgeu 111
        when "111" =>

          if (unsigned(rs1_data) >= unsigned(rs2_data)) then
            branch <= '1';
          else
            branch <= '0';
          end if;

        when others =>

          branch <= '0';

      end case;

    else
      branch <= '0';
    end if;

  end process compare;

end architecture behaviour;
