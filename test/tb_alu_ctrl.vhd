library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_alu_ctrl is
end entity tb_alu_ctrl;

architecture behaviour of tb_alu_ctrl is
	component alu_ctrl is
		port(
			alu_op : in std_logic_vector(1 downto 0);
			instr_in : in std_logic_vector(31 downto 0);
			alu_instr : out std_logic_vector(3 downto 0)
		);
	end component alu_ctrl;

	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_alu_op	: std_logic_vector(1 downto 0);
	signal tb_instr_in	: std_logic_vector(31 downto 0);
	signal tb_alu_instr	: std_logic_vector(3 downto 0);

begin
dut: alu_ctrl
port map(
	alu_op => tb_alu_op,
	instr_in => tb_instr_in,
	alu_instr => tb_alu_instr
);

test: process
begin
	--initialization
	tb_alu_op <= "11";
	--nop
	tb_instr_in <= "00000000000000000000000000110111";
	wait for CLOCK_PERIOD;
	--R-Type
	tb_alu_op <= "10";
	--add 10, 1, 2
	tb_instr_in <= "00000000001000001000010100110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0010") report ("R-Type ADD failed") severity failure;
	--sub 10, 1, 2
	tb_instr_in <= "01000000001000001000010100110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0110") report ("R-Type SUB failed") severity failure;
	--slt 10, 1, 2
	tb_instr_in <= "00000000001000001010010100110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0111") report ("R-Type SLT failed") severity failure;
	--or 10, 1, 2
	tb_instr_in <= "00000000001000001110010100110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0001") report ("R-Type OR failed") severity failure;
	--and 10, 1, 2
	tb_instr_in <= "00000000001000001111010100110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0000") report ("R-Type AND failed") severity failure;
	wait for CLOCK_PERIOD;

	--I-Type
	--addi 2, 1, 10
	tb_instr_in <= "00000000101000001000000100010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0010") report ("I-Type ADDI failed") severity failure;
	wait for CLOCK_PERIOD;
	--andi 2, 1, 10
	tb_instr_in <= "00000000101000001111000100010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0000") report ("I-Type ANDI failed") severity failure;
	wait for CLOCK_PERIOD;
	--ori 2, 1, 10
	tb_instr_in <= "00000000101000001110000100010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0001") report ("I-Type ORI failed") severity failure;
	wait for CLOCK_PERIOD;
	--slti 2, 1, 10
	tb_instr_in <= "00000000101000001010000100010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = "0111") report ("I-Type SLTI failed") severity failure;
	wait for CLOCK_PERIOD;
	wait;

end process test;

end architecture;
