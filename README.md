# Tiny Five - Simple RISC-V32I Implementation in VHDL

Tiny Five is a Hobbyist's RISC V implementation of the RV32I base instruction set in VHDL.

The implementation is a work in progress and is not yet complete. Currently the implementation provides a single-cylce cpu without privileged architecture. See the [Implemented Instructions](#implemented-instructions) section for the list of instructions that have been implemented.

## Usage

The code is written in VHDL 1993 and can be simulated using GHDL. The testbenches use Vunit to run the tests.

### Dependencies

- GHDL >= 5.0.0
- Python 3 and Vunit >= 4.7.0
- GTKWave (optional)

### Usage

Run the testbenches in the `test` directory to verify the implementation with

```bash
python run.py
```

## Implemented Instructions

| Name                          | Format | RV32I Base          |
| ----------------------------- | ------ | ------------------- |
| Shift Left Logical            | R      | SLL rd, rs1, rs2    |
| Shift Left Logical Imm        | I      | SLLI rd, rs1, shamt |
| Shift Right Logical           | R      | SRL rd, rs1, rs2    |
| Shift Right Logical Imm       | I      | SRLI rd, rs1, shamt |
| Add                           | R      | ADD rd, rs1, rs2    |
| Add Imm.                      | I      | ADDI rd, rs1, imm   |
| Load Upper Imm.               | U      | LUI rd, imm         |
| And                           | R      | AND rd, rs1, rs2    |
| And Imm.                      | I      | ANDI rd, rs1, imm   |
| Or                            | R      | OR rd, rs1, rs2     |
| Or Imm.                       | I      | ORI rd, rs1, imm    |
| XOR                           | R      | XOR rd, rs1, rs2    |
| XOR Imm.                      | I      | XORI rd, rs1, imm   |
| Set Less Than                 | R      | SLT rd, rs1, rs2    |
| Set Less Than Imm             | I      | SLTI rd, rs1, imm   |
| Set Less Than Unsigned        | R      | SLTU rd, rs1, rs2   |
| Set Less Than Imm Unsigned    | I      | SLTIU rd, rs1, imm  |
| Branch Equal                  | B      | BEQ rs1, rs2, imm   |
| Branch Not Equal              | B      | BNE rs1, rs2, imm   |
| Branch Less Than              | B      | BLT rs1, rs2, imm   |
| Branch Graeter Equal          | B      | BGE rs1, rs2, imm   |
| Branch Less Than Unsigned     | B      | BLTU rs1, rs2, imm  |
| Branch Greater Equal Unsigned | B      | BGEU rs1, rs2, imm  |
| Jump and Link                 | J      | JAL rd, imm         |
| Jump                          | J      | JALR rd, rs1, imm   |
| Load Byte                     | I      | LB rd, rs1, imm     |
| Load Halfword                 | I      | LH rd, rs1, imm     |
| Load Byte Unsigned            | I      | LBU rd, rs1, imm    |
| Load Halfword Unsigned        | I      | LHU rd, rs1, imm    |
| Load Word                     | I      | LW rd, rs1, imm     |
| Store Byte                    | S      | SB rs1, rs2, imm    |
| Store Halfword                | S      | SH rs1, rs2, imm    |
| Store Word                    | S      | SW rs1, rs2, imm    |

## License

This project is licensed under the MIT License.

