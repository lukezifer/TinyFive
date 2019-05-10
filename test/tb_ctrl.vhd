library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_ctrl is
end entity tb_ctrl;

architecture behaviour of tb_ctrl is
	component ctrl is
		port(
			opcode : in std_logic_vector(6 downto 0);
			reg_dst : out std_logic;
			branch : out std_logic;
			mem_read : out std_logic;
			mem_to_reg : out std_logic;
			alu_op : out std_logic_vector(1 downto 0);
			mem_write : out std_logic;
			alu_src : out std_logic;
			reg_write : out std_logic
			);
	end component;

	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_opcode	: std_logic_vector(6 downto 0);
	signal tb_reg_dst	: std_logic;
	signal tb_branch	: std_logic;
	signal tb_mem_read	: std_logic;
	signal tb_mem_to_reg: std_logic;
	signal tb_alu_op	: std_logic_vector(1 downto 0);
	signal tb_mem_write	: std_logic;
	signal tb_reg_write	: std_logic;

begin
dut: ctrl
port map(
	opcode => tb_opcode,
	reg_dst => tb_reg_dst,
	branch => tb_branch,
	mem_read => tb_mem_read,
	mem_to_reg => tb_mem_to_reg,
	alu_op => tb_alu_op,
	mem_write => tb_mem_write,
	reg_write => tb_reg_write
);

test: process
begin
	--initialization
	tb_opcode <= "0110011";
	wait;
end process test;

end architecture behaviour;
