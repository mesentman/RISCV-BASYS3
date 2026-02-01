# Single-Cycle RISC-V Processor on FPGA

A fully functional 32-bit RISC-V processor core implemented in Verilog and synthesized on a Digilent Basys 3 FPGA board. This processor executes a subset of the RV32I instruction set and successfully performs arithmetic operations on physical hardware.

![Board Demo](https://github.com/user-attachments/assets/eb9f32a9-2a1e-4ff6-80eb-c69f09df09f1)
*(You can see in the video it first calcuates 5 in binary then 3 then adds the two numbers up to get 8)*

## 🚀 Features
* **Architecture:** 32-bit Single-Cycle RISC-V (Harvard Architecture).
* **ISA Subset:** RV32I (ADD, ADDI, BEQ, LW, SW, etc.).
* **Hardware Output:** Mapped ALU results to board LEDs for visual debugging.
* **Clock Management:** Custom Clock Divider to slow the 100MHz system clock to 1Hz for human-observable execution steps.

## 🛠️ Hardware & Tools
* **FPGA Board:** Digilent Basys 3 (Artix-7 XC7A35T).
* **Language:** Verilog HDL.
* **Synthesis Tool:** Xilinx Vivado 2023.
* **Simulation:** Vivado Simulator (XSim).

## 🧩 Modules Overview
The design follows a modular structure connecting the Data Path and Control Unit:
1.  **Program Counter (PC):** Handles instruction fetching and branching logic.
2.  **Instruction Memory:** Read-only memory initializing the machine code.
3.  **Register File:** 32x32-bit registers (x0 hardwired to 0).
4.  **ALU & Decoder:** Performs arithmetic/logical operations and generates Zero flags.
5.  **Data Memory:** RAM for Load/Store operations.
6.  **Control Unit:** Decodes opcodes to drive MUXs and write enables.
7.  **Clock Divider:** Reduces 100MHz input to 1Hz for real-time visualization.

## 📸 Simulation Results
Verified the data path using Vivado simulation waveforms before synthesis.

![Simulation Waveform](path_to_simulation_screenshot.png)
*Waveform showing the register file updating: x1=5, x2=3, x3=8.*

## 💻 How to Run
1.  Clone this repository.
2.  Open **Vivado** and create a new project targeting the **Basys 3**.
3.  Add all `.v` files from the `src` folder.
4.  Add the `Basys3_Master.xdc` constraints file.
5.  Run **Synthesis**, **Implementation**, and **Generate Bitstream**.
6.  Program the device via USB.

## 📝 Test Program
The processor is currently hardcoded with this assembly sequence to demonstrate functionality:

```assembly
addi x1, x0, 5    ; Load 5 into register x1
addi x2, x0, 3    ; Load 3 into register x2
add  x3, x1, x2   ; x3 = 5 + 3 = 8
