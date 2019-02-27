library ieee;
use ieee.std_logic_1164.all;

entity cpu is
port(
	clk: in std_logic;
	rst: in std_logic
);
end cpu;

architecture behaviour of cpu is
	signal pc_en : std_logic;
	signal pc_ld : std_logic;
	signal pc_in : std_logic_vector(31 downto 0);
	signal pc_out: std_logic_vector(31 downto 0);
begin

pc : entity work.pc
port map(
	clk => clk,
	rst => rst,
	ld  => pc_ld,
	en  => pc_en,
	data_in => pc_in,
	cnt => pc_out
	);
end architecture;
