library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;
  use work.cpu_types.all;

library vunit_lib;
  use vunit_lib.check_pkg.all;
  use vunit_lib.run_pkg.all;

entity tb_branch_cmp is
  generic (
    runner_cfg : string
  );
end entity tb_branch_cmp;

architecture behaviour of tb_branch_cmp is

  component branch_cmp is
    port (
      alu_op   : in    alu_op_enum;
      instr_in : in    std_logic_vector(31 downto 0);
      rs1_data : in    std_logic_vector(31 downto 0);
      rs2_data : in    std_logic_vector(31 downto 0);
      branch   : out   std_logic
    );
  end component branch_cmp;

  constant clock_period : time := 10 ns;
  signal   tb_alu_op    : alu_op_enum;
  signal   tb_instr_in  : std_logic_vector(31 downto 0);
  signal   tb_rs1_data  : std_logic_vector(31 downto 0);
  signal   tb_rs2_data  : std_logic_vector(31 downto 0);
  signal   tb_branch    : std_logic;

begin

  dut : component branch_cmp
    port map (
      alu_op   => tb_alu_op,
      instr_in => tb_instr_in,
      rs1_data => tb_rs1_data,
      rs2_data => tb_rs2_data,
      branch   => tb_branch
    );

  test_runner : process is
  begin

    test_runner_setup(runner, runner_cfg);

    tb_alu_op <= ALU_OP_B;

    while test_suite loop

      if run("No Branch") then
        -- nop
        tb_alu_op   <= ALU_OP_R;
        tb_instr_in <= b"00000000000000000000000000110111";
        tb_rs1_data <= x"00000000";
        tb_rs2_data <= x"00000000";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BEQ") then
        -- beq 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010000000001100011";
        tb_rs1_data <= x"00000000";
        tb_rs2_data <= x"00000000";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"00000010";
        tb_rs2_data <= x"00000001";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BNE") then
        -- bne 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010001000001100011";
        tb_rs1_data <= x"00000010";
        tb_rs2_data <= x"00000001";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"00000010";
        tb_rs2_data <= x"00000010";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BLT") then
        -- blt 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010100000001100011";
        tb_rs1_data <= x"F0000001";
        tb_rs2_data <= x"00000001";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"FFFFFFF2";
        tb_rs2_data <= x"FFFFFFF1";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BGE") then
        -- bge 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010101000001100011";
        tb_rs1_data <= x"00000100";
        tb_rs2_data <= x"00000011";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"00000010";
        tb_rs2_data <= x"00000101";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BLTU") then
        -- bltu 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010110000001100011";
        tb_rs1_data <= x"00000001";
        tb_rs2_data <= x"F0000001";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"FFFFFFF2";
        tb_rs2_data <= x"FFFFFFF1";
        wait for clock_period;
        check_match(tb_branch, '0');
      elsif run("BGEU") then
        -- bgeu 0x2, 0x1, 0x0
        tb_instr_in <= b"00000000000100010111000001100011";
        tb_rs1_data <= x"00000100";
        tb_rs2_data <= x"00000011";
        wait for clock_period;
        check_match(tb_branch, '1');

        tb_rs1_data <= x"00000010";
        tb_rs2_data <= x"00000101";
        wait for clock_period;
        check_match(tb_branch, '0');
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process test_runner;

end architecture behaviour;

