library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.run_pkg.all;

entity tb_reg is
	generic (runner_cfg: string);
end tb_reg;

architecture behaviour of tb_reg is
	component reg is
		port(
			clk : in std_logic;
			rst : in std_logic;
			r_addr1 : in std_logic_vector(4 downto 0);
			r_data1 : out std_logic_vector(31 downto 0);
			r_addr2 : in std_logic_vector(4 downto 0);
			r_data2 : out std_logic_vector(31 downto 0);
			w_addr : in std_logic_vector(4 downto 0);
			w_data : in std_logic_vector(31 downto 0);
			w_enable : in std_logic
		);

	end component;
	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk : std_logic;
	signal tb_rst : std_logic;
	signal tb_r_addr1 : std_logic_vector(4 downto 0);
	signal tb_r_data1 : std_logic_vector(31 downto 0);
	signal tb_r_addr2 : std_logic_vector(4 downto 0);
	signal tb_r_data2 : std_logic_vector(31 downto 0);
	signal tb_w_addr : std_logic_vector(4 downto 0);
	signal tb_w_data : std_logic_vector(31 downto 0);
	signal tb_w_enable : std_logic;

begin
dut: reg
port map(
	clk => tb_clk,
	rst => tb_rst,
	r_addr1 => tb_r_addr1,
	r_data1 => tb_r_data1,
	r_addr2 => tb_r_addr2,
	r_data2 => tb_r_data2,
	w_addr => tb_w_addr,
	w_data => tb_w_data,
	w_enable => tb_w_enable
);

clock: process
begin
	tb_clk <= '1';
	wait for CLOCK_PERIOD/2;
	tb_clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

test_runner: process
	variable i : integer := 0;
begin

	test_runner_setup(runner, runner_cfg);

	while test_suite loop
		i := 0;
		tb_rst <= '0';
		tb_w_enable <= '0';
		tb_w_addr <= b"00000";
		tb_r_addr1 <= b"00000";
		tb_r_addr2 <= b"00000";
		tb_w_data <= x"00000000";

		if run("Reset") then
			tb_w_data <= x"FFFF0000";
			tb_w_addr <= b"00001";
			wait for CLOCK_PERIOD;
			tb_w_data <= x"0000FFFF";
			tb_w_addr <= b"00000";
			wait for CLOCK_PERIOD;
			tb_rst <= '1';
			wait for CLOCK_PERIOD * 2;
			tb_rst <= '0';
			wait for CLOCK_PERIOD;
			while i < 32 loop
				tb_r_addr1 <= std_logic_vector(to_unsigned(i, tb_r_addr1'length));
				tb_r_addr2 <= std_logic_vector(to_unsigned(i + 1, tb_r_addr2'length));
				wait for CLOCK_PERIOD;
				check_match(tb_r_data1, x"00000000");
				check_match(tb_r_data2, x"00000000");
				i := i + 2;
			end loop;
		elsif run("Write/Read") then
			tb_rst <= '1';
			wait for CLOCK_PERIOD * 2;
			tb_rst <= '0';
			tb_w_enable <= '1';
			wait for CLOCK_PERIOD;
			while i < 32 loop
				tb_w_addr <= std_logic_vector(to_unsigned(i, tb_w_addr'length));
				tb_w_data <= std_logic_vector(to_unsigned(i, tb_w_data'length));
				wait for CLOCK_PERIOD;
				tb_w_addr <= std_logic_vector(to_unsigned(i + 1, tb_w_addr'length));
				tb_w_data <= std_logic_vector(to_unsigned(i + 1, tb_w_data'length));
				wait for CLOCK_PERIOD;
				tb_r_addr1 <= std_logic_vector(to_unsigned(i, tb_r_addr1'length));
				tb_r_addr2 <= std_logic_vector(to_unsigned(i + 1, tb_r_addr2'length));
				wait for CLOCK_PERIOD;
				check_match(tb_r_data1, std_logic_vector(to_unsigned(i, tb_r_data1'length)));
				check_match(tb_r_data2, std_logic_vector(to_unsigned(i + 1, tb_r_data2'length)));
				i := i + 2;
			end loop;
		elsif run("Write Not Enabled") then
			tb_rst <= '1';
			wait for CLOCK_PERIOD * 2;
			tb_rst <= '0';
			tb_w_enable <= '1';
			wait for CLOCK_PERIOD;
			while i < 32 loop
				tb_w_addr <= std_logic_vector(to_unsigned(i, tb_w_addr'length));
				tb_w_data <= std_logic_vector(to_unsigned(i, tb_w_data'length));
				wait for CLOCK_PERIOD;
				tb_w_addr <= std_logic_vector(to_unsigned(i + 1, tb_w_addr'length));
				tb_w_data <= std_logic_vector(to_unsigned(i + 1, tb_w_data'length));
				wait for CLOCK_PERIOD;
				i := i + 2;
			end loop;
			tb_w_enable <= '0';
			wait for CLOCK_PERIOD;
			tb_w_data <= x"FFFFFFFF";
			tb_w_addr <= b"00000";
			wait for CLOCK_PERIOD;
			tb_w_addr <= b"00001";
			wait for CLOCK_PERIOD;
			tb_r_addr1 <= b"00000";
			tb_r_addr2 <= b"00001";
			wait for CLOCK_PERIOD;
			check_match(tb_r_data1, x"00000000");
			check_match(tb_r_data2, x"00000001");
		end if;

	end loop;

	test_runner_cleanup(runner);

end process test_runner;

end architecture behaviour;
