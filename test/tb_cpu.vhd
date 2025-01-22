library ieee;
  use ieee.std_logic_1164.all;

library vunit_lib;
  use vunit_lib.run_pkg.all;

entity tb_cpu is
  generic (
    runner_cfg : string
  );
end entity tb_cpu;

architecture behaviour of tb_cpu is

  component cpu is
    port (
      clk        : in    std_logic;
      rst        : in    std_logic;
      test       : in    std_logic;
      test_instr : in    std_logic_vector(31 downto 0)
    );
  end component cpu;

  constant clock_period  : time := 10 ns;
  signal   tb_clk        : std_logic;
  signal   tb_rst        : std_logic;
  signal   tb_test       : std_logic;
  signal   tb_test_instr : std_logic_vector(31 downto 0);

begin

  tb_test <= '1';

  dut : component cpu
    port map (
      clk        => tb_clk,
      rst        => tb_rst,
      test       => tb_test,
      test_instr => tb_test_instr
    );

  clock : process is
  begin

    tb_clk <= '1';
    wait for clock_period / 2;
    tb_clk <= '0';
    wait for clock_period / 2;

  end process clock;

  test_runner : process is
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("nop") then
        -- nop
        tb_test_instr <= x"00000013";
        tb_rst        <= '1';
        wait for 2 * clock_period;
        tb_rst        <= '0';
        wait for clock_period;
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process test_runner;

end architecture behaviour;
