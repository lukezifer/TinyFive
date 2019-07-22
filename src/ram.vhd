library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
generic(
	size : integer
);
port(
	clk		: in  std_logic;
	addr	: in  std_logic_vector(7 downto 0);
	r_en	: in  std_logic;
	w_en	: in  std_logic;
	funct3	: in std_logic_vector(2 downto 0);
	din		: in  std_logic_vector(31 downto 0);
	dout	: out std_logic_vector(31 downto 0)
);
end entity ram;

architecture behaviour of ram is
	type ram_t is array(0 to size - 1) of std_logic_vector(31 downto 0);
	signal ram_set : ram_t := (others => (others => '0'));
begin
	data_mem: process(clk)
	variable ram_in : std_logic_vector(31 downto 0) := x"00000000";
	variable ram_out : std_logic_vector(31 downto 0) := x"00000000";
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
		--load
		if(r_en = '1') then
			ram_out := ram_set(to_integer(unsigned(addr)));
			case funct3 is
				--lb
				when b"000" =>
					dout <= std_logic_vector(resize(signed(ram_out(7 downto 0)), dout'length));
				--lh
				when b"001" =>
					dout <= std_logic_vector(resize(signed(ram_out(15 downto 0)), ram_out'length));
				--lbu
				when b"100" =>
					dout <= std_logic_vector(resize(unsigned(ram_out(7 downto 0)), ram_out'length));
				--lhu
				when b"101" =>
					dout <= std_logic_vector(resize(unsigned(ram_out(15 downto 0)), ram_out'length));
				--lw
				when b"010" =>
					dout <= ram_out;
				when others =>
					dout <= x"00000000";
			end case;
		end if;
	end process data_mem;

end architecture behaviour;
