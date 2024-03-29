library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.types.all;

entity tb_ctrl is
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

test: process
begin
	--initialization
	tb_opcode <= "1111111";
	wait for CLOCK_PERIOD;
	--R-Type
	tb_opcode <= "0110011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '0') report " R-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0') report " R-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '1') report " R-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " R-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " R-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " R-Type branch failed" severity failure;
	assert (tb_jump = '0') report " R-Types jump failed" severity failure;
	assert (tb_imm_in = '0') report " R-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_R) report "R-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "R-Type pc_imm failed" severity failure;
	wait for CLOCK_PERIOD;
	--I-Type
	tb_opcode <= "0010011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '1') report " I-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0') report " I-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '1') report " I-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " I-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " I-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " I-Type branch failed" severity failure;
	assert (tb_jump = '0') report " I-Types jump failed" severity failure;
	assert (tb_imm_in = '0') report " I-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_I) report "I-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "I-Type pc_imm failed" severity failure;
	wait for CLOCK_PERIOD;
	--B-Type
	tb_opcode <= "1100011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '0') report " B-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0' or tb_mem_to_reg = '1') report " B-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '0') report " B-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " B-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " B-Type mem_write failed" severity failure;
	assert (tb_branch = '1') report " B-Type branch failed" severity failure;
	assert (tb_jump = '0') report " B-Types jump failed" severity failure;
	assert (tb_imm_in = '0') report " B-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_B) report "B-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "B-Type pc_imm failed" severity failure;
	wait for CLOCK_PERIOD;
	--S-Type
	tb_opcode <= "0100011";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '1') report " S-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0' or tb_mem_to_reg = '1') report " S-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '0') report " S-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " S-Type mem_read failed" severity failure;
	assert (tb_mem_write = '1') report " S-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " S-Type branch failed" severity failure;
	assert (tb_jump = '0') report " S-Types jump failed" severity failure;
	assert (tb_imm_in = '0') report " S-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_S) report "S-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "S-Type pc_imm failed" severity failure;
	wait for CLOCK_PERIOD;
	--J-Type
	tb_opcode <= "1101111";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '0') report " J-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0') report " J-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '1') report " J-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " J-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " J-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " J-Type branch failed" severity failure;
	assert (tb_jump = '1') report " J-Types jump failed" severity failure;
	assert (tb_imm_in = '0') report " J-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_R) report "J-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "J-Type pc_imm failed" severity failure;
	wait for CLOCK_PERIOD;
	--U-Type lui
	tb_opcode <= "0110111";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '0') report " U-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0') report " U-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '1') report " U-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " U-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " U-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " U-Type branch failed" severity failure;
	assert (tb_jump = '0') report " U-Types jump failed" severity failure;
	assert (tb_imm_in = '1') report " U-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_R) report "U-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '0') report "U-Type pc_imm failed" severity failure;
	--U-Type auipc
	tb_opcode <= "0010111";
	wait for CLOCK_PERIOD;
	assert (tb_alu_src = '0') report " U-Type alu_src failed" severity failure;
	assert (tb_mem_to_reg = '0') report " U-Type mem_to_reg failed" severity failure;
	assert (tb_reg_write = '1') report " U-Type reg_write failed" severity failure;
	assert (tb_mem_read = '0') report " U-Type mem_read failed" severity failure;
	assert (tb_mem_write = '0') report " U-Type mem_write failed" severity failure;
	assert (tb_branch = '0') report " U-Type branch failed" severity failure;
	assert (tb_jump = '0') report " U-Types jump failed" severity failure;
	assert (tb_imm_in = '1') report " U-Types imm_in failed" severity failure;
	assert (tb_alu_op = ALU_OP_U) report "U-Type alu_op failed" severity failure;
	assert (tb_pc_imm = '1') report "U-Type pc_imm failed" severity failure;

	wait;
end process test;

end architecture behaviour;
