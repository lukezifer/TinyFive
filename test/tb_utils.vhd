library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.utils.all;

entity tb_utils is
end entity tb_utils;

architecture test of tb_utils is
	signal test_vec : std_logic_vector(7 downto 0);
	signal test_vec_3bit : std_logic_vector(2 downto 0);
	signal test_vec_9bit : std_logic_vector(8 downto 0);
	signal test_vec_32bit : std_logic_vector(31 downto 0);
	constant CLOCK_PERIOD : time := 10 ns;
begin

unit_test: process
begin
	test_vec <= "10000001";
	test_vec_3bit <= "110";
	test_vec_9bit <= "100001111";
	test_vec_32bit <= x"F0F0F0F0";
	wait for CLOCK_PERIOD;
	assert (test_vec(0) = '1') report "test_vec(0) is " & to_char(test_vec(0)) severity failure;
	report "test_vec is " & to_string(test_vec);
	report "test_vec is " & to_hex_string(test_vec);
	report "test_vec_3bit is " & to_string(test_vec_3bit);
	report "test_vec_3bit is " & to_hex_string(test_vec_3bit);
	report "test_vec_9bit is " & to_string(test_vec_9bit);
	report "test_vec_9bit is " & to_hex_string(test_vec_9bit);
	report "test_vec_32bit is " & to_string(test_vec_32bit);
	report "test_vec_32bit is " & to_hex_string(test_vec_32bit);
	wait;
end process unit_test;

end architecture test;
