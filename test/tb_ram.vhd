library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_pkg.all;

entity tb_ram is
  generic (
    runner_cfg : string
  );
end entity tb_ram;

architecture behaviour of tb_ram is

  component ram is
    generic (
      size : integer
    );
    port (
      clk    : in    std_logic;
      addr   : in    std_logic_vector(7 downto 0);
      r_en   : in    std_logic;
      w_en   : in    std_logic;
      funct3 : in    std_logic_vector(2 downto 0);
      din    : in    std_logic_vector(31 downto 0);
      dout   : out   std_logic_vector(31 downto 0)
    );
  end component ram;

  constant clock_period : time := 10 ns;
  signal   tb_clk       : std_logic;
  signal   tb_addr      : std_logic_vector(7 downto 0);
  signal   tb_r_en      : std_logic;
  signal   tb_w_en      : std_logic;
  signal   tb_funct3    : std_logic_vector(2 downto 0);
  signal   tb_din       : std_logic_vector(31 downto 0);
  signal   tb_dout      : std_logic_vector(31 downto 0);

begin

  dut : component ram
    generic map (
      size => 256
    )
    port map (
      clk    => tb_clk,
      addr   => tb_addr,
      r_en   => tb_r_en,
      w_en   => tb_w_en,
      funct3 => tb_funct3,
      din    => tb_din,
      dout   => tb_dout
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

    -- Init, set inputs to zero
    tb_r_en   <= '0';
    tb_w_en   <= '0';
    tb_funct3 <= b"010";
    tb_addr   <= b"00000000";
    tb_din    <= x"00000000";
    wait for clock_period;

    while test_suite loop

      if run("RW") then
        -- RW Testcase
        tb_r_en   <= '0';
        tb_w_en   <= '1';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000001";
        tb_din    <= x"00000001";
        wait for clock_period;
        tb_r_en   <= '1';
        tb_w_en   <= '0';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000001";
        wait for clock_period;
        check_match(tb_dout, x"00000001");
      elsif run("simultan RW") then
        -- simultan RW Testcase
        tb_r_en   <= '1';
        tb_w_en   <= '1';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000010";
        tb_din    <= x"00000011";
        wait for clock_period;
        check_match(tb_dout, x"00000011");
      elsif run("async R") then
        -- async R Testcase
        tb_r_en   <= '1';
        tb_w_en   <= '1';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000010";
        tb_din    <= x"00000011";
        wait for clock_period;
        tb_r_en   <= '0';
        tb_w_en   <= '1';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000011";
        tb_din    <= x"00000111";
        wait for clock_period;
        tb_w_en   <= '1';
        tb_r_en   <= '0';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000110";
        tb_din    <= x"00001111";
        wait for clock_period;
        check_match(tb_dout, x"00000000");
      elsif run("sb, lb, lbu") then
        -- sb, lb, lbu Testcase
        tb_w_en   <= '0';
        tb_r_en   <= '0';
        tb_funct3 <= b"000";
        tb_addr   <= b"00000010";
        tb_din    <= x"FFFFFFFF";
        wait for clock_period;
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
        tb_r_en   <= '1';
        wait for clock_period;
        tb_funct3 <= b"100";
        wait for clock_period;
        check_match(tb_dout, x"000000FF");
        wait for clock_period;
        tb_funct3 <= b"000";
        wait for clock_period;
        check_match(tb_dout, x"FFFFFFFF");
      elsif run("sh, lh, lhu") then
        -- sh, lh, lhu Testcase
        tb_w_en   <= '0';
        tb_r_en   <= '0';
        tb_funct3 <= b"001";
        tb_addr   <= b"00000011";
        tb_din    <= x"0000FFF0";
        wait for clock_period;
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
        tb_r_en   <= '1';
        wait for clock_period;
        tb_funct3 <= b"101";
        wait for clock_period;
        check_match(tb_dout, x"0000FFF0");
        wait for clock_period;
        tb_funct3 <= b"000";
        wait for clock_period;
        check_match(tb_dout, x"FFFFFFF0");
      elsif run("sw, lw") then
        -- sw, lw Testcase
        tb_w_en   <= '0';
        tb_r_en   <= '0';
        tb_funct3 <= b"010";
        tb_addr   <= b"00000111";
        tb_din    <= x"F0F0F0F0";
        wait for clock_period;
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
        tb_r_en   <= '1';
        wait for clock_period;
        tb_funct3 <= b"010";
        wait for clock_period;
        check_match(tb_dout, x"F0F0F0F0");
      elsif run("little endian 1") then
        tb_w_en   <= '0';
        tb_r_en   <= '0';
        tb_funct3 <= b"011";
        tb_addr   <= b"00010000";
        tb_din    <= x"FFFFFFFF";
        wait for clock_period;
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
        tb_din    <= x"00000011";
        tb_addr   <= b"00010001";
        tb_funct3 <= b"000";
        wait for clock_period;
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
        tb_addr   <= b"00010000";
        tb_funct3 <= b"010";
        wait for clock_period;
        tb_r_en   <= '1';
        wait for clock_period;
        check_match(tb_dout, x"FFFF11FF");
        tb_din    <= x"00000000";
        tb_w_en   <= '1';
        wait for clock_period;
        tb_w_en   <= '0';
      elsif run("little endian 2") then
        tb_w_en   <= '0';
        tb_r_en   <= '0';
        tb_funct3 <= b"000";
        tb_addr   <= b"00001000";
        tb_din    <= x"00000011";
        tb_w_en   <= '1';
        wait for clock_period;
        tb_din    <= x"00000022";
        tb_addr   <= b"00001001";
        wait for clock_period;
        tb_din    <= x"00000033";
        tb_addr   <= b"00001010";
        wait for clock_period;
        tb_din    <= x"00000044";
        tb_addr   <= b"00001011";
        wait for clock_period;
        tb_w_en   <= '0';
        tb_funct3 <= b"010";
        tb_addr   <= b"00001000";
        tb_r_en   <= '1';
        wait for clock_period;
        check_match(tb_dout, x"44332211");
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process test_runner;

end architecture behaviour;
