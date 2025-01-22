--------------------------------------------------------------------------------
--! @file
--! @brief Immediate Generation Unit
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library.
library ieee;
--! use std_logic_1164 for std_logic_vector.
use ieee.std_logic_1164.all;
--! use std_logic_unsigned for arithmetic operations with std_logic.
use ieee.std_logic_unsigned.all;
--! use numeric_std for unsigned.
use ieee.numeric_std.all;

--! Immediate Generation Unit Interface.
entity imm_gen is
port(
	instr_in : in std_logic_vector(31 downto 0); --! Instruction Input.
	regs1_in : in std_logic_vector (31 downto 0); --! Register 1 Input.
	immediate_out : out std_logic_vector(63 downto 0) --! 64 bit Immediate Output.
);
end imm_gen;

--! @brief Immediate Generation Unit Implementation.
--! @details The Immediate Generation Unit generates the immediate value from
--! the provided register value dependent on the instruction type.
--! B-Instruction, I-Instruction, S-Instruction, U-Instruction and J-Instruction
--! as well as JALR are supported.
architecture behaviour of imm_gen is
	signal instr_type : std_logic_vector(6 downto 0); --! Internal value of Instruction Type.
begin
	instr_type <= instr_in(6 downto 0);

	--! Asynchronous Immediate Generation.
	--! @vhdlflow
	immediate: process(instr_in, instr_type)
		variable t: unsigned(32 downto 0);
	begin
	case instr_type is
		--B-Type
		when "1100011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31) & instr_in(7) & instr_in(30 downto 25) & instr_in(11 downto 8)), immediate_out'length));
		--I-Type
		when "0010011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 20)), immediate_out'length));
		--S-Type
		when "0100011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 25) & instr_in(11 downto 7)), immediate_out'length));
		--U-Type
		when "0110111" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 12) & "000000000000"), immediate_out'length));
		--J-Type
		when "1101111" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31) & instr_in(19 downto 12) & instr_in(20) & instr_in(30 downto 21)), immediate_out'length));
		--JALR Offset I-Type
		when "1100111" =>
			t := (unsigned(regs1_in) + unsigned(resize(signed(instr_in(31 downto 21)), regs1_in'length))) & '0';
			immediate_out <= std_logic_vector(resize(t(31 downto 0), immediate_out'length));
		when others =>
			immediate_out <= (others => '0');
	end case;
	end process;

end architecture behaviour;
