library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_branch_cmp is
end entity tb_branch_cmp;

architecture behaviour of tb_branch_cmp is
	component branch_cmp is
		port(
			alu_op : in std_logic_vector(1 downto 0);
			instr_in : in std_logic_vector(31 downto 0);
			rs1_data : in std_logic_vector(31 downto 0);
			rs2_data : in std_logic_vector(31 downto 0);
			branch : out std_logic
		);
	end component branch_cmp;
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_alu_op : std_logic_vector(1 downto 0);
	signal tb_instr_in : std_logic_vector(31 downto 0);
	signal tb_rs1_data : std_logic_vector(31 downto 0);
	signal tb_rs2_data : std_logic_vector(31 downto 0);
	signal tb_branch : std_logic;

begin
dut: branch_cmp
port map(
	alu_op => tb_alu_op,
	instr_in => tb_instr_in,
	rs1_data => tb_rs1_data,
	rs2_data => tb_rs2_data,
	branch => tb_branch
	);

test: process
begin
	--initialization
	tb_alu_op <= "00";
	--nop
	tb_instr_in <= "00000000000000000000000000110111";
	tb_rs1_data <= x"00000000";
	tb_rs2_data <= x"00000000";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("Default Testcase failed") severity failure;
	tb_alu_op <= "01";
	--beq 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010000000001100011";
	tb_rs1_data <= x"00000000";
	tb_rs2_data <= x"00000000";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BEQ Testcase 1 failed") severity failure;
	tb_rs1_data <= x"00000010";
	tb_rs2_data <= x"00000001";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BEQ Testcase 2 failed") severity failure;
	--bne 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010001000001100011";
	tb_rs1_data <= x"00000010";
	tb_rs2_data <= x"00000001";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BNE Testcase 1 failed") severity failure;
	tb_rs1_data <= x"00000010";
	tb_rs2_data <= x"00000010";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BNE Testcase 2 failed") severity failure;
	--blt 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010100000001100011";
	tb_rs1_data <= x"F0000001";
	tb_rs2_data <= x"00000001";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BLT Testcase 1 failed") severity failure;
	tb_rs1_data <= x"FFFFFFF2";
	tb_rs2_data <= x"FFFFFFF1";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BLT Testcase 2 failed") severity failure;
	--bge 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010101000001100011";
	tb_rs1_data <= x"00000100";
	tb_rs2_data <= x"00000011";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BGE Testcase 1 failed") severity failure;
	tb_rs1_data <= x"00000010";
	tb_rs2_data <= x"00000101";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BGE Testcase 2 failed") severity failure;
	--bltu 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010110000001100011";
	tb_rs1_data <= x"00000001";
	tb_rs2_data <= x"F0000001";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BLTU Testcase 1 failed") severity failure;
	tb_rs1_data <= x"FFFFFFF2";
	tb_rs2_data <= x"FFFFFFF1";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BLTU Testcase 2 failed") severity failure;
	--bge 0x2, 0x1, 0x0
	tb_instr_in <= "00000000000100010111000001100011";
	tb_rs1_data <= x"00000100";
	tb_rs2_data <= x"00000011";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '1') report ("BGEU Testcase 1 failed") severity failure;
	tb_rs1_data <= x"00000010";
	tb_rs2_data <= x"00000101";
	wait for CLOCK_PERIOD;
	assert (tb_branch = '0') report ("BGEU Testcase 2 failed") severity failure;

end process test;
end architecture behaviour;

