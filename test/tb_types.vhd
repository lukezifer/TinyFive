use work.cpu_types.all;

entity tb_types is
end entity tb_types;

architecture behaviour of tb_types is

  signal   test_alu_instr : alu_instr_enum;
  signal   test_alu_op    : alu_op_enum;
  constant clock_period   : time := 10 ns;

begin

  test : process is
  begin

    test_alu_instr <= ALU_INSTR_ADD;
    wait for clock_period;
    test_alu_instr <= ALU_INSTR_OR;
    wait for clock_period;
    test_alu_op    <= ALU_OP_I;
    wait for clock_period;
    test_alu_op    <= ALU_OP_R;
    wait;

  end process test;

end architecture behaviour;

