library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.utils.all;

entity tb_utils is
end entity tb_utils;

architecture test of tb_utils is
	signal test_vec : std_logic_vector(7 downto 0);
	constant CLOCK_PERIOD : time := 10 ns;
begin

unit_test: process
begin
	test_vec <= "10000001";
	wait for CLOCK_PERIOD;
	assert (test_vec(0) = '1') report "test_vec(0) is " & to_char(test_vec(0)) severity failure;
	assert(1 = 0) report "test_vec is " & to_string(test_vec) severity note;
	assert(1 = 0) report "test_vec is " & to_hex_string(test_vec) severity note;
	wait;
end process unit_test;

end architecture test;
