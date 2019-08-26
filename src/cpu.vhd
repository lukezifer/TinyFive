library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.types.all;

entity cpu is
port(
	clk: in std_logic;
	rst: in std_logic
);
end cpu;

architecture behaviour of cpu is

	component pc is
		port (
			clk : in std_logic;
			rst : in std_logic;
			ld : in std_logic;
			en : in std_logic;
			data_in : in std_logic_vector(31 downto 0);
			cnt : out std_logic_vector(31 downto 0)
	);
	end component pc;

	component rom is
		generic (
			size : integer
		);
		port (
			clk : in std_logic;
			addr : in std_logic_vector(7 downto 0);
			dout : out std_logic_vector(31 downto 0)
		);
	end component rom;

	component reg is
		port (
			clk : in std_logic;
			rst : in std_logic;
			r_addr1 : in std_logic_vector(4 downto 0);
			r_addr2 : in std_logic_vector(4 downto 0);
			r_data1 : out std_logic_vector(31 downto 0);
			r_data2 : out std_logic_vector(31 downto 0);
			w_addr : in std_logic_vector(4 downto 0);
			w_data : in std_logic_vector(31 downto 0);
			w_enable : in std_logic
		);
	end component reg;

	component ctrl is
		port (
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
	end component ctrl;

	component alu_ctrl is
		port (
			alu_op : in ALU_OP_ENUM;
			instr_in : in std_logic_vector(31 downto 0);
			alu_instr : out ALU_INSTR_ENUM
	);
	end component alu_ctrl;

	component alu is
		port (
			instr : in ALU_INSTR_ENUM;
			a_in : in std_logic_vector(31 downto 0);
			b_in : in std_logic_vector(31 downto 0);
			c_out : out std_logic_vector(31 downto 0);
			z_flag : out std_logic
		);
	end component alu;

	component ram is
		generic (
			size : integer
		);
		port (
			clk : in std_logic;
			addr : in std_logic_vector(7 downto 0);
			r_en : in std_logic;
			w_en : in std_logic;
			funct3 : in std_logic_vector(2 downto 0);
			din : in std_logic_vector(31 downto 0);
			dout : out std_logic_vector(31 downto 0)
		);
	end component ram;

	component imm_gen is
		port (
			instr_in : in std_logic_vector(31 downto 0);
			immediate_out : out std_logic_vector(63 downto 0)
		);
	end component imm_gen;

	component branch_cmp is
		port (
			alu_op : in ALU_OP_ENUM;
			instr_in : in std_logic_vector(31 downto 0);
			rs1_data : in std_logic_vector(31 downto 0);
			rs2_data : in std_logic_vector(31 downto 0);
			branch : out std_logic
		);
	end component branch_cmp;

	signal pc_en : std_logic;
	signal pc_ld : std_logic;
	signal pc_in : std_logic_vector(31 downto 0);
	signal pc_out: std_logic_vector(31 downto 0);
	signal rom_instr : std_logic_vector(31 downto 0);
	signal reg_r_data1 : std_logic_vector(31 downto 0);
	signal reg_r_data2 : std_logic_vector(31 downto 0);
	signal ctrl_branch : std_logic;
	signal ctrl_imm_in : std_logic;
	signal ctrl_jump : std_logic;
	signal ctrl_mem_read : std_logic;
	signal ctrl_mem_to_reg : std_logic;
	signal ctrl_mem_write : std_logic;
	signal ctrl_alu_src : std_logic;
	signal ctrl_reg_write : std_logic;
	signal ctrl_alu_op : ALU_OP_ENUM;
	signal ctrl_pc_imm : std_logic;
	signal alu_ctrl_alu_instr : ALU_INSTR_ENUM;
	signal alu_out : std_logic_vector(31 downto 0);
	signal alu_z_flag : std_logic;
	signal ram_out : std_logic_vector(31 downto 0);
	signal imm_gen_input : std_logic_vector(31 downto 0);
	signal imm_gen_output : std_logic_vector(63 downto 0);
	signal branch_cmp_branch : std_logic;
	signal cpu_alu_src_data : std_logic_vector(31 downto 0);
	signal cpu_alu_mem_out : std_logic_vector (31 downto 0);
	signal cpu_branch_immediate : std_logic_vector (63 downto 0);
begin

program_counter: pc
port map(
	clk => clk,
	rst => rst,
	ld  => pc_ld,
	en  => pc_en,
	data_in => pc_in,
	cnt => pc_out
	);

read_only_memory: rom
generic map (
	size => 256
	)
port map(
	clk => clk,
	addr => pc_out(9 downto 2),
	dout => rom_instr
	);

registers: reg
port map(
	clk => clk,
	rst => rst,
	r_addr1 => rom_instr(19 downto 15),
	r_addr2 => rom_instr(24 downto 20),
	r_data1 => reg_r_data1,
	r_data2 => reg_r_data2,
	w_addr => rom_instr(11 downto 7),
	w_data => cpu_alu_mem_out,
	w_enable => ctrl_reg_write
	);

control: ctrl
port map(
	opcode => rom_instr(6 downto 0),
	branch => ctrl_branch,
	imm_in => ctrl_imm_in,
	jump => ctrl_jump,
	mem_read => ctrl_mem_read,
	mem_to_reg => ctrl_mem_to_reg,
	alu_op => ctrl_alu_op,
	mem_write => ctrl_mem_write,
	alu_src => ctrl_alu_src,
	reg_write => ctrl_reg_write,
	pc_imm => ctrl_pc_imm
	);

alu_control: alu_ctrl
port map(
	alu_op => ctrl_alu_op,
	instr_in => rom_instr,
	alu_instr => alu_ctrl_alu_instr
	);

arithmetic_logic_unit: alu
port map(
	instr => alu_ctrl_alu_instr,
	a_in => reg_r_data1,
	b_in => cpu_alu_src_data,
	c_out => alu_out,
	z_flag => alu_z_flag
	);

random_access_memory: ram
generic map(
	size => 256
)
port map(
	clk => clk,
	addr => alu_out(7 downto 0),
	r_en => ctrl_mem_read,
	w_en => ctrl_mem_write,
	funct3 => rom_instr(14 downto 12),
	din => reg_r_data2,
	dout => ram_out
	);

immedaite_generate: imm_gen
port map(
	instr_in => imm_gen_input,
	immediate_out => imm_gen_output
	);

branch_compare: branch_cmp
port map(
	alu_op => ctrl_alu_op,
	instr_in => rom_instr(31 downto 0),
	rs1_data => reg_r_data1,
	rs2_data => reg_r_data2,
	branch => branch_cmp_branch
	);

cpu_branch_immediate <= std_logic_vector(shift_left(unsigned(imm_gen_output), 1));
pc_in <= std_logic_vector(signed(pc_out) + signed(cpu_branch_immediate(31 downto 0)));

alu_src : process (ctrl_alu_src, reg_r_data2, imm_gen_output)
begin
	if(ctrl_alu_src = '0') then
		cpu_alu_src_data <= reg_r_data2;
	else
		cpu_alu_src_data <= imm_gen_output(31 downto 0);
	end if;
end process alu_src;

reg_write_src: process(ctrl_mem_to_reg, ctrl_jump, ram_out, alu_out, pc_out)
begin
	if(ctrl_jump = '1') then
		cpu_alu_mem_out <= std_logic_vector(unsigned(pc_out) + 4);
	elsif(ctrl_imm_in = '1') then
		cpu_alu_mem_out <= imm_gen_output(31 downto 0);
	else
		if(ctrl_mem_to_reg = '1') then
			cpu_alu_mem_out <= ram_out;
		else
			cpu_alu_mem_out <= alu_out;
		end if;
	end if;
end process reg_write_src;

pc_src: process(ctrl_branch, branch_cmp_branch, ctrl_jump)
begin
	if((ctrl_branch = '1' and branch_cmp_branch = '1') or ctrl_jump = '1') then
		pc_en <= '0';
		pc_ld <= '1';
	else
		pc_en <= '1';
		pc_ld <= '0';
	end if;
end process pc_src;

imm_gen_src: process(ctrl_pc_imm)
begin
	if(ctrl_pc_imm = '1') then
		imm_gen_input <= pc_out;
	else
		imm_gen_input <= rom_instr;
	end if;
end process imm_gen_src;

end architecture;
