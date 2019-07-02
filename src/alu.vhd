library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.types.all;

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
	signal output : std_logic_vector(31 downto 0);
begin
	calculate: process(instr, a_in, b_in)
	begin
		case instr is
			--AND
			when ALU_INSTR_AND =>
				output <= a_in and b_in;
			--OR
			when ALU_INSTR_OR =>
				output <= a_in or b_in;
			--XOR
			when ALU_INSTR_XOR =>
				output <= a_in xor b_in;
			--ADD
			when ALU_INSTR_ADD =>
				output <= std_logic_vector(signed(a_in) + signed(b_in));
			--SUB
			when ALU_INSTR_SUB =>
				output <= a_in - b_in;
			--SLT
			when ALU_INSTR_SLT =>
				if(signed(a_in) < signed(b_in)) then
					output <= x"00000001";
				else
					output <= x"00000000";
				end if;
			--default
			when others =>
				output <= x"00000000";
		end case;

	end process calculate;

	zero: process(output)
	begin
		if (output = 0) then
			z_flag <= '1';
		else
			z_flag <= '0';
		end if;
	end process zero;

	c_out <= output;

end architecture behaviour;
