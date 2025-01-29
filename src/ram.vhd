--------------------------------------------------------------------------------
--! @file
--! @brief Random Access Memory
--! @author Lukas Meysel
--! @date 2019-2025
--! @copyright MIT LICENSE
--------------------------------------------------------------------------------

--! use ieee library.

library ieee;
  --! use std_logic_1164 for std_logic and std_logic_vector.
  use ieee.std_logic_1164.all;
  --! use numeric_std for unsigned.
  use ieee.numeric_std.all;

--! Random Access Memory Interface.

--! The size of RAM is configurable.

entity ram is
  generic (
    size : integer --! Configurable size of RAM in bytes. Shall be aligned to 4 bytes.
  );
  port (
    clk    : in    std_logic;                     --! Clock Input
    addr   : in    std_logic_vector(7 downto 0);  --! 8 bit Address Input
    r_en   : in    std_logic;                     --! Read Enable Input to Read to dout.
    w_en   : in    std_logic;                     --! Write Enable Input to Store data from din.
    funct3 : in    std_logic_vector(2 downto 0);  --! 3 bit Input to indicate Funct3.
    din    : in    std_logic_vector(31 downto 0); --! 32 bit Input Data to Store.
    dout   : out   std_logic_vector(31 downto 0)  --! 32 bit Output Data to Read.
  );
end entity ram;

--! @brief Random Access Memory Implementation.
--! @details Storing data is synchronized with Clock, Store Byte, Store
--! Halfword and Store Word are supported.
--! Reading data is asynchronous, Load Byte, Load Halfword, Load Word, Load Byte
--! Unsigned and Load Halfword Unsigned are supported.
--! The Memory Access in RISC V is Byte Addressing with little endianness
--! Little endianness means that the least significant byte is stored at the
--! lowest address.

architecture behaviour of ram is

  type ram_t is array(0 to size - 1) of std_logic_vector(7 downto 0); --! Internal array type for random access memory.

  signal ram_set : ram_t; --! Internal array of random access memory data.

begin

  --! Synchron Store.

	--! | Instruction    | funct3 |
	--! | -------------- | ------ |
	--! | store byte     | b000   |
	--! | store halfword | b001   |
	--! | store word     | b010   |

  --! @vhdlflow
  data_store : process (clk) is
  begin

    if (rising_edge(clk)) then
      -- store
      if (w_en = '1') then
        if (funct3(2) = '0') then
          ram_set(to_integer(unsigned(addr))) <= din(7 downto 0);

          if (funct3(0) = '1' or funct3(1) = '1') then
            ram_set(to_integer(unsigned(addr) + 1)) <= din(15 downto 8);

            if (funct3(1) = '1') then
              ram_set(to_integer(unsigned(addr) + 2)) <= din(23 downto 16);
              ram_set(to_integer(unsigned(addr) + 3)) <= din(31 downto 24);
            end if;
          end if;
        end if;
      end if;
    end if;

  end process data_store;

  --! Asynchronous Read.

  --! | Instruction            | funct3 |
  --! | ---------------------- | ------ |
  --! | load byte              | b000   |
  --! | load byte unsigned     | b100   |
  --! | load halfword          | b001   |
  --! | load halfword unsigned | b101   |
  --! | load word              | b010   |

  --! @vhdlflow
  data_read : process (addr, ram_set, r_en, funct3) is

    variable ram_out : std_logic_vector(31 downto 0);

  begin

    if (r_en = '1') then
      ram_out(7 downto 0) := ram_set(to_integer(unsigned(addr)));
      if (funct3(1 downto 0) = "00") then
        if (funct3(2) = '0') then
          -- lb
          dout <= std_logic_vector(resize(signed(ram_out(7 downto 0)), dout'length));
        else
          -- lbu
          dout <= std_logic_vector(resize(unsigned(ram_out(7 downto 0)), dout'length));
        end if;
      else
        ram_out(15 downto 8) := ram_set(to_integer(unsigned(addr) + 1));
        if (funct3(1 downto 0) = "01") then
          if (funct3(2) = '0') then
            -- lh
            dout <= std_logic_vector(resize(signed(ram_out(15 downto 0)), dout'length));
          else
            -- lhu
            dout <= std_logic_vector(resize(unsigned(ram_out(15 downto 0)), dout'length));
          end if;
        end if;
        if (funct3 = "010") then
          -- lw
          ram_out(23 downto 16) := ram_set(to_integer(unsigned(addr) + 2));
          ram_out(31 downto 24) := ram_set(to_integer(unsigned(addr) + 3));
          dout <= ram_out;
        end if;
      end if;
    else
      dout <= (others => '0');
    end if;

  end process data_read;

end architecture behaviour;
