library ieee;
use ieee.std_logic_1164.all;

entity tb_ram is
end tb_ram;

architecture behaviour of tb_ram is
	constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk  : std_logic;
	signal tb_addr : std_logic_vector(7 downto 0);
	signal tb_r_en : std_logic;
	signal tb_w_en : std_logic;
	signal tb_din  : std_logic_vector(31 downto 0);
	signal tb_dout : std_logic_vector(31 downto 0);
begin
dut: entity work.ram
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
	tb_r_en <= '0';
	tb_w_en <= '0';
	tb_addr <= "00000000";
	tb_din <= x"00000000";
	wait for CLOCK_PERIOD;
	tb_w_en <= '1';
	tb_addr <= "00000001";
	tb_din <= x"00000001";
	wait;

end process test;
end architecture behaviour;
