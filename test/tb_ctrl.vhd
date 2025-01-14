library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.types.all;

library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.run_pkg.all;

entity tb_ctrl is
	generic (runner_cfg: string);
end entity tb_ctrl;

architecture behaviour of tb_ctrl is
	component ctrl is
		port(
			opcode : in std_logic_vector(6 downto 0);
			branch : out std_logic;
			imm_in : out std_logic;
			jump : out std_logic;
			mem_read : out std_logic;
			mem_to_reg : out std_logic;
			alu_op : out ALU_OP_ENUM;
			mem_write : out std_logic;
			alu_src : out std_logic;
			reg_write : out std_logic;
			pc_imm : out std_logic
			);
	end component;

	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_clk		: std_logic;
	signal tb_opcode	: std_logic_vector(6 downto 0);
	signal tb_branch	: std_logic;
	signal tb_imm_in	: std_logic;
	signal tb_jump		: std_logic;
	signal tb_mem_read	: std_logic;
	signal tb_mem_to_reg: std_logic;
	signal tb_alu_op	: ALU_OP_ENUM;
	signal tb_mem_write	: std_logic;
	signal tb_alu_src	: std_logic;
	signal tb_reg_write	: std_logic;
	signal tb_pc_imm	: std_logic;

begin
dut: ctrl
port map(
	opcode => tb_opcode,
	branch => tb_branch,
	jump => tb_jump,
	imm_in => tb_imm_in,
	mem_read => tb_mem_read,
	mem_to_reg => tb_mem_to_reg,
	alu_op => tb_alu_op,
	mem_write => tb_mem_write,
	alu_src => tb_alu_src,
	reg_write => tb_reg_write,
	pc_imm => tb_pc_imm
);

clock: process
begin
	tb_clk <= '1';
	wait for CLOCK_PERIOD/2;
	tb_clk <= '0';
	wait for CLOCK_PERIOD/2;
end process clock;

test_runner: process
begin
	test_runner_setup(runner, runner_cfg);
	while test_suite loop
		--initialization
		tb_opcode <= "1111111";
		wait for CLOCK_PERIOD;

		if run("R-Type") then
		--R-Type
			tb_opcode <= "0110011";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '0');
			check_match(tb_mem_to_reg, '0');
			check_match(tb_reg_write, '1');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '0');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '0');
			check(tb_alu_op = ALU_OP_R);
			check_match(tb_pc_imm, '0');

		elsif run("I-Type") then
		--I-Type
			tb_opcode <= "0010011";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '1');
			check_match(tb_mem_to_reg, '0');
			check_match(tb_reg_write, '1');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '0');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '0');
			check(tb_alu_op = ALU_OP_I);
			check_match(tb_pc_imm, '0');

		elsif run("B-Type") then
		--B-Type
			tb_opcode <= "1100011";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '0');
			check(tb_mem_to_reg = '0' or tb_mem_to_reg = '1');
			check_match(tb_reg_write, '0');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '1');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '0');
			check(tb_alu_op = ALU_OP_B);
			check_match(tb_pc_imm, '0');

		elsif run("S-Type") then
		--S-Type
			tb_opcode <= "0100011";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '1');
			check(tb_mem_to_reg = '0' or tb_mem_to_reg = '1');
			check_match(tb_reg_write, '0');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '1');
			check_match(tb_branch, '0');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '0');
			check(tb_alu_op = ALU_OP_S);
			check_match(tb_pc_imm, '0');

		elsif run("J-Type") then
		--J-Type
			tb_opcode <= "1101111";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '0');
			check_match(tb_mem_to_reg, '0');
			check_match(tb_reg_write, '1');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '0');
			check_match(tb_jump, '1');
			check_match(tb_imm_in, '0');
			check(tb_alu_op = ALU_OP_R);
			check_match(tb_pc_imm, '0');

		elsif run("U-Type 1") then
		--U-Type lui
			tb_opcode <= "0110111";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '0');
			check_match(tb_mem_to_reg, '0');
			check_match(tb_reg_write, '1');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '0');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '1');
			check(tb_alu_op = ALU_OP_R);
			check_match(tb_pc_imm, '0');

		elsif run("U-Type 2") then
		--U-Type auipc
			tb_opcode <= "0010111";
			wait for CLOCK_PERIOD;

			check_match(tb_alu_src, '0');
			check_match(tb_mem_to_reg, '0');
			check_match(tb_reg_write, '1');
			check_match(tb_mem_read, '0');
			check_match(tb_mem_write, '0');
			check_match(tb_branch, '0');
			check_match(tb_jump, '0');
			check_match(tb_imm_in, '1');
			check(tb_alu_op = ALU_OP_U);
			check_match(tb_pc_imm, '1');

		end if;

	end loop;

test_runner_cleanup(runner);

end process test_runner;

end architecture behaviour;
