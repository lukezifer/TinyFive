library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
end tb_cpu;

architecture behaviour of tb_cpu is
	constant CLOCK_PERIOD : time := 10 ns;
	signal clk		: std_logic;
	signal rst		: std_logic;
begin

dut : entity work.cpu
port map(
	clk		=> clk,
	rst		=> rst
);

clock : process
begin
	clk <= '1';
	wait for CLOCK_PERIOD/2;
	clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

run : process
begin
	rst <= '1';
	wait for 2 * CLOCK_PERIOD;
	rst <= '0';
	wait;
end process run;

end behaviour;
