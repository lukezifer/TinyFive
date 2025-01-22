--------------------------------------------------------------------------------
--! @file
--! @brief Program Counter
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library

library ieee;
  --! use std_logic_1164 for std_logic and std_logic_vector.
  use ieee.std_logic_1164.all;
  --! use numeric_std for unsigned.
  use ieee.numeric_std.all;

--! Program Counter Interface.

entity pc is
  port (
    clk     : in    std_logic;                     --! Clock Input.
    rst     : in    std_logic;                     --! Reset Input.
    ld      : in    std_logic;                     --! Load Input.
    en      : in    std_logic;                     --! Enable Input.
    data_in : in    std_logic_vector(31 downto 0); --! PC Data Input.
    cnt     : out   std_logic_vector(31 downto 0)  --! PC Data Output.
  );
end entity pc;

--! @brief Program Counter Implementation.
--! @details Reset, Load from Data Input and Enable to count is synchronized
--! with Clock.

architecture behaviour of pc is

  signal internal_count : std_logic_vector(31 downto 0); --! internal value of Program Counter.

begin

  cnt <= internal_count;

  --! Synchronous Reset, Load and Counting.
  --! @vhdlflow
  counter : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        internal_count <= (others => '0');
      elsif (ld = '1') then
        internal_count <= data_in;
      elsif (en = '1') then
        internal_count <= std_logic_vector(unsigned(internal_count) + 4);
      end if;
    end if;

  end process counter;

end architecture behaviour;
