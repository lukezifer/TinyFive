library ieee;
use work.types.all;

entity tb_types is
end entity;

architecture behaviour of tb_types is
	signal test_alu_instr : ALU_INSTR_ENUM;
	signal test_alu_op : ALU_OP_ENUM;
	constant CLOCK_PERIOD : time := 10 ns;
begin
test: process
begin
	test_alu_instr <= ALU_INSTR_ADD;
	wait for CLOCK_PERIOD;
	test_alu_instr <= ALU_INSTR_OR;
	wait for CLOCK_PERIOD;
	test_alu_op <= ALU_OP_I;
	wait for CLOCK_PERIOD;
	test_alu_op <= ALU_OP_R;
	wait;

end process test;
end architecture behaviour;

