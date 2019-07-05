library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.types.all;

entity tb_alu_ctrl is
end entity tb_alu_ctrl;

architecture behaviour of tb_alu_ctrl is
	component alu_ctrl is
		port(
			alu_op : in ALU_OP_ENUM;
			instr_in : in std_logic_vector(31 downto 0);
			alu_instr : out ALU_INSTR_ENUM
		);
	end component alu_ctrl;

	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_alu_op	: ALU_OP_ENUM;
	signal tb_instr_in	: std_logic_vector(31 downto 0);
	signal tb_alu_instr	: ALU_INSTR_ENUM;

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
	tb_alu_op <= ALU_OP_S;
	--nop
	tb_instr_in <= b"00000000000_00000_000_00000_00110111";
	wait for CLOCK_PERIOD;
	--R-Type
	tb_alu_op <= ALU_OP_R;
	-- funct7 - rs2 - rs1 - funct3 - rd - opcode
	wait for CLOCK_PERIOD;
	--add 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_000_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_ADD) report "R-Type ADD failed" severity failure;
	--sub 10, 1, 2
	tb_instr_in <= b"0100000_00010_00001_000_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SUB) report "R-Type SUB failed" severity failure;
	--sll 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_001_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLL) report "R-Type SLL failed" severity failure;
	--slt 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_010_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLT) report "R-Type SLT failed" severity failure;
	--sltu 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_011_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLTU) report "R-Type SLTU failed" severity failure;
	--xor 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_100_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_XOR) report "R-Type XOR failed" severity failure;
	--srl 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_101_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SRL) report "R-Type SRL failed" severity failure;
	--sra 10, 1, 2
	tb_instr_in <= b"0100000_00010_00001_101_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SRA) report "R-Type SRA failed" severity failure;
	--or 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_110_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_OR) report "R-Type OR failed" severity failure;
	--and 10, 1, 2
	tb_instr_in <= b"0000000_00010_00001_111_01010_0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_AND) report "R-Type AND failed" severity failure;
	wait for CLOCK_PERIOD;

	--I-Type
	tb_alu_op <= ALU_OP_I;
	-- immediate - rs1 - funct3 - rd - opcode
	wait for CLOCK_PERIOD;
	--addi 2, 1, 10
	tb_instr_in <= b"000000001010_00001_000_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_ADD) report "I-Type ADDI failed" severity failure;
	wait for CLOCK_PERIOD;
	--andi 2, 1, 10
	tb_instr_in <= b"000000001010_00001_111_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_AND) report "I-Type ANDI failed" severity failure;
	wait for CLOCK_PERIOD;
	--ori 2, 1, 10
	tb_instr_in <= b"000000001010_00001_110_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_OR) report "I-Type ORI failed" severity failure;
	wait for CLOCK_PERIOD;
	--slti 2, 1, 10
	tb_instr_in <= b"000000001010_00001_010_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLT) report "I-Type SLTI failed" severity failure;
	wait for CLOCK_PERIOD;
	--sltiu 2, 1, 10
	tb_instr_in <= b"000000001010_00001_011_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLTU) report "I-Type SLTIU failed" severity failure;
	wait for CLOCK_PERIOD;
	--xori 2, 1, 10
	tb_instr_in <= b"000000001010_00001_100_00010_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_XOR) report "I-Type XORI failed" severity failure;
	wait for CLOCK_PERIOD;
	-- funct7 - shamt - rs1 - funct3 - rd - opcode
	--slli 2, 1, 10
	tb_instr_in <= b"0000000_01010_00001_001_00001_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SLL) report "I-Type SLLI failed" severity failure;
	wait for CLOCK_PERIOD;
	--srli 2, 1, 10
	tb_instr_in <= b"0000000_01010_00001_101_00001_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SRL) report "I-Type SRLI failed" severity failure;
	wait for CLOCK_PERIOD;
	--srai 2, 1, 10
	tb_instr_in <= b"0100000_01010_00001_101_00001_0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_SRA) report "I-Type SRAI failed" severity failure;
	wait for CLOCK_PERIOD;

	--S-Type
	tb_alu_op <= ALU_OP_S;
	wait for CLOCK_PERIOD;
	--sw x1, -x0F(x2)
	tb_instr_in <= "11111110001000001001100010100011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_instr = ALU_INSTR_ADD) report ("S-Type failed") severity failure;
	wait;

end process test;

end architecture;
