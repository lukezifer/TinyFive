library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
generic(
	size : integer
);
port(
	clk		: in  std_logic;
	addr	: in  std_logic_vector(7 downto 0);
	dout	: out std_logic_vector(31 downto 0)
);
end entity rom;

architecture behaviour of rom is
	type rom_t is array(0 to size - 1) of std_logic_vector(31 downto 0);
	signal rom_set : rom_t := (
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
	instr_mem: process(addr, rom_set)
	begin
			dout <= rom_set(to_integer(unsigned(addr)));
	end process instr_mem;
end architecture behaviour;
