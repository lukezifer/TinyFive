--------------------------------------------------------------------------------
--! @file
--! @brief Arithmetic Logic Unit
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

--! Arithmetic Logic Unit Interface.

entity alu is
  port (
    instr  : in    alu_instr_enum;                --! ALU instruction.
    a_in   : in    std_logic_vector(31 downto 0); --! First input value.
    b_in   : in    std_logic_vector(31 downto 0); --! Second Input value.
    c_out  : out   std_logic_vector(31 downto 0); --! Output value.
    z_flag : out   std_logic                      --! Zero Flag Output.
  );
end entity alu;

--! @brief Arithmetic Logic Unit Implementation.
--! @details The ALU performs arithmetic and logical operations on two inputs
--! and outputs the computate value as well as a signal that indicates if the
--! output is '0'. Supported are all ALU instructions that are defined with
--! @a ALU_INSTR_ENUM from cpu_types.
--! @see types.vhd.

architecture behaviour of alu is

begin

  --! Asynchronous ALU operation.
  --! @vhdlflow
  calculate : process (instr, a_in, b_in) is

    variable output : std_logic_vector(31 downto 0); --! Internal value of output.
    variable zero   : std_logic;                     --! Internal state of zero flag.

  begin

    case instr is

      -- ADD
      when ALU_INSTR_ADD =>

        output := std_logic_vector(signed(a_in) + signed(b_in));

      -- AND
      when ALU_INSTR_AND =>

        output := a_in and b_in;

      -- OR
      when ALU_INSTR_OR =>

        output := a_in or b_in;

      -- SLL
      when ALU_INSTR_SLL =>

        output := std_logic_vector(shift_left(unsigned(a_in), to_integer(unsigned(b_in(4 downto 0)))));

      -- SLT
      when ALU_INSTR_SLT =>

        if (signed(a_in) < signed(b_in)) then
          output := x"00000001";
        else
          output := x"00000000";
        end if;

      -- SLTU
      when ALU_INSTR_SLTU =>

        if (unsigned(a_in) < unsigned(b_in)) then
          output := x"00000001";
        else
          output := x"00000000";
        end if;

      -- SRA
      when ALU_INSTR_SRA =>

        output := std_logic_vector(shift_right(signed(a_in), to_integer(unsigned(b_in(4 downto 0)))));

      -- SRL
      when ALU_INSTR_SRL =>

        output := std_logic_vector(shift_right(unsigned(a_in), to_integer(unsigned(b_in(4 downto 0)))));

      -- SUB
      when ALU_INSTR_SUB =>

        output := a_in - b_in;

      -- XOR
      when ALU_INSTR_XOR =>

        output := a_in xor b_in;

      -- default
      when others =>

        output := x"00000000";

    end case;

    if (output = 0) then
      zero := '1';
    else
      zero := '0';
    end if;

    c_out  <= output;
    z_flag <= zero;

  end process calculate;

end architecture behaviour;
