library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
port(
	clk		: in  std_logic;
	addr	: in  std_logic_vector(7 downto 0);
	r_en	: in  std_logic;
	w_en	: in  std_logic;
	din		: in  std_logic_vector(31 downto 0);
	dout	: out std_logic_vector(31 downto 0)
);
end entity ram;

architecture behaviour of ram is
	type ram_t is array(0 to 255) of std_logic_vector(31 downto 0);
	signal ram_set : ram_t := (others => (others => '0'));
begin
	data_mem: process(clk)
	begin
		if(rising_edge(clk)) then
			if(w_en = '1') then
				ram_set(to_integer(unsigned(addr))) <= din;
			end if;
		end if;
		if(r_en = '1') then
			dout <= ram_set(to_integer(unsigned(addr)));
		end if;
	end process data_mem;

end architecture behaviour;
