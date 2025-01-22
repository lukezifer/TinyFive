--------------------------------------------------------------------------------
--! @file
--! @brief Instruction Memory
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library.
library ieee;
--! use std_logic_1164 for std_logic and std_logic_vector.
use ieee.std_logic_1164.all;
--! use numeric_std for unsigned.
use ieee.numeric_std.all;

--! Interface for Instruction Memory.

--! The size of ROM is configurable.
entity rom is
generic(
	size : integer --! Configurable size of ROM in bytes. Shall be aligned to 4 bytes.
);

port(
	clk		: in  std_logic; --! Clock Input Signal, unused
	addr	: in  std_logic_vector(7 downto 0); --! 8 bit Address Input Vector
	dout	: out std_logic_vector(31 downto 0) --! 32 bit Output Data Vector
);
end entity rom;

--! @brief Instruction Memory Implementation.
architecture behaviour of rom is
	type rom_t is array(0 to size - 1) of std_logic_vector(31 downto 0); --! Instructions Array.
	signal rom_set : rom_t := ( --! Internal Array for Instructions.
		--_start
		x"0010c0b3",	--xor ra, ra, ra
		x"00214133",	--xor sp, sp, sp
		x"06410113",	--addi sp, sp, 0x64
		--count
		x"00108093",	--addi ra, ra, 0x1
		x"fe20cee3",	--blt ra, sp, count
		--reset
		x"0010c0b3",	--xor ra, ra, ra
		x"fe108ae3",	--beq ra, ra, count
		others => x"00000013"); --nop
begin

	--! Asynchronous Read from ROM.
	--! @vhdlflow
	instr_mem: process(addr, rom_set)
	begin
			dout <= rom_set(to_integer(unsigned(addr)));
	end process instr_mem;

end architecture behaviour;
