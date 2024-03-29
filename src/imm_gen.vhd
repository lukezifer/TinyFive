library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity imm_gen is
port(
	instr_in : in std_logic_vector(31 downto 0);
	immediate_out : out std_logic_vector(63 downto 0)
);
end imm_gen;

architecture behaviour of imm_gen is
	signal instr_type : std_logic_vector(6 downto 0);
begin
	instr_type <= instr_in(6 downto 0);
	process(instr_in, instr_type)
	begin
	case instr_type is
		--B-Type
		when "1100011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31) & instr_in(7) & instr_in(30 downto 25) & instr_in(11 downto 8)), immediate_out'length));
		--I-Type
		when "0010011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 20)), immediate_out'length));
		--S-Type
		when "0100011" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 25) & instr_in(11 downto 7)), immediate_out'length));
		--U-Type
		when "0110111" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 12) & "000000000000"), immediate_out'length));
		--J-Type
		when "1101111" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31) & instr_in(19 downto 12) & instr_in(20) & instr_in(30 downto 21)), immediate_out'length));
		--JALR Offset I-Type
		when "1100111" =>
			immediate_out <= std_logic_vector(resize(signed(instr_in(31 downto 21) & '0'), immediate_out'length));
		when others =>
			immediate_out <= (others => '0');
	end case;
	end process;

end architecture behaviour;


