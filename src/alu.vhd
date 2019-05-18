library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
port(
	oper	: in  std_logic_vector(3 downto 0);
	a_in	: in  std_logic_vector(31 downto 0);
	b_in	: in  std_logic_vector(31 downto 0);
	c_out	: out std_logic_vector(31 downto 0);
	z_flag	: out std_logic
);
end entity alu;

architecture behaviour of alu is
	signal output : std_logic_vector(31 downto 0);
begin
	calculate: process(oper, a_in, b_in)
	begin
		case oper is
			--AND
			when "0000" =>
				output <= a_in and b_in;
			--OR
			when "0001" =>
				output <= a_in or b_in;
			--XOR
			when "0011" =>
				output <= a_in xor b_in;
			--ADD
			when "0010" =>
				output <= std_logic_vector(signed(a_in) + signed(b_in));
			--SUB
			when "0110" =>
				output <= a_in - b_in;
			--SLT
			when "0111" =>
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
