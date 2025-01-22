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
generic(
	size : integer --! Configurable size of RAM in bytes. Shall be aligned to 4 bytes.
);

port(
	clk : in  std_logic; --! Clock Input
	addr : in  std_logic_vector(7 downto 0); --! 8 bit Address Input
	r_en : in  std_logic; --! Read Enable Input to Read to dout.
	w_en : in  std_logic; --! Write Enable Input to Store data from din.
	funct3 : in std_logic_vector(2 downto 0); --! 3 bit Input to indicate Funct3.
	din : in  std_logic_vector(31 downto 0); --! 32 bit Input Data to Store.
	dout : out std_logic_vector(31 downto 0) --! 32 bit Output Data to Read.
);
end entity ram;

--! @brief Random Access Memory Implementation.
--! @details Storing data is synchronized with Clock, Store Byte, Store
--! Halfword and Store Word are supported.
--! Reading data is asynchron, Load Byte, Load Halfword, Load Word, Load Byte
--! Unsigned and Load Halfword Unsigned are supported.
architecture behaviour of ram is
	type ram_t is array(0 to size - 1) of std_logic_vector(31 downto 0); --! Internal array type for registers.
	signal ram_set : ram_t := (others => (others => '0')); --! Internal array of registers.
begin

	--! Synchron Store.
	--! @vhdlflow
	data_store: process(clk)
	variable ram_in : std_logic_vector(31 downto 0) := x"00000000";
	begin
		if(rising_edge(clk)) then
			--store
			if(w_en = '1') then
				case funct3 is
					--store byte
					when b"000" =>
						ram_in := std_logic_vector(resize(unsigned(din(7 downto 0)), ram_in'length));
					--store halfword
					when b"001" =>
						ram_in := std_logic_vector(resize(unsigned(din(15 downto 0)), ram_in'length));
					--store word
					when b"010" =>
						ram_in := din;
					when others =>
						ram_in := x"00000000";
				end case;
				ram_set(to_integer(unsigned(addr))) <= ram_in;
			end if;
		end if;
	end process data_store;

	--! Asynchron Read.
	--! @vhdlflow
	data_read: process(ram_set, r_en, funct3)
	variable ram_out : std_logic_vector(31 downto 0) := x"00000000";
	begin
		if(r_en = '1') then
			ram_out := ram_set(to_integer(unsigned(addr)));
			case funct3 is
				--lb
				when b"000" =>
					dout <= std_logic_vector(resize(signed(ram_out(7 downto 0)), dout'length));
				--lh
				when b"001" =>
					dout <= std_logic_vector(resize(signed(ram_out(15 downto 0)), dout'length));
				--lbu
				when b"100" =>
					dout <= std_logic_vector(resize(unsigned(ram_out(7 downto 0)), dout'length));
				--lhu
				when b"101" =>
					dout <= std_logic_vector(resize(unsigned(ram_out(15 downto 0)), dout'length));
				--lw
				when b"010" =>
					dout <= ram_out;
				when others =>
					dout <= x"00000000";
			end case;
		end if;
	end process data_read;

end architecture behaviour;
