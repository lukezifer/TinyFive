library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
port(
	clk		: in	std_logic;
	rst		: in	std_logic;
	ld		: in	std_logic;
	en		: in	std_logic;
	data_in	: in	std_logic_vector(31 downto 0);
	cnt		: out	std_logic_vector(31 downto 0)
);
end pc;

architecture behaviour of pc is
	signal internal_count : std_logic_vector(31 downto 0);
begin
	counter: process(clk)
	begin
		if(rising_edge(clk)) then
			if (rst = '1') then
				internal_count <= (others => '0');
			elsif (ld = '1') then
				internal_count <= data_in;
			elsif (en = '1') then
				internal_count <= std_logic_vector(unsigned(internal_count) + 4);
			end if;
		end if;
	end process;

	cnt <= internal_count;

end architecture;
