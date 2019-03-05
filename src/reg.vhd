library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity reg is
port(
	clk		: in	std_logic;
	rst		: in	std_logic;
	r_addr1	: in	std_logic_vector(4 downto 0);
	r_data1	: out	std_logic_vector(31 downto 0);
	r_addr2	: in	std_logic_vector(4 downto 0);
	r_data2	: out	std_logic_vector(31 downto 0);
	w_addr	: in	std_logic_vector(4 downto 0);
	w_data	: in	std_logic_vector(31 downto 0);
	w_enable: in	std_logic
);
end entity reg;

architecture behaviour of reg is
	type register_t is array (0 to 31) of std_logic_vector(31 downto 0);
	signal register_set : register_t;
begin
	write_data: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				for idx in 0 to 31 loop
					register_set(idx) <= (others => '0');
				end loop;
			elsif(w_enable = '1') then
				register_set(to_integer(unsigned(w_addr))) <= w_data;
			end if;
		end if;
	end process write_data;

end architecture behaviour;
