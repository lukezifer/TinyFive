library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package utils is
	function hex_len(N: std_logic_vector) return integer;
	function to_char(N: std_logic) return character;
	function to_string(N : std_logic_vector) return string;
	function to_hex_string(N: std_logic_vector) return string;
end package utils;

package body utils is

	function hex_len(N: std_logic_vector) return integer is
		variable result : integer := 0;
	begin
		if(N'length mod 4 = 0)
		then
			result := N'length / 4;
		else
			result := N'length / 4 + 1;
		end if;
		return result;
	end function hex_len;

	function to_char(N: std_logic) return character is
		variable c: character;
	begin
		case N is
			when 'U' => c := 'U';
			when 'X' => c := 'X';
			when '0' => c := '0';
			when '1' => c := '1';
			when 'Z' => c := 'Z';
			when 'W' => c := 'W';
			when 'L' => c := 'L';
			when 'H' => c := 'H';
			when others => c := '-';
		end case;
		return c;
	end function to_char;

	function to_string(N: std_logic_vector) return string is
		variable result : string (1 to N'length);
	begin
		for i in N'range loop
			result(N'length - i) := to_char(N(i));
		end loop;
		return result;
	end function to_string;

	function to_hex_string(N: std_logic_vector) return string is
		variable fourbits : std_logic_vector(3 downto 0);
		variable str_len : integer := hex_len(N);
		variable result : string(0 to str_len);
		variable lsb : integer := 0;
		variable msb : integer := 0;
		variable char : character;
	begin
		for idx in 0 to str_len loop 
			lsb := idx * 4;
			msb := idx * 4 + 3;
			if(msb >= N'length)
			then
				msb := N'length - 1;
				fourbits := std_logic_vector(resize(unsigned(N(msb downto lsb)), 4));
			else
				fourbits := N(msb downto lsb);
			end if;
			case fourbits is
				when "0000" => char := '0';
				when "0001" => char := '1';
				when "0010" => char := '2';
				when "0011" => char := '3';
				when "0100" => char := '4';
				when "0101" => char := '5';
				when "0110" => char := '6';
				when "0111" => char := '7';
				when "1000" => char := '8';
				when "1001" => char := '9';
				when "1010" => char := 'A';
				when "1011" => char := 'B';
				when "1100" => char := 'C';
				when "1101" => char := 'D';
				when "1110" => char := 'E';
				when "1111" => char := 'F';
				when others => char := '?';
			end case;
			result(str_len - idx) := char;
		end loop;
		return result;
	end function to_hex_string;

end utils;
