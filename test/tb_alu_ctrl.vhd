library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.cpu_types.all;

library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.run_pkg.all;

entity tb_alu_ctrl is
	generic (runner_cfg : string);
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

test_runner: process
begin
	test_runner_setup(runner, runner_cfg);

	tb_alu_op <= ALU_OP_S;
	-- nop
	tb_instr_in <= b"00000000000_00000_000_00000_00110111";

	while test_suite loop

		if run("R-Type") then
		-- R-Type
			tb_alu_op <= ALU_OP_R;
			-- funct7 - rs2 - rs1 - funct3 - rd - opcode
			wait for CLOCK_PERIOD;
			--add 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_000_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_ADD, "R-Type ADD failed");

			--sub 10, 1, 2
			tb_instr_in <= b"0100000_00010_00001_000_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SUB, "R-Type SUB failed");

			--sll 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_001_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLL, "R-Type SLL failed");

			--slt 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_010_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLT, "R-Type SLT failed");

			--sltu 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_011_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLTU, "R-Type SLTU failed");

			--xor 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_100_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_XOR, "R-Type XOR failed");

			--srl 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_101_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SRL, "R-Type SRL failed");

			--sra 10, 1, 2
			tb_instr_in <= b"0100000_00010_00001_101_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SRA, "R-Type SRA failed");

			--or 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_110_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_OR, "R-Type OR failed");

			--and 10, 1, 2
			tb_instr_in <= b"0000000_00010_00001_111_01010_0110011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_AND, "R-Type AND failed");

		elsif run("I-Type") then
			--I-Type
			tb_alu_op <= ALU_OP_I;
			-- immediate - rs1 - funct3 - rd - opcode
			wait for CLOCK_PERIOD;
			--addi 2, 1, 10
			tb_instr_in <= b"000000001010_00001_000_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_ADD, "I-Type ADDI failed");

			--andi 2, 1, 10
			tb_instr_in <= b"000000001010_00001_111_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_AND, "I-Type ANDI failed");

			--ori 2, 1, 10
			tb_instr_in <= b"000000001010_00001_110_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_OR, "I-Type ORI failed");

			--slti 2, 1, 10
			tb_instr_in <= b"000000001010_00001_010_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLT, "I-Type SLTI failed");

			--sltiu 2, 1, 10
			tb_instr_in <= b"000000001010_00001_011_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLTU, "I-Type SLTIU failed");

			--xori 2, 1, 10
			tb_instr_in <= b"000000001010_00001_100_00010_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_XOR, "I-Type XORI failed");

			-- funct7 - shamt - rs1 - funct3 - rd - opcode
			--slli 2, 1, 10
			tb_instr_in <= b"0000000_01010_00001_001_00001_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SLL, "I-Type SLLI failed");

			--srli 2, 1, 10
			tb_instr_in <= b"0000000_01010_00001_101_00001_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SRL, "I-Type SRLI failed");

			--srai 2, 1, 10
			tb_instr_in <= b"0100000_01010_00001_101_00001_0010011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_SRA, "I-Type SRAI failed");

		elsif run("S-Type") then
			--S-Type
			tb_alu_op <= ALU_OP_S;
			-- immediate - rs2 - rs1 - funct3 - immediate - opcode
			wait for CLOCK_PERIOD;
			--sw 2, 10(1)
			tb_instr_in <= b"0000000_00010_00001_010_01010_0100011";
			wait for CLOCK_PERIOD;
			check(tb_alu_instr = ALU_INSTR_ADD, "S-Type failed");

		elsif run("U-Type") then
			--U-Type
			tb_alu_op <= ALU_OP_U;
			-- immediate - rd - opcode
			wait for CLOCK_PERIOD;
			--auipc
			tb_instr_in <= b"00000000000000000001_00001_0010111";
			check(tb_alu_instr = ALU_INSTR_ADD, "U-Type failed");
		end if;

	end loop;

	test_runner_cleanup(runner);

end process test_runner;

end architecture;
