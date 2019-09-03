library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.types.all;

entity alu_ctrl is
port(
	alu_op	 : in  ALU_OP_ENUM;
	instr_in : in  std_logic_vector(31 downto 0);
	alu_instr: out ALU_INSTR_ENUM
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
			when ALU_OP_R =>
				--ADD
				if funct3 = "000" and funct7 = '0' then
					alu_instr <= ALU_INSTR_ADD;
				--SUB
				elsif funct3 = "000" and funct7 = '1' then
					alu_instr <= ALU_INSTR_SUB;
				--SLL
				elsif funct3 = "001" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SLL;
				--SLT
				elsif funct3 = "010" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SLT;
				--SLTU
				elsif funct3 = "011" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SLTU;
				--XOR
				elsif funct3 = "100" and funct7 = '0' then
					alu_instr <= ALU_INSTR_XOR;
				--SRL
				elsif funct3 = "101" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SRL;
				--SRA
				elsif funct3 = "101" and funct7 = '1' then
					alu_instr <= ALU_INSTR_SRA;
				--OR
				elsif funct3 = "110" and funct7 = '0' then
					alu_instr <= ALU_INSTR_OR;
				--AND
				elsif funct3 = "111" and funct7 = '0' then
					alu_instr <= ALU_INSTR_AND;
				else
					alu_instr <= ALU_INSTR_ZERO;
				end if;
		--I-Type
			when ALU_OP_I =>
				--ADDI, lb
				if funct3 = "000" then
					alu_instr <= ALU_INSTR_ADD;
				--SLLI
				elsif funct3 = "001" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SLL;
				--SLTI
				elsif funct3 = "010" then
					alu_instr <= ALU_INSTR_SLT;
				--SLTUI
				elsif funct3 = "011" then
					alu_instr <= ALU_INSTR_SLTU;
				--XORI
				elsif funct3 = "100" then
					alu_instr <= ALU_INSTR_XOR;
				--SRLI
				elsif funct3 = "101" and funct7 = '0' then
					alu_instr <= ALU_INSTR_SRL;
				--SRAI
				elsif funct3 = "101" and funct7 = '1' then
					alu_instr <= ALU_INSTR_SRA;
				--ORI
				elsif funct3 = "110" then
					alu_instr <= ALU_INSTR_OR;
				--ANDI
				elsif funct3 = "111" then
					alu_instr <= ALU_INSTR_AND;
				else
					alu_instr <= ALU_INSTR_ZERO;
				end if;
		--S-Type
			when ALU_OP_S =>
				alu_instr <= ALU_INSTR_ADD;
		--U-Type
			when ALU_OP_U =>
				alu_instr <= ALU_INSTR_ADD;
		--default
			when others =>
				alu_instr <= ALU_INSTR_ZERO;
		end case;
	end process control;
end architecture behaviour;
