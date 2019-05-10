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

test:process
begin

wait;

end process test;

end architecture;
