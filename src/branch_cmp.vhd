library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.types.all;

entity branch_cmp is
port(
	alu_op : in ALU_OP_ENUM;
	instr_in : in std_logic_vector(31 downto 0);
	rs1_data : in std_logic_vector(31 downto 0);
	rs2_data : in std_logic_vector(31 downto 0);
	branch : out std_logic
	);
end entity branch_cmp;

architecture behaviour of branch_cmp is
	signal funct3 : std_logic_vector(2 downto 0);
begin
	funct3 <= instr_in(14 downto 12);

	compare: process(alu_op, funct3, rs1_data, rs2_data)
	begin
		if alu_op = ALU_OP_B then
			case funct3 is
			--beq 000
				when "000" =>
					if rs1_data = rs2_data then
						branch <= '1';
					else
						branch <= '0';
					end if;
			--bne 001
				when "001" =>
					if rs1_data /= rs2_data then
						branch <= '1';
					else
						branch <= '0';
					end if;
			--blt 100
				when "100" =>
					if signed(rs1_data) < signed(rs2_data) then
						branch <= '1';
					else
						branch <= '0';
					end if;
			--bge 101
				when "101" =>
					if signed(rs1_data) >= signed(rs2_data) then
						branch <= '1';
					else
						branch <= '0';
					end if;
			--bltu 110
				when "110" =>
					if unsigned(rs1_data) < unsigned(rs2_data) then
						branch <= '1';
					else
						branch <= '0';
					end if;
			--bgeu 111
				when "111" =>
					if unsigned(rs1_data) >= unsigned(rs2_data) then
						branch <= '1';
					else
						branch <= '0';
					end if;
				when others =>
					branch <= '0';
			end case;
		else
			branch <= '0';
		end if;
	end process compare;
end architecture behaviour;
