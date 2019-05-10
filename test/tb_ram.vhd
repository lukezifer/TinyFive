library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_ram is
end tb_ram;

architecture behaviour of tb_ram is
	component ram is
		port(
			clk : in std_logic;
			addr : in std_logic_vector(7 downto 0);
			r_en : in std_logic;
			w_en : in std_logic;
			din : in std_logic_vector(31 downto 0);
			dout : out std_logic_vector(31 downto 0)
		);
	end component ram;

	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk  : std_logic;
	signal tb_addr : std_logic_vector(7 downto 0);
	signal tb_r_en : std_logic;
	signal tb_w_en : std_logic;
	signal tb_din  : std_logic_vector(31 downto 0);
	signal tb_dout : std_logic_vector(31 downto 0);

begin
dut: ram
port map(
	clk  => tb_clk,
	addr => tb_addr,
	r_en => tb_r_en,
	w_en => tb_w_en,
	din  => tb_din,
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
	tb_r_en <= '0';
	tb_w_en <= '0';
	tb_addr <= "00000000";
	tb_din <= x"00000000";
	wait for CLOCK_PERIOD;
	--Testcase 1, test RW
	tb_r_en <= '0';
	tb_w_en <= '1';
	tb_addr <= "00000001";
	tb_din <= x"00000001";
	wait for CLOCK_PERIOD;
	tb_r_en <= '1';
	tb_w_en <= '0';
	tb_addr <= "00000001";
	wait for CLOCK_PERIOD;
	assert(tb_dout = 16#00000001#) report "Testcase 1 RW failed" severity error;
	--Testcase 2, test simultan RW
	tb_r_en <= '1';
	tb_w_en <= '1';
	tb_addr <= "00000010";
	tb_din <= x"00000011";
	wait for CLOCK_PERIOD;
	assert(tb_dout = 16#00000011#) report "Testcase 2 simultan RW failed" severity error;
	--Testcase 3, test async R
	tb_r_en <= '1';
	tb_w_en <= '1';
	tb_addr <= "00000010";
	tb_din <= x"00000011";
	wait for CLOCK_PERIOD;
	tb_r_en <= '0';
	tb_w_en <= '1';
	tb_addr <= "00000011";
	tb_din <= x"00000111";
	wait for CLOCK_PERIOD;
	tb_w_en <= '1';
	tb_r_en <= '0';
	tb_addr <= "00000110";
	tb_din <= x"00001111";
	wait for CLOCK_PERIOD;
	assert(tb_dout = 16#00000011#) report "Testcase 3 async R failed" severity error;
	wait;
end process test;

end architecture behaviour;
