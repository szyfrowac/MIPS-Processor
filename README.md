# Single-Cycle MIPS Processor (Verilog)

This folder contains a simple single-cycle MIPS-style processor implementation in Verilog, along with a basic testbench.

## Folder Structure

- `src/` — RTL source files
  - `top_module.v` — top-level datapath/control integration
  - `pc_register.v`, `adder.v`, `mux2to1.v`, `sign_extension.v`, `sl2.v`
  - `instruction_memory.v`, `register_memory.v`, `data_memory.v`
  - `control_unit.v`, `alu.v`
  - `reg_init.mem`, `data_init.mem` — initial register/data memory contents
- `sims/`
  - `tb_top_module.v` — testbench for `top_module`

## Implemented Instruction Support

Based on the current control and ALU logic, the design supports:

- R-type OR
- SUBI
- SW
- BEQ

The instruction memory is currently preloaded with 4 sample instructions in `instruction_memory.v`.

## Clock/Reset Behavior

- `pc_register` updates on positive clock edge
- Reset is active-high and sets PC to `0`
- Register-file and data-memory writes occur on positive clock edge

## Simulation

You can simulate using tools like Vivado XSIM or Icarus Verilog.

### Example (Icarus Verilog)

```bash
iverilog -g2012 -o simv sims/tb_top_module.v src/*.v
vvp simv
```

## Notes

1. `top_module.v` instantiates `alu_control`, but there is no `alu_control.v` in this folder right now. Add/port that module into `src/` before full compilation.
2. `register_memory.v` and `data_memory.v` use `$readmemh(...)`, so run simulation from this folder (or provide proper relative paths) so `.mem` files are found.

## Next Improvements (Optional)

- Add waveform dumping (`$dumpfile`, `$dumpvars`) in `tb_top_module.v`
- Add more instructions (LW, ADDI, AND/ADD/SUB for R-type)
- Add self-checking testbench assertions for automated verification
