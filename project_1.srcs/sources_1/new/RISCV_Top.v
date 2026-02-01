`timescale 1ns / 1ps

module RISCV_Top(
    input clk,              // 100MHz Board Clock
    input reset,            // Button
    output [15:0] DataAddr  // LEDs
    );

    // --- WIRES ---
    wire slow_clk;          // The new 1Hz clock from our divider
    
    wire [31:0] PC_In, PC_Out;
    wire [31:0] Instr;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ImmExt;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] Result;
    wire Zero;
    
    // Control Signals
    wire MemWrite, MemRead, ALUSrc, RegWrite, MemToReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    // --- NEW: CLOCK DIVIDER INSTANCE ---
    ClockDivider clk_div (
        .clk(clk),
        .reset(reset),
        .slow_clk(slow_clk)
    );

    // --- 1. PROGRAM COUNTER (Uses slow_clk) ---
    wire [31:0] PCPlus4 = PC_Out + 4;
    wire [31:0] PCTarget = PC_Out + ImmExt;
    wire PCSrc = Branch & Zero;
    assign PC_In = (PCSrc) ? PCTarget : PCPlus4;

    ProgramCounter pc_module (
        .clk(slow_clk),       // <--- CONNECTED TO SLOW CLOCK
        .reset(reset),
        .NextPC(PC_In),
        .PC(PC_Out)
    );

    // --- 2. INSTRUCTION MEMORY ---
    InstructionMemory imem (
        .Address(PC_Out),
        .Instruction(Instr)
    );

    // --- 3. CONTROL UNIT ---
    ControlUnit control (
        .Opcode(Instr[6:0]),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    // --- 4. REGISTER FILE (Uses slow_clk) ---
    RegisterFile reg_file (
        .clk(slow_clk),       // <--- CONNECTED TO SLOW CLOCK
        .RegWrite(RegWrite),
        .ReadReg1(Instr[19:15]),
        .ReadReg2(Instr[24:20]),
        .WriteReg(Instr[11:7]),
        .WriteData(Result),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // --- 5. IMMEDIATE GENERATOR ---
    ImmGen imm_gen (
        .Instruction(Instr),
        .ImmExt(ImmExt)
    );

    // --- 6. ALU & MUX ---
    assign SrcB = (ALUSrc) ? ImmExt : ReadData2;

    ALUDecoder alu_dec (
        .ALUOp(ALUOp),
        .Funct3(Instr[14:12]),
        .Funct7(Instr[30]),
        .Opcode(Instr[6:0]),
        .ALUControl(ALUControl)
    );

    ALU alu (
        .A(ReadData1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );

    // --- 7. DATA MEMORY (Uses slow_clk) ---
    DataMemory dmem (
        .clk(slow_clk),       // <--- CONNECTED TO SLOW CLOCK
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(ReadData)
    );

    // --- 8. WRITE BACK MUX ---
    assign Result = (MemToReg) ? ReadData : ALUResult;
    
    // --- OUTPUT ASSIGNMENT ---
    assign DataAddr = ALUResult[15:0];

endmodule