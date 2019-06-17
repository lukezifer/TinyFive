library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.utils.all;

entity tb_utils is
end entity tb_utils;

architecture test of tb_utils is
	signal test_vec : std_logic_vector(31 downto 0);
begin

unit_test: process
begin
	test_vec <= x"FFFFFFFF";
	wait for 1 ns;
	assert(1 = 0) report "test_vec is " & to_string(test_vec) severity failure;

end process unit_test;

end architecture test;
