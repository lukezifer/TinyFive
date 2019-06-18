library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package utils is
	function to_char(N: std_logic) return character;
	function to_string(N : std_logic_vector) return string;
	function to_hex_string(N: std_logic_vector) return string;
end package utils;

package body utils is

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
			result(i + 1) := to_char(N(i));
		end loop;
		return result;
	end function to_string;

	function to_hex_string(N: std_logic_vector) return string is
		variable fourbits : std_logic_vector(4 downto 0);
		variable result : string(1 to N'length);
	begin
		
	end function to_hex_string;

end utils;
