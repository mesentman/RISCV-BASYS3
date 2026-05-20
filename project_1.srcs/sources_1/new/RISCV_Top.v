`timescale 1ns / 1ps

module RISCV_Top(
    input clk,              
    input reset,            
    output [15:0] DataAddr,
    input wire sw_stall 
    );

    
    wire enable_tick;       
    wire [31:0] PC_In, PC_Out;
    wire [31:0] Instr;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ImmExt;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] Result;
    wire Zero;
    
    wire MemWrite, MemRead, ALUSrc, RegWrite, MemToReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    
    ClockDivider clk_div (
        .clk(clk),
        .reset(reset),
        .enable_tick(enable_tick)
    );

    wire [31:0] PCPlus4 = PC_Out + 4;
    wire [31:0] PCTarget = PC_Out + ImmExt;
    wire PCSrc = Branch & Zero;
    assign PC_In = (PCSrc) ? PCTarget : PCPlus4;

    ProgramCounter pc_module (
        .clk(clk),         
        .reset(reset),
        .en(enable_tick),
        .stall(sw_stall),   
        .NextPC(PC_In),
        .PC(PC_Out)
    );

    InstructionMemory imem (
        .Address(PC_Out),
        .Instruction(Instr)
    );

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
    
    wire RegWire_gated = RegWrite & ~sw_stall;
    
    RegisterFile reg_file (
        .clk(clk),          
        .en(enable_tick),   
        .RegWrite(RegWrite_gated),
        .ReadReg1(Instr[19:15]),
        .ReadReg2(Instr[24:20]),
        .WriteReg(Instr[11:7]),
        .WriteData(Result),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ImmGen imm_gen (
        .Instruction(Instr),
        .ImmExt(ImmExt)
    );

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

    DataMemory dmem (
        .clk(clk),       
        .MemWrite(MemWrite & enable_tick & ~sw_stall), 
        .MemRead(MemRead),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(ReadData)
    );

    assign Result = (MemToReg) ? ReadData : ALUResult;
    
    assign DataAddr = ALUResult[15:0];

endmodule