library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ctrl is
port(
	opcode	: in	std_logic_vector(6 downto 0);
	branch	: out	std_logic;
	mem_read	: out	std_logic;
	mem_to_reg	: out	std_logic;
	alu_op	: out	std_logic_vector(1 downto 0);
	mem_write	: out std_logic;
	alu_src		: out std_logic;
	reg_write	: out std_logic
	);
end entity ctrl;

architecture behaviour of ctrl is
begin

	decode: process(opcode)
	begin
		case (opcode) is
			--R-Instruction 0110011
			when "0110011" =>
				branch <= '0';
				mem_read <= '0';
				mem_to_reg <= '0';
				alu_op <= "10";
				mem_write <= '0';
				alu_src <= '0';
				reg_write <= '1';
			--I-Instruction 0010011
			when "0010011" =>
				branch <= '0';
				mem_read <= '0';
				mem_to_reg <= '0';
				alu_op <= "00";
				mem_write <= '0';
				alu_src <= '1';
				reg_write <= '1';
			--B-Instruction 1100011
			when "1100011" =>
				branch <= '1';
				mem_read <= '0';
				mem_to_reg <= '0';
				alu_op <= "01";
				mem_write <= '0';
				alu_src <= '0';
				reg_write <= '0';
			--Others not implemented yet
			when others =>
				branch <= '0';
				mem_read <= '0';
				mem_to_reg <= '0';
				alu_op <= "10";
				mem_write <= '0';
				alu_src <= '0';
				reg_write <= '1';
		end case;
	end process decode;

end architecture behaviour;

