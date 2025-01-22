library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_pkg.all;

entity tb_rom is
  generic (
    runner_cfg : string
  );
end entity tb_rom;

architecture behaviour of tb_rom is

  component rom is
    generic (
      size : integer
    );
    port (
      clk  : in    std_logic;
      addr : in    std_logic_vector(7 downto 0);
      dout : out   std_logic_vector(31 downto 0)
    );
  end component rom;

  constant clock_period : time := 10 ns;
  signal   tb_clk       : std_logic;
  signal   tb_addr      : std_logic_vector(7 downto 0);
  signal   tb_dout      : std_logic_vector(31 downto 0);

begin

  dut : component rom
    generic map (
      size => 256
    )
    port map (
      clk  => tb_clk,
      addr => tb_addr,
      dout => tb_dout
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

      tb_addr <= x"00";
      wait for clock_period;

      if run("Read") then

        for idx in 0 to 32 loop

          tb_addr <= std_logic_vector(to_unsigned(idx, tb_addr'length));
          wait for clock_period;
          check_not_unknown(tb_dout);
          wait for clock_period;

        end loop;

      end if;

    end loop;

    test_runner_cleanup(runner);

  end process test_runner;

end architecture behaviour;
