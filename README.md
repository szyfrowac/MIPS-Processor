# MIPS-Style Processor Implementations (Verilog)

This repository contains Verilog implementations of two MIPS-style processor architectures:  
- A functional **Single-Cycle Processor**  
- An evolving **Pipelined Processor**

Both designs are intended for **educational purposes** and **functional simulation**.

---

## 📁 Project Structure

The project is organized into two primary architectural flows:

---

### 1. Single-Cycle Processor (`single_cycle/`)

In this design, **every instruction is executed in exactly one clock cycle**.

#### 📂 Directory Structure

- `src/` : RTL source files for processor components  
  - `top_module.v` : Top-level datapath and control integration  
  - `control_unit.v`, `alu.v`, `pc_register.v`, `adder.v`  
  - `register_memory.v`, `instruction_memory.v`, `data_memory.v`  
  - Support modules:  
    - `mux2to1.v`  
    - `sign_extension.v`  
    - `sl2.v`

- **Memory Files**  
  - `reg_init.mem`  
  - `data_init.mem`  
  (Used for pre-loading initial state)

- `sims/`  
  - `tb_top_module.v` : Testbench for system-level verification  

---

### 2. Pipelined Processor (`pipelined/`)

A **multi-stage implementation** designed to improve instruction throughput by overlapping execution stages.

#### 📂 Directory Structure

- `sources/` : RTL files including pipeline registers  
  - `ifid.v` : IF/ID pipeline register  
  - `id_ex_reg.v` : ID/EX pipeline register  
  - `ex_mem_reg.v` : EX/WB pipeline register *(currently implemented as `ex_wb_reg`)*  
  - `top_module.v` : Connects pipeline stages  

- `sims/`  
  - `tb_pipeline.v` : Testbench for pipelined processor  

---

## 🧠 Instruction Set Support

### Single-Cycle Implementation

- **R-type OR** → Bitwise OR of two registers  
- **SUBI** → Subtract immediate  
- **SW (Store Word)** → Store register value into memory  
- **BEQ (Branch if Equal)** → Conditional branch  

---

### Pipelined Implementation

The pipelined control unit currently supports:

- **ADD** → Arithmetic addition  
- **SUB** → Arithmetic subtraction  
- **NAND** → Bitwise NAND  
- **NOR** → Bitwise NOR  

---

## ⚙️ Technical Details

### Pipeline Stages (Pipelined Flow)

1. **Instruction Fetch (IF)**  
   - PC update  
   - Instruction fetched from `instruction_memory`

2. **Instruction Decode (ID)**  
   - Opcode decoding  
   - Register operands read  

3. **Execute (EX)**  
   - ALU performs operation  

4. **Writeback (WB)**  
   - Result written back to register file  

---

## 💾 Memory Initialization

Memory modules (`instruction_memory`, `register_memory`, `data_memory`) are initialized using:

- `initial` blocks  
- `$readmemh`  

### Usage:

- **Single-Cycle**  
  - Uses: `reg_init.mem`, `data_init.mem`

- **Pipelined**  
  - Uses hardcoded instructions (ADD, NAND, NOR, SUB)

---

## 🧪 Simulation Guide

### Prerequisites

You will need a Verilog simulator such as:

- **Icarus Verilog**
- **Vivado XSIM**

---

### ▶️ Using Icarus Verilog

#### Single-Cycle Simulation

```bash
iverilog -g2012 -o single_sim single_cycle/sims/tb_top_module.v single_cycle/src/*.v
vvp single_sim
