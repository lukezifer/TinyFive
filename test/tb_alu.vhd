library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.types.all;

library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.run_pkg.all;

entity tb_alu is
	generic (runner_cfg : string);
end entity tb_alu;

architecture behaviour of tb_alu is
	component alu is
		port(
			instr : in ALU_INSTR_ENUM;
			a_in : in std_logic_vector(31 downto 0);
			b_in : in std_logic_vector(31 downto 0);
			c_out : out std_logic_vector(31 downto 0);
			z_flag : out std_logic
		);

	end component alu;
	Constant CLOCK_PERIOD : time := 10 ns;
	signal tb_instr	: ALU_INSTR_ENUM;
	signal tb_a_in	: std_logic_vector(31 downto 0);
	signal tb_b_in	: std_logic_vector(31 downto 0);
	signal tb_c_out	: std_logic_vector(31 downto 0);
	signal tb_z_flag: std_logic;

begin
dut: alu
port map(
	instr   => tb_instr,
	a_in   => tb_a_in,
	b_in   => tb_b_in,
	c_out  => tb_c_out,
	z_flag => tb_z_flag
);

test_runner: process
begin

	test_runner_setup(runner, runner_cfg);

	while test_suite loop
		if run("Initialization") then
			--Initialization Testcase
			tb_instr <= ALU_INSTR_AND;
			tb_a_in <= x"00000000";
			tb_b_in <= x"00000000";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			wait on tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("ADD") then
		--ADD Testcase 1
			tb_instr <= ALU_INSTR_ADD;
			tb_a_in <= x"00000001";
			tb_b_in <= x"00000010";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000011");
			check_match(tb_z_flag, '0');

			--ADD Testcase 2
			tb_instr <= ALU_INSTR_ADD;
			tb_a_in <= x"FFFFFFFF";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("AND") then
			--AND Testcase 1
			tb_instr <= ALU_INSTR_AND;
			tb_a_in <= x"01010101";
			tb_b_in <= x"11111111";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"01010101");
			check_match(tb_z_flag, '0');

			--AND Testcase 2
			tb_instr <= ALU_INSTR_AND;
			tb_a_in <= x"10101010";
			tb_b_in <= x"01010101";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("OR") then
			--OR Testcase 1
			tb_instr <= ALU_INSTR_OR;
			tb_a_in <= x"01010101";
			tb_b_in <= x"10101010";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"11111111");
			check_match(tb_z_flag, '0');

			--OR Testcase 2
			tb_instr <= ALU_INSTR_OR;
			tb_a_in <= x"00000000";
			tb_b_in <= x"00000000";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SLL") then
			--SLL Testcase 1
			tb_instr <= ALU_INSTR_SLL;
			tb_a_in <= x"00000001";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000002");
			check_match(tb_z_flag, '0');

			--SLL Testcase 2
			tb_instr <= ALU_INSTR_SLL;
			tb_a_in <= x"FFFFFFFE";
			tb_b_in <= x"0000001F";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SLT") then
			--SLT Testcase 1
			tb_instr <= ALU_INSTR_SLT;
			tb_a_in <= x"0FFFFFF1";
			tb_b_in <= x"0FFFFFFF";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000001");
			check_match(tb_z_flag, '0');

			--SLT Testcase 2
			tb_instr <= ALU_INSTR_SLT;
			tb_a_in <= x"0FFFFFFF";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SLTU") then
			--SLTU Testcase 1
			tb_instr <= ALU_INSTR_SLTU;
			tb_a_in <= x"FFFFFFF0";
			tb_b_in <= x"FFFFFFF1";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000001");
			check_match(tb_z_flag, '0');

			--SLTU Testcase 2
			tb_instr <= ALU_INSTR_SLTU;
			tb_a_in <= x"FFFFFFF1";
			tb_b_in <= x"FFFFFFF0";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SRA") then
			--SRA Testcase 1
			tb_instr <= ALU_INSTR_SRA;
			tb_a_in <= x"F0000001";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"F8000000");
			check_match(tb_z_flag, '0');

			--SRA Testcase 2
			tb_instr <= ALU_INSTR_SRA;
			tb_a_in <= x"00000001";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SRL") then
			--SRL Testcase 1
			tb_instr <= ALU_INSTR_SRL;
			tb_a_in <= x"00000003";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000001");
			check_match(tb_z_flag, '0');

			--SRL Testcase 2
			tb_instr <= ALU_INSTR_SRL;
			tb_a_in <= x"7FFFFFFF";
			tb_b_in <= x"0000001F";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("SUB") then
			--SUB Testcase 1
			tb_instr <= ALU_INSTR_SUB;
			tb_a_in <= x"00000010";
			tb_b_in <= x"00000001";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"0000000F");
			check_match(tb_z_flag, '0');

			--SUB Testcase 2
			tb_instr <= ALU_INSTR_SUB;
			tb_a_in <= x"F0F0F0F0";
			tb_b_in <= x"F0F0F0F0";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("XOR") then
			--XOR Testcase 1
			tb_instr <= ALU_INSTR_XOR;
			tb_a_in <= x"FFFFFFFF";
			tb_b_in <= x"F0F0F0F0";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"0F0F0F0F");
			check_match(tb_z_flag, '0');

			--XOR Testcase 2
			tb_instr <= ALU_INSTR_XOR;
			tb_a_in <= x"11111111";
			tb_b_in <= x"11111111";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');

		elsif run("ZERO") then
			--ZERO Testcase
			tb_instr <= ALU_INSTR_ZERO;
			tb_a_in <= x"FFFF0000";
			tb_b_in <= x"0000FFFF";
			wait on tb_c_out, tb_z_flag for CLOCK_PERIOD;
			check_match(tb_c_out, x"00000000");
			check_match(tb_z_flag, '1');
		end if;

	end loop;

	test_runner_cleanup(runner);

end process test_runner;

end architecture behaviour;
