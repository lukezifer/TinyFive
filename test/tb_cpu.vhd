library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
end tb_cpu;

architecture behaviour of tb_cpu is
	component cpu is
		port(
			clk : in std_logic;
			rst : in std_logic;
			test : in std_logic;
			test_instr : in std_logic_vector(31 downto 0)
		);
	end component;

	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk : std_logic;
	signal tb_rst : std_logic;
	signal tb_test : std_logic;
	signal tb_test_instr : std_logic_vector(31 downto 0);

begin
tb_test <= '1';

dut: cpu
port map(
	clk => tb_clk,
	rst => tb_rst,
	test => tb_test,
	test_instr => tb_test_instr
);

clock : process
begin
	tb_clk <= '1';
	wait for CLOCK_PERIOD/2;
	tb_clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

run : process
begin
	--nop
	tb_test_instr <= x"00000013";
	tb_rst <= '1';
	wait for 2 * CLOCK_PERIOD;
	tb_rst <= '0';
	wait for CLOCK_PERIOD;
	wait;
end process run;

end behaviour;
