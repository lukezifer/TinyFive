library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_imm_gen is
end tb_imm_gen;

architecture behaviour of tb_imm_gen is
	component imm_gen is
		port(
			instr_in : in std_logic_vector(31 downto 0);
			immediate_out : out std_logic_vector(63 downto 0)
		);
	end component imm_gen;

	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_instr_in : std_logic_vector(31 downto 0);
	signal tb_immediate_out : std_logic_vector(63 downto 0);
	signal tb_result : signed(63 downto 0);

begin
dut: imm_gen
port map(
	instr_in => tb_instr_in,
	immediate_out => tb_immediate_out
);

tb_result <= signed(tb_immediate_out);

test: process
begin
	--init instruction
	--bne x10, x11, 2000 B-Type
	tb_instr_in <= "01111100101101010001100001100011";
	wait for CLOCK_PERIOD;
	assert(tb_result = 1000) report "Immediate B-Type Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--bne x10, x11, -100 B-Type
	tb_instr_in <= "11111000101101010001111011100011";
	--wait on tb_result;
	wait for CLOCK_PERIOD;
	assert(tb_result = -50) report "Immediate B-Type Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--addi x1, x2, 100 I-Type
	tb_instr_in <= "00000110010000001000000100010011";
	wait for CLOCK_PERIOD;
	assert(tb_result = 100) report "Immediate I-Type Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--addi x1, x2, -42 I-Type
	tb_instr_in <= "11111101011000001000000100010011";
	wait for CLOCK_PERIOD;
	assert(tb_result = -42) report "Immediate I-Type Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--sw x1, x0F(x2)
	tb_instr_in <= "00000000001000001001011110100011";
	wait for CLOCK_PERIOD;
	assert(tb_result = 15) report "Immediate S-Type Testcase 1 failed" severity failure;
	wait for CLOCK_PERIOD;
	--sw x1, -x0F(x2)
	tb_instr_in <= "11111110001000001001100010100011";
	wait for CLOCK_PERIOD;
	assert(tb_result = -15) report "Immediate S-Type Testcase 2 failed" severity failure;
	wait for CLOCK_PERIOD;
	--add x1, x2, x3 R-Type
	tb_instr_in <= "00000000001100010000000010110011";
	wait for CLOCK_PERIOD;
	assert(tb_result = 0) report "Immediate R-Type Testcase 1 failed" severity failure;
	wait;
end process test;
end architecture behaviour;

