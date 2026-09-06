# 32-Bit Single-Cycle RISC-V Processor in VHDL

A hardware implementation of a single-cycle 32-bit RISC-V processor datapath and control unit, designed and modeled using **VHDL**.

## Features & Architecture
- **Architecture:** Single-Cycle RV32I Core.
- **Instruction Support:** 
  - R-type (e.g., `ADD`, `SUB`, `AND`, `OR`, `SLT`)
  - I-type (e.g., `ADDI`, `LW`)
  - S-type (e.g., `SW`)
  - B-type (e.g., `BEQ`, `BNE`)
- **Key Modules:**
  - **Program Counter (PC) & Instruction Memory:** Sequential fetching and branch handling.
  - **Register File:** 32 general-purpose 32-bit registers (with `x0` hardwired to zero).
  - **ALU (Arithmetic Logic Unit):** Core execution for arithmetic, logic, and comparison operations.
  - **Control Unit & ALU Decoder:** Single-cycle instruction decoding and control signal generation.
  - **Data Memory:** Byte-addressable RAM interface for load/store instructions.

## Tools & Technologies
- **Hardware Description Language:** VHDL
- **EDA & Synthesis Tool:** AMD/Xilinx Vivado Design Suite
- **Simulation & Waveform Viewer:** Vivado Simulator (XSim)

## Repository Structure
- **src:** VHDL source code (Datapath, Control Unit, ALU, etc.)
- **testbench:** Testbench files for simulation and validation
- **constraints:** Timing constraints (.xdc)
- **docs:** Schematics, architectural diagrams and documentation
