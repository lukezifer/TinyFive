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
begin
	control: process(alu_op, instr_in)
	begin
		case alu_op is
		--R-Type
			when "10" =>
				alu_instr <= "0010";
		--B-Type
			when "01" =>
				alu_instr <= "0110";
		--S-Type
			when "00" =>
				alu_instr <= "0010";
		--Avoid Latch
			when others =>
				alu_instr <= "1111";
		end case;
	end process control;
end architecture behaviour;
