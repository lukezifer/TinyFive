library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_pc is
end tb_pc;

architecture behaviour of tb_pc is
	component pc is
		port(
			clk : in std_logic;
			rst : in std_logic;
			ld : in std_logic;
			en : in std_logic;
			data_in : in std_logic_vector(31 downto 0);
			cnt : out std_logic_vector(31 downto 0)
			);
	end component pc;

	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk		: std_logic;
	signal tb_rst		: std_logic;
	signal tb_ld		: std_logic;
	signal tb_en		: std_logic;
	signal tb_data_in	: std_logic_vector(31 downto 0);
	signal tb_cnt		: std_logic_vector(31 downto 0);

begin
dut: pc
port map(
	clk		=> tb_clk,
	rst		=> tb_rst,
	ld		=> tb_ld,
	en		=> tb_en,
	data_in	=> tb_data_in,
	cnt		=> tb_cnt
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
	--Initialization
	tb_en <= '0';
	tb_ld <= '0';
	tb_data_in <= x"00000000";
	tb_rst <= '1';
	wait on tb_cnt;
	assert (tb_cnt = 0) report "Initialization failed" severity error;
	wait for CLOCK_PERIOD;
	--Counting Testcase 1
	tb_rst <= '0';
	tb_en <= '1';
	wait on tb_cnt;
	assert (tb_cnt = 4) report "Counting Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--Counting Testcase 2
	wait on tb_cnt;
	assert (tb_cnt = 8) report "Counting Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--Load Testcase 1
	tb_data_in <= x"0000FFF0";
	tb_ld <= '1';
	wait on tb_cnt;
	assert (tb_cnt = 16#FFF0#) report "Load Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	tb_ld <= '0';
	wait for CLOCK_PERIOD;
	wait for CLOCK_PERIOD;
	assert (tb_cnt = 16#FFF8#) report "Load Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--Load Testcase 2
	tb_data_in <= x"000000F0";
	tb_ld <= '1';
	wait on tb_cnt;
	assert (tb_cnt = 16#F0#) report "Load Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	tb_ld <= '0';
	wait for CLOCK_PERIOD;
	wait for CLOCK_PERIOD;
	assert (tb_cnt = 16#F8#) report "Load Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--Reset Testcase 1
	tb_ld <= '1';
	tb_en <= '1';
	tb_rst <= '1';
	wait on tb_cnt;
	assert (tb_cnt = 0) report "Reset Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	tb_ld <= '0';
	tb_en <= '1';
	tb_rst <= '0';
	wait on tb_cnt;
	wait for CLOCK_PERIOD;
	assert (tb_cnt = 4) report "Reset Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--Reset Testcase 2
	tb_rst <= '1';
	tb_en <= '0';
	wait on tb_cnt;
	assert (tb_cnt = 0) report "Reset Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	wait for CLOCK_PERIOD;
	assert (tb_cnt = 0) report "Reset Testcase 2 failed" severity error;
	wait;
end process run;

end behaviour;
