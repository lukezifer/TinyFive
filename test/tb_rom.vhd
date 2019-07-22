library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_rom is
end tb_rom;


architecture behaviour of tb_rom is

	component rom
		generic(
			size : integer
		);
		port(
			clk : in std_logic;
			addr : in std_logic_vector(7 downto 0);
			dout : out std_logic_vector(31 downto 0)
		);
	end component;

	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk  : std_logic;
	signal tb_addr : std_logic_vector(7 downto 0);
	signal tb_dout : std_logic_vector(31 downto 0);

begin
dut: rom
generic map (
	size => 256
)
port map(
	clk  => tb_clk,
	addr => tb_addr,
	dout => tb_dout
);

clock: process
begin
	tb_clk <= '1';
	wait for CLOCK_PERIOD/2;
	tb_clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

test: process
begin
	--Init, set inputs to zero
	tb_addr <= x"00";
	wait for CLOCK_PERIOD;
	for idx in 0 to 32 loop
		tb_addr <= std_logic_vector(to_unsigned(idx, tb_addr'length));
		wait for CLOCK_PERIOD;
		wait on tb_clk;
		--Do not assert while test program in rom
		--assert(tb_dout = 16#13#) report "Testcase 1 failed" severity failure;
	end loop;
	wait;
end process test;

end architecture behaviour;
