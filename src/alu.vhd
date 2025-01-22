library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.cpu_types.all;

entity alu is
port(
	instr	: in  ALU_INSTR_ENUM;
	a_in	: in  std_logic_vector(31 downto 0);
	b_in	: in  std_logic_vector(31 downto 0);
	c_out	: out std_logic_vector(31 downto 0);
	z_flag	: out std_logic
);
end entity alu;

architecture behaviour of alu is
begin
	calculate: process(instr, a_in, b_in)
	variable output : std_logic_vector(31 downto 0) := x"00000000";
	variable zero : std_logic := '0';
	begin
		case instr is
			--ADD
			when ALU_INSTR_ADD =>
				output := std_logic_vector(signed(a_in) + signed(b_in));
			--AND
			when ALU_INSTR_AND =>
				output := a_in and b_in;
			--OR
			when ALU_INSTR_OR =>
				output := a_in or b_in;
			--SLL
			when ALU_INSTR_SLL =>
				output := std_logic_vector(shift_left(unsigned(a_in), to_integer(unsigned(b_in(4 downto 0)))));
			--SLT
			when ALU_INSTR_SLT =>
				if(signed(a_in) < signed(b_in)) then
					output := x"00000001";
				else
					output := x"00000000";
				end if;
			--SLTU
			when ALU_INSTR_SLTU =>
				if(unsigned(a_in) < unsigned(b_in)) then
					output := x"00000001";
				else
					output := x"00000000";
				end if;
			--SRA
			when ALU_INSTR_SRA =>
				output := std_logic_vector(shift_right(signed(a_in), to_integer(unsigned(b_in(4 downto 0)))));
			--SRL
			when ALU_INSTR_SRL =>
				output := std_logic_vector(shift_right(unsigned(a_in), to_integer(unsigned(b_in(4 downto 0)))));
			--SUB
			when ALU_INSTR_SUB =>
				output := a_in - b_in;
			--XOR
			when ALU_INSTR_XOR =>
				output := a_in xor b_in;
			--default
			when others =>
				output := x"00000000";
		end case;

		if (output = 0) then
			zero := '1';
		else
			zero := '0';
		end if;

	c_out <= output;
	z_flag <= zero;
	end process calculate;


end architecture behaviour;
