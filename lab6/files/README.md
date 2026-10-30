# Lab 6: Single-Cycle Datapath

## Objectives
- Implement key datapath elements (register file, PC, mux, sign-extender)
- Integrate components into a single-cycle processor
- No control unit yet (hardcoded signals)

## Files

### Your Implementation
| File | Description |
|------|-------------|
| `processor.v` | Top-level datapath |
| `register_file.v` | 32x32-bit register file |
| `pc_register.v` | Program counter (resets to 0x00400000) |
| `mux2.v` | 2-input multiplexer |
| `sign_extend.v` | 16-bit to 32-bit sign extender |

### Provided Modules
| File | Description |
|------|-------------|
| `alu.v` | Arithmetic Logic Unit |
| `inst_rom.v` | Instruction memory |
| `data_memory.v` | Data memory with serial I/O |
| `async_memory.v` | Async memory helper |
| `serial_buffer.v` | Serial port buffer |

## Usage
1. Open in Quartus II
2. Target device: Cyclone V 5CSEMA5F31C6
3. Set `INIT_PROGRAM` to path of `blank.memh`
4. Synthesize and check schematic

## Register File Requirements
- Two read ports (asynchronous)
- One write port (synchronous, positive edge)
- Register $0 always returns 0
