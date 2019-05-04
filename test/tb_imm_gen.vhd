library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_imm_gen is
end tb_imm_gen;

architecture behaviour of tb_imm_gen is
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_instr_in : std_logic_vector(31 downto 0);
	signal tb_immediate_out : std_logic_vector(63 downto 0);
	signal tb_result : signed(63 downto 0);
begin
dut: entity work.imm_gen
port map(
	instr_in => tb_instr_in,
	immediate_out => tb_immediate_out
);

tb_result <= signed(tb_immediate_out);

test: process
begin
	--init instruction
	--bne x10, x11, 2000
	tb_instr_in <= "01111100101101010001100001100011";
	wait on tb_result;
	assert(tb_result = 1000) report "Immediate Testcase 1 failed" severity error;
	wait for CLOCK_PERIOD;
	--bne x10, x11, -50
	tb_instr_in <= "11111000101101010001111011100011";
	--wait on tb_result;
	wait for CLOCK_PERIOD;
	assert(tb_result = -50) report "Immediate Testcase 2 failed" severity error;
	wait;
end process test;
end architecture behaviour;

