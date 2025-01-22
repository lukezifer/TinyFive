library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_pkg.all;

entity tb_imm_gen is
  generic (
    runner_cfg : string
  );
end entity tb_imm_gen;

architecture behaviour of tb_imm_gen is

  component imm_gen is
    port (
      instr_in      : in    std_logic_vector(31 downto 0);
      regs1_in      : in    std_logic_vector(31 downto 0);
      immediate_out : out   std_logic_vector(63 downto 0)
    );
  end component imm_gen;

  constant clock_period     : time := 10 ns;
  signal   tb_instr_in      : std_logic_vector(31 downto 0);
  signal   tb_regs1_in      : std_logic_vector(31 downto 0);
  signal   tb_immediate_out : std_logic_vector(63 downto 0);
  signal   tb_result        : signed(63 downto 0);

begin

  dut : component imm_gen
    port map (
      instr_in      => tb_instr_in,
      regs1_in      => tb_regs1_in,
      immediate_out => tb_immediate_out
    );

  tb_result <= signed(tb_immediate_out);

  test_runner : process is
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("B-Type") then
        -- bne x10, x11, 2000 B-Type
        tb_instr_in <= b"01111100101101010001100001100011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 1000);

        -- bne x10, x11, -100 B-Type
        tb_instr_in <= b"11111000101101010001111011100011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, - 50);
      elsif run("I-Type") then
        -- addi x1, x2, 100 I-Type
        tb_instr_in <= b"00000110010000001000000100010011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 100);

        -- addi x1, x2, -42 I-Type
        tb_instr_in <= b"11111101011000001000000100010011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, - 42);

        -- sw x1, x0F(x2)
        tb_instr_in <= b"00000000001000001001011110100011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 15);

        -- sw x1, -x0F(x2)
        tb_instr_in <= b"11111110001000001001100010100011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, - 15);
      elsif run("R-Type") then
        -- add x1, x2, x3 R-Type
        tb_instr_in <= b"00000000001100010000000010110011";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 0);

        -- lui x1, 100
        tb_instr_in <= b"00000000000001100100000010110111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal (tb_result, 409600);

        -- lui x1, 1
        tb_instr_in <= b"00000000000000000001000010110111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 4096);

        -- jal x1, 100
        tb_instr_in <= b"00001100100000000000000011101111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 100);

        -- jal x1, 1
        tb_instr_in <= b"00000000001000000000000011101111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 1);

        -- jalr x1, 100(x2)
        tb_instr_in <= b"00000110010000010000000011100111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 100);

        tb_instr_in <= b"00000000000100010000000011100111";
        tb_regs1_in <= b"00000000000000000000000000000000";
        wait for clock_period;
        check_equal(tb_result, 0);
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process test_runner;

end architecture behaviour;

