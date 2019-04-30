library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_alu is
end entity tb_alu;

architecture behaviour of tb_alu is
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_oper	: std_logic_vector(3 downto 0);
	signal tb_a_in	: std_logic_vector(31 downto 0);
	signal tb_b_in	: std_logic_vector(31 downto 0);
	signal tb_c_out	: std_logic_vector(31 downto 0);
	signal tb_z_flag: std_logic;
begin
dut: entity work.alu
port map(
	oper   => tb_oper,
	a_in   => tb_a_in,
	b_in   => tb_b_in,
	c_out  => tb_c_out,
	z_flag => tb_z_flag
);

test: process
begin
	--initialization
	tb_oper <= "0000";
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_z_flag;
	wait on tb_z_flag;
	assert (tb_c_out = 0 and tb_z_flag = '1') report "initialization failed" severity error;
	wait for CLOCK_PERIOD;
	--AND Testcase 1
	tb_oper <= "0000";
	tb_a_in <= x"01010101";
	tb_b_in <= x"11111111";
	wait on tb_z_flag;
	assert(tb_c_out = 16#1010101# and tb_z_flag = '0') report "AND Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--AND Testcase 2
	tb_oper <= "0000";
	tb_a_in <= x"10101010";
	tb_b_in <= x"01010101";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "AND Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--OR Testcase 1
	tb_oper <= "0001";
	tb_a_in <= x"01010101";
	tb_b_in <= x"10101010";
	wait on tb_z_flag;
	assert(tb_c_out = 16#11111111# and tb_z_flag = '0') report "OR Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--OR Testcase 2
	tb_oper <= "0001";
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "OR Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--add Testcase 1
	tb_oper <= "0010";
	tb_a_in <= x"00000001";
	tb_b_in <= x"00000010";
	wait on tb_z_flag;
	assert(tb_c_out = 16#11# and tb_z_flag = '0') report "add Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--add Testcase 2
	tb_oper <= "0010";
	tb_a_in <= x"FFFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "add Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--sub Testcase 1
	tb_oper <= "0110";
	tb_a_in <= x"00000010";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 16#F# and tb_z_flag = '0') report "sub Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--sub Testcase 2
	tb_oper <= "0110";
	tb_a_in <= x"F0F0F0F0";
	tb_b_in <= x"F0F0F0F0";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "sub Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--slt Testcase 1
	tb_oper <= "0111";
	tb_a_in <= x"0FFFFFF1";
	tb_b_in <= x"0FFFFFFF";
	wait on tb_z_flag;
	assert(tb_c_out = 1 and tb_z_flag = '0') report "slt Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--slt Testcase 2
	tb_oper <= "0111";
	tb_a_in <= x"0FFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "slt Testcase 2 failed" severity error;
	wait for CLOCK_PERIOD;
	--NOR Testcase 1
	--tb_oper <= "1100";
	--tb_a_in <= x"F0F0F0F0";
	--tb_b_in <= x"0FFF0F00";
	--wait on tb_z_flag;
	--assert(tb_c_out = 16#0000000F# and tb_z_flag = '0') report "NOR Testcase 1 failed" severity error;
	--wait for CLOCK_PERIOD;
	--NOR Testcase 2
	--tb_oper <= "1100";
	--tb_a_in <= x"0F0F0F0F";
	--tb_b_in <= x"F0F0F0F0";
	--wait on tb_z_flag;
	--assert(tb_c_out = 0 and tb_z_flag = '1') report "NOR Testcase 2 failed" severity error;
	--wait for CLOCK_PERIOD;
	--Default Testcase
	tb_oper <= "1111";
	tb_a_in <= x"FFFF0000";
	tb_b_in <= x"0000FFFF";
	assert(tb_c_out = 0 and tb_z_flag = '1') report "Default Testcase failed" severity error;
	wait for CLOCK_PERIOD;
	wait;
end process test;

end architecture behaviour;
