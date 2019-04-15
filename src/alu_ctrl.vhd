library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_ctrl is
port(
	alu_op	 : in  std_logic_vector(1 downto 0);
	instr_in : in  std_logic_vector(5 downto 0);
	alu_instr: out std_logic_vector(3 downto 0)
);
end entity alu_ctrl;

architecture behaviour of alu_ctrl is
	signal output : std_logic_vector(31 downto 0);
begin
	control: process(alu_op, instr_in)
	begin
	end process control;

end architecture behaviour;
