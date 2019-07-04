library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.types.all;

entity tb_alu is
end entity tb_alu;

architecture behaviour of tb_alu is
	component alu is
		port(
			instr : in ALU_INSTR_ENUM;
			a_in : in std_logic_vector(31 downto 0);
			b_in : in std_logic_vector(31 downto 0);
			c_out : out std_logic_vector(31 downto 0);
			z_flag : out std_logic
		);

	end component alu;
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_instr	: ALU_INSTR_ENUM;
	signal tb_a_in	: std_logic_vector(31 downto 0);
	signal tb_b_in	: std_logic_vector(31 downto 0);
	signal tb_c_out	: std_logic_vector(31 downto 0);
	signal tb_z_flag: std_logic;

begin
dut: alu
port map(
	instr   => tb_instr,
	a_in   => tb_a_in,
	b_in   => tb_b_in,
	c_out  => tb_c_out,
	z_flag => tb_z_flag
);

test: process
begin
	--initialization
	tb_instr <= ALU_INSTR_AND;
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	wait on tb_z_flag for CLOCK_PERIOD;
	assert (tb_c_out = 0 and tb_z_flag = '1') report "initialization failed" severity failure;
	wait for CLOCK_PERIOD;
	--ADD Testcase 1
	tb_instr <= ALU_INSTR_ADD;
	tb_a_in <= x"00000001";
	tb_b_in <= x"00000010";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 16#11# and tb_z_flag = '0') report "ADD Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--ADD Testcase 2
	tb_instr <= ALU_INSTR_ADD;
	tb_a_in <= x"FFFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "ADD Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--AND Testcase 1
	tb_instr <= ALU_INSTR_AND;
	tb_a_in <= x"01010101";
	tb_b_in <= x"11111111";
	wait on tb_z_flag;
	assert(tb_c_out = 16#1010101# and tb_z_flag = '0') report "AND Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--AND Testcase 2
	tb_instr <= ALU_INSTR_AND;
	tb_a_in <= x"10101010";
	tb_b_in <= x"01010101";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "AND Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--OR Testcase 1
	tb_instr <= ALU_INSTR_OR;
	tb_a_in <= x"01010101";
	tb_b_in <= x"10101010";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 16#11111111# and tb_z_flag = '0') report "OR Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--OR Testcase 2
	tb_instr <= ALU_INSTR_OR;
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "OR Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLL Testcase 1
	tb_instr <= ALU_INSTR_SLL;
	tb_a_in <= x"00000001";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 16#2# and tb_z_flag = '0') report "SLL Testcase 1 failed" severity failure;
	--SLL Testcase 2
	tb_instr <= ALU_INSTR_SLL;
	tb_a_in <= x"FFFFFFFE";
	tb_b_in <= x"0000001F";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SLL Testcase 2 failed" severity failure;
	--SLT Testcase 1
	tb_instr <= ALU_INSTR_SLT;
	tb_a_in <= x"0FFFFFF1";
	tb_b_in <= x"0FFFFFFF";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 1 and tb_z_flag = '0') report "SLT Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLT Testcase 2
	tb_instr <= ALU_INSTR_SLT;
	tb_a_in <= x"0FFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SLT Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLTU Testcase 1
	tb_instr <= ALU_INSTR_SLTU;
	tb_a_in <= x"FFFFFFF0";
	tb_b_in <= x"FFFFFFF1";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 1 and tb_z_flag = '0') report "SLTU Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLTU Testcase 2
	tb_instr <= ALU_INSTR_SLTU;
	tb_a_in <= x"FFFFFFF1";
	tb_b_in <= x"FFFFFFF0";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SLTU Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SRA Testcase 1
	tb_instr <= ALU_INSTR_SRA;
	tb_a_in <= x"F0000001";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = x"F8000000" and tb_z_flag = '0') report "SRA Testcase 1 failed" severity failure;
	--SRA Testcase 2
	tb_instr <= ALU_INSTR_SRA;
	tb_a_in <= x"00000001";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SRA Testcase 2 failed" severity failure;
	--SRL Testcase 1
	tb_instr <= ALU_INSTR_SRL;
	tb_a_in <= x"00000003";
	tb_b_in <= x"00000001";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 16#1# and tb_z_flag = '0') report "SRL Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SRL Testcase 2
	tb_instr <= ALU_INSTR_SRL;
	tb_a_in <= x"7FFFFFFF";
	tb_b_in <= x"0000001F";
	wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SRL Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SUB Testcase 1
	tb_instr <= ALU_INSTR_SUB;
	tb_a_in <= x"00000010";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 16#F# and tb_z_flag = '0') report "SUB Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SUB Testcase 2
	tb_instr <= ALU_INSTR_SUB;
	tb_a_in <= x"F0F0F0F0";
	tb_b_in <= x"F0F0F0F0";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SUB Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--XOR Testcase 1
	tb_instr <= ALU_INSTR_XOR;
	tb_a_in <= x"FFFFFFFF";
	tb_b_in <= x"F0F0F0F0";
	wait on tb_z_flag;
	assert(tb_c_out = 16#0F0F0F0F# and tb_z_flag = '0') report "XOR Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--XOR Testcase 2
	tb_instr <= ALU_INSTR_XOR;
	tb_a_in <= x"11111111";
	tb_b_in <= x"11111111";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "XOR Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--ZERO Testcase
	tb_instr <= ALU_INSTR_ZERO;
	tb_a_in <= x"FFFF0000";
	tb_b_in <= x"0000FFFF";
	assert(tb_c_out = 0 and tb_z_flag = '1') report "Default Testcase failed" severity failure;
	wait for CLOCK_PERIOD;
	wait;
end process test;

end architecture behaviour;
