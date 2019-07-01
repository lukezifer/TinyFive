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
			oper : in ALU_INSTR_ENUM;
			a_in : in std_logic_vector(31 downto 0);
			b_in : in std_logic_vector(31 downto 0);
			c_out : out std_logic_vector(31 downto 0);
			z_flag : out std_logic
		);

	end component alu;
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_oper	: ALU_INSTR_ENUM;
	signal tb_a_in	: std_logic_vector(31 downto 0);
	signal tb_b_in	: std_logic_vector(31 downto 0);
	signal tb_c_out	: std_logic_vector(31 downto 0);
	signal tb_z_flag: std_logic;

begin
dut: alu
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
	tb_oper <= ALU_INSTR_AND;
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_z_flag;
	wait on tb_z_flag;
	assert (tb_c_out = 0 and tb_z_flag = '1') report "initialization failed" severity failure;
	wait for CLOCK_PERIOD;
	--ADD Testcase 1
	tb_oper <= ALU_INSTR_ADD;
	tb_a_in <= x"00000001";
	tb_b_in <= x"00000010";
	wait on tb_z_flag;
	assert(tb_c_out = 16#11# and tb_z_flag = '0') report "ADD Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--ADD Testcase 2
	tb_oper <= ALU_INSTR_ADD;
	tb_a_in <= x"FFFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "ADD Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--AND Testcase 1
	tb_oper <= ALU_INSTR_AND;
	tb_a_in <= x"01010101";
	tb_b_in <= x"11111111";
	wait on tb_z_flag;
	assert(tb_c_out = 16#1010101# and tb_z_flag = '0') report "AND Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--AND Testcase 2
	tb_oper <= ALU_INSTR_ADD;
	tb_a_in <= x"10101010";
	tb_b_in <= x"01010101";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "AND Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--OR Testcase 1
	tb_oper <= ALU_INSTR_OR;
	tb_a_in <= x"01010101";
	tb_b_in <= x"10101010";
	wait on tb_z_flag;
	assert(tb_c_out = 16#11111111# and tb_z_flag = '0') report "OR Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--OR Testcase 2
	tb_oper <= ALU_INSTR_OR;
	tb_a_in <= x"00000000";
	tb_b_in <= x"00000000";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "OR Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLL Testcase 1
	--SLL Testcase 2
	--SLT Testcase 1
	tb_oper <= ALU_INSTR_SLT;
	tb_a_in <= x"0FFFFFF1";
	tb_b_in <= x"0FFFFFFF";
	wait on tb_z_flag;
	assert(tb_c_out = 1 and tb_z_flag = '0') report "SLT Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLT Testcase 2
	tb_oper <= ALU_INSTR_SLT;
	tb_a_in <= x"0FFFFFFF";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SLT Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SLTU Testcase 1
	--SLTU Testcase 2
	--SRA Testcase 1
	--SRA Testcase 2
	--SRL Testcase 1
	--SRL Testcase 2
	--SUB Testcase 1
	tb_oper <= ALU_INSTR_SUB;
	tb_a_in <= x"00000010";
	tb_b_in <= x"00000001";
	wait on tb_z_flag;
	assert(tb_c_out = 16#F# and tb_z_flag = '0') report "SUB Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--SUB Testcase 2
	tb_oper <= ALU_INSTR_SUB;
	tb_a_in <= x"F0F0F0F0";
	tb_b_in <= x"F0F0F0F0";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "SUB Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--XOR Testcase 1
	tb_oper <= ALU_INSTR_XOR;
	tb_a_in <= x"FFFFFFFF";
	tb_b_in <= x"F0F0F0F0";
	wait on tb_z_flag;
	assert(tb_c_out = 16#0F0F0F0F# and tb_z_flag = '0') report "XOR Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--XOR Testcase 2
	tb_oper <= ALU_INSTR_XOR;
	tb_a_in <= x"11111111";
	tb_b_in <= x"11111111";
	wait on tb_z_flag;
	assert(tb_c_out = 0 and tb_z_flag = '1') report "XOR Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--ZERO Testcase
	tb_oper <= ALU_INSTR_ZERO;
	tb_a_in <= x"FFFF0000";
	tb_b_in <= x"0000FFFF";
	assert(tb_c_out = 0 and tb_z_flag = '1') report "Default Testcase failed" severity failure;
	wait for CLOCK_PERIOD;
	wait;
end process test;

end architecture behaviour;
