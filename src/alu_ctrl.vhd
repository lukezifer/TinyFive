library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_ctrl is
port(
	alu_op	 : in  std_logic_vector(1 downto 0);
	instr_in : in  std_logic_vector(31 downto 0);
	alu_instr: out std_logic_vector(3 downto 0)
);
end entity alu_ctrl;

architecture behaviour of alu_ctrl is
	signal funct3 : std_logic_vector(2 downto 0);
	signal funct7 : std_logic;
begin
	funct3 <= instr_in(14 downto 12);
	funct7 <= instr_in(30);

	control: process(alu_op, funct3, funct7)
	begin
		case alu_op is
		--R-Type
			when "10" =>
				--ADD
				if funct3 = "000" and funct7 = '0' then
					alu_instr <= "0010";
				--SUB
				elsif funct3 = "000" and funct7 = '1' then
					alu_instr <= "0110";
				--SLT
				elsif funct3 = "010" and funct7 = '0' then
					alu_instr <= "0111";
				--OR
				elsif funct3 = "110" and funct7 = '0' then
					alu_instr <= "0001";
				--AND
				elsif funct3 = "111" and funct7 = '0' then
					alu_instr <= "0000";
				--SLT
				elsif funct3 = "010" and funct7 = '0' then
					alu_instr <= "1111"; -- slt alu instr
				--SLTU
				elsif funct3 = "011" and funct7 = '0' then
					alu_instr <= "1111"; --sltu alu instr
				--SLL
				elsif funct3 = "001" and funct7 = '0' then
					alu_instr <= "1111"; --sll alu instr
				--SRL
				elsif funct3 = "101" and funct7 = '0' then
					alu_instr <= "1111"; --srl alu instr
				--SRA
				elsif funct3 = "101" and funct7 = '1' then
					alu_instr <= "1111"; --sra alu instr
				else
					alu_instr <= "1111";
				end if;
		--I-Type
			when "00" =>
				--addi, lb
				if funct3 = "000" then
					alu_instr <= "0010";
				--slti
				elsif funct3 = "010" then
					alu_instr <= "0111";
				--ori
				elsif funct3 = "110" then
					alu_instr <= "0001";
				--andi
				elsif funct3 = "111" then
					alu_instr <= "0000";
				else
					alu_instr <= "1111";
				end if;
		--S-Type
			when "11" =>
				alu_instr <= "0010";
		--default
			when others =>
				alu_instr <= "1111";
		end case;
	end process control;
end architecture behaviour;
