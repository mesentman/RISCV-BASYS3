`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2026 10:55:57 AM
// Design Name: 
// Module Name: InstructionMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module InstructionMemory(
    input [31:0] Address,        // Input comes from PC
    output [31:0] Instruction    // The 32-bit machine code
    );

    // Create a memory of 64 words (enough for small programs)
    reg [31:0] memory [63:0];

    initial begin
        // memory[0]: addi x1, x0, 0   -> Clear x1 (our LED counter)
        memory[0] = 32'h00000093; 
        
        // memory[1]: addi x2, x0, 1   -> Load 1 into x2 (our increment value)
        memory[1] = 32'h00100113;
        
        // memory[2]: add x1, x1, x2   -> x1 = x1 + x2 (Increment counter)
        memory[2] = 32'h002080B3;
        
        // memory[3]: jal x0, -4       -> Jump back to memory[2] (PC resets to 8)
        // This keeps adding 1 to x1 over and over again!
        memory[3] = 32'hffdff06f;
    end

    
    assign Instruction = memory[Address[31:2]];

endmodule
