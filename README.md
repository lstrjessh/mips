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

## Repository structure

```text
rtl/                   Integrated processor and board wrapper
tests/                 Processor and control-unit testbenches
fpga/                  Quartus project and device settings
memory/                Memory initialization files
examples/datapath/     Earlier datapath-only implementation
```

The datapath example has its own `rtl`, `tests`, `fpga`, and `memory` directories. Build it separately because module names overlap with the integrated processor.

## Open and build

1. Install Intel Quartus Prime with Cyclone V support. The checked-in project settings were created with Quartus Prime Lite 18.1.
2. Open `fpga/mips.qpf` for the integrated processor, or `examples/datapath/fpga/mips.qpf` for the datapath example.
3. Review source assignments and select the intended top-level entity. The checked-in `processor.qsf` selects `processor`; use `de1soc_demo` for the board interface and supply the appropriate board pin and timing constraints.
4. Review memory initialization parameters and set them to local program/data files. Some helper defaults reference paths from the original course environment.
5. Compile the design and review synthesis and timing results before programming the board.

## Simulation

Use ModelSim or a compatible Verilog simulator. Compile the source modules for one stage and its selected testbench, then run the corresponding testbench top-level. Review memory paths before simulation. Keep the stages separate because module names overlap.

The implementation covers a subset of MIPS instructions. It is not a complete MIPS-compatible processor, and the sequentially drawn portfolio visual is illustrative rather than evidence of a pipelined architecture.

## Verification and attribution

The sources were imported from the local working project. Synthesis, simulation, and board operation have not been rerun for this publication. Inspect the included testbenches and run them in your toolchain before relying on the design.

Some modules were supplied with the coursework; retain their existing author and tool notices. The earlier implementation is documented in [examples/datapath/README.md](examples/datapath/README.md).
