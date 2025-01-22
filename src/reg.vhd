--------------------------------------------------------------------------------
--! @file
--! @brief Register File
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

--! Register File Interface.

entity reg is
  port (
    clk      : in    std_logic;                     --! Clock Input.
    rst      : in    std_logic;                     --! Reset Input.
    r_addr1  : in    std_logic_vector(4 downto 0);  --! 5 bit Read Address 1 Input.
    r_data1  : out   std_logic_vector(31 downto 0); --! 32 bit Read Data 1 Output.
    r_addr2  : in    std_logic_vector(4 downto 0);  --! 5 bit Read Address 2 Input.
    r_data2  : out   std_logic_vector(31 downto 0); --! 32 bit Read Data 2 Output.
    w_addr   : in    std_logic_vector(4 downto 0);  --! 5 bit Write Address Input.
    w_data   : in    std_logic_vector(31 downto 0); --! 32 bit Write Data Input.
    w_enable : in    std_logic                      --! Write Enable Input.
  );
end entity reg;

--! @brief Register File Implementation.

architecture behaviour of reg is

  type register_t is array (0 to 31) of std_logic_vector(31 downto 0); --! Register Array, holding 32 Registers.

  signal register_set : register_t; --! Internal Array for Registers.

begin

  write_data : process (clk) is --! Synchronous Write to Register.
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then

        for idx in 0 to 31 loop

          register_set(idx) <= (others => '0');

        end loop;

      elsif (w_enable = '1') then
        register_set(to_integer(unsigned(w_addr))) <= w_data;
      end if;
    end if;

  end process write_data;

  --! Asynchronous Read from Register.
  --! @vhdlflow
  read_data : process (r_addr1, r_addr2, register_set) is
  begin

    r_data1 <= register_set(to_integer(unsigned(r_addr1)));
    r_data2 <= register_set(to_integer(unsigned(r_addr2)));

  end process read_data;

end architecture behaviour;
