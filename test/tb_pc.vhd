library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.run_pkg.all;

entity tb_pc is
	generic (runner_cfg: string);
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

clock: process
begin
	tb_clk <= '1';
	wait for CLOCK_PERIOD/2;
	tb_clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

test_runner: process
begin

	test_runner_setup(runner, runner_cfg);

	while test_suite loop
		if run("Initialization") then
			tb_en <= '0';
			tb_ld <= '0';
			tb_data_in <= x"00000000";
			tb_rst <= '1';
			wait on tb_cnt;
			wait for CLOCK_PERIOD;
			tb_rst <= '0';
			-- initial count
			check_match(tb_cnt, x"00000000");
			tb_en <= '1';
			wait for CLOCK_PERIOD;
			-- 1st step
			check_match(tb_cnt, x"00000004");
			wait for CLOCK_PERIOD;
			-- 2nd step
			check_match(tb_cnt, x"00000008");
			wait for CLOCK_PERIOD;
			-- 3rd step
			check_match(tb_cnt, x"0000000C");
			wait for CLOCK_PERIOD;
			-- 4th step
			check_match(tb_cnt, x"00000010");

		elsif run("Enabled") then
			tb_en <= '0';
			tb_ld <= '0';
			tb_data_in <= x"00000000";
			tb_rst <= '1';
			wait on tb_cnt;
			wait for CLOCK_PERIOD;
			tb_rst <= '0';
			-- initial count
			check_match(tb_cnt, x"00000000");
			tb_en <= '1';
			wait for CLOCK_PERIOD;
			-- 1st step
			check_match(tb_cnt, x"00000004");
			tb_en <= '0';
			wait for CLOCK_PERIOD;
			-- no step
			check_match(tb_cnt, x"00000004");
			wait for CLOCK_PERIOD;
			-- no step
			check_match(tb_cnt, x"00000004");
			tb_en <= '1';
			wait for CLOCK_PERIOD;
			-- 2nd step
			check_match(tb_cnt, x"00000008");

		elsif run("Load 1") then
		--Load Testcase 1
			tb_data_in <= x"0000FFF0";
			tb_ld <= '1';
			tb_en <= '1';
			tb_rst <= '0';
			wait on tb_cnt;
			check_match(tb_cnt, x"0000FFF0");
			wait for CLOCK_PERIOD;
			tb_ld <= '0';
			-- 1st step
			wait for CLOCK_PERIOD;
			-- 2nd step
			wait for CLOCK_PERIOD;
			check_match(tb_cnt, x"0000FFF8");
			wait for CLOCK_PERIOD;

		elsif run("Load 2") then
		--Load Testcase 2
			tb_data_in <= x"000000F0";
			tb_ld <= '1';
			tb_en <= '1';
			tb_rst <= '0';
			wait on tb_cnt;
			check_match(tb_cnt, x"000000F0"); 
			wait for CLOCK_PERIOD;
			check_match(tb_cnt, x"000000F0"); 
			tb_ld <= '0';
			-- 1 step
			wait for CLOCK_PERIOD;
			-- 2 step
			wait for CLOCK_PERIOD;
			check_match(tb_cnt, x"000000F8"); 

		elsif run("Reset 1") then
		--Reset Testcase 1
			tb_ld <= '1';
			tb_en <= '1';
			tb_rst <= '1';
			tb_data_in <= x"FFFFFFF0";
			wait on tb_cnt;
			check_match(tb_cnt, x"00000000");
			tb_ld <= '0';
			tb_en <= '1';
			tb_rst <= '0';
			wait on tb_cnt;
			-- 1st step
			wait for CLOCK_PERIOD;
			check_match(tb_cnt, x"00000004");

		elsif run("Reset 2") then
		--Reset Testcase 2
			tb_rst <= '1';
			tb_en <= '0';
			tb_ld <= '0';
			tb_data_in <= x"FFFFFFF0";
			wait on tb_cnt;
			check_match(tb_cnt, x"00000000");
			-- no step
			wait for CLOCK_PERIOD;
			-- no step
			wait for CLOCK_PERIOD;
			check_match(tb_cnt, x"00000000");
		end if;

	end loop;

	test_runner_cleanup(runner);

end process test_runner;

end behaviour;
