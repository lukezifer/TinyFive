library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
port(
	clk		: in  std_logic;
	addr	: in  std_logic_vector(7 downto 0);
	dout	: out std_logic_vector(31 downto 0)
);
end entity rom;

architecture behaviour of rom is
	type rom_t is array(0 to 255) of std_logic_vector(31 downto 0);
	signal rom_set : rom_t := (others => (others => '0'));
begin
	instr_mem: process(clk)
	begin
		if(rising_edge(clk)) then
			dout <= rom_set(to_integer(unsigned(addr)));
		end if;
	end process instr_mem;
end architecture behaviour;
