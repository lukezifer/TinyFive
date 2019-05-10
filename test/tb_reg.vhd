library ieee;
use ieee.std_logic_1164.all;

entity tb_reg is
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

test: process
begin
	tb_rst <= '1';
	tb_w_enable <= '0';
	tb_w_addr <= "00000";
	tb_r_addr1 <= "00000";
	tb_r_addr2 <= "00000";
	tb_w_data <= x"00000000";
	tb_r_data1 <= x"00000000";
	tb_r_data2 <= x"00000000";
	wait for CLOCK_PERIOD * 2;
	tb_rst <= '0';
	wait for CLOCK_PERIOD;

	wait;
end process test;

end architecture behaviour;
