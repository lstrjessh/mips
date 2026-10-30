# MIPS Computer

An educational 32-bit MIPS-style processor in Verilog for the DE1-SoC FPGA board. The project progresses from a datapath implementation to a processor with instruction decoding and a board demonstration wrapper.

## Architecture

- 32-bit datapath, program counter, register file, ALU, and sign extension.
- Instruction ROM and data memory with a memory-mapped serial interface.
- Control logic for `LW`, `SW`, `ADDI`, `ADD`, `SUB`, `AND`, `OR`, `XOR`, and `NOR`.
- DE1-SoC wrapper exposing processor debug signals through LEDs and seven-segment displays.
- Testbenches for processor components and integration.

## Stack

Verilog, Intel Quartus Prime, ModelSim, and Cyclone V / DE1-SoC.

## Project stages

| Directory | Purpose |
| --- | --- |
| `lab6/` | Datapath integration with hardcoded control signals |
| `lab7/` | Instruction decoder, integrated processor, and board demo |

Each stage includes Verilog sources, Quartus project settings, testbenches, and a `blank.memh` input. Generated synthesis databases, simulator output, and duplicate source copies are excluded.

## Open and build

1. Install Intel Quartus Prime with Cyclone V support. The checked-in project settings were created with Quartus Prime Lite 18.1.
2. Open `lab7/LAB7_MIPS.qpf` for the control-unit stage, or `lab6/LAB6_MIPS.qpf` for the earlier datapath.
3. Review source assignments and select the intended top-level entity. The checked-in `processor.qsf` selects `processor`; use `de1soc_demo` for the Lab 7 board interface and supply the appropriate board pin and timing constraints.
4. Review memory initialization parameters and set them to local program/data files. Some helper defaults reference paths from the original course environment.
5. Compile the design and review synthesis and timing results before programming the board.

## Simulation

Use ModelSim or a compatible Verilog simulator. Compile the source modules for one stage and its selected testbench, then run the corresponding testbench top-level. Review memory paths before simulation. Keep the stages separate because module names overlap.

The implementation covers a subset of MIPS instructions. It is not a complete MIPS-compatible processor, and the sequentially drawn portfolio visual is illustrative rather than evidence of a pipelined architecture.

## Verification and attribution

The sources were imported from the local working project. Synthesis, simulation, and board operation have not been rerun for this publication. Inspect the included testbenches and run them in your toolchain before relying on the design.

Some modules were supplied with the coursework; retain their existing author and tool notices. The Lab 6 module breakdown is documented in [lab6/files/README.md](lab6/files/README.md).
