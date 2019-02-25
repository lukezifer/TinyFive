library ieee;
use ieee.std_logic_1164.all;

entity tb_pc is
end tb_pc;

architecture behaviour of tb_pc is
	constant CLOCK_PERIOD : time := 10 ns;
	signal clk		: std_logic;
	signal rst		: std_logic;
	signal ld		: std_logic;
	signal en		: std_logic;
	signal data_in	: std_logic_vector(31 downto 0);
	signal cnt		: std_logic_vector(31 downto 0);

begin

dut : entity work.pc
port map(
	clk		=> clk,
	rst		=> rst,
	ld		=> ld,
	en		=> en,
	data_in	=> data_in,
	cnt		=> cnt
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
	en <= '0';
	ld <= '0';
	data_in <= x"00000000";
	wait for CLOCK_PERIOD;
	wait until clk = '1';
	rst <= '0';
	en <= '1';
	wait;
end process run;

end behaviour;
