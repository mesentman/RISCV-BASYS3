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
        // This is where you load your program!
        // You can load a hex file using $readmemh, or hardcode simpler tests.
        
        // Example: Hardcoding a tiny program
        // ADDI x1, x0, 5  (x1 = 5) -> Hex: 00500093
        memory[0] = 32'h00500093; 
        
        // ADDI x2, x0, 3  (x2 = 3) -> Hex: 00300113
        memory[1] = 32'h00300113;
        
        // ADD x3, x1, x2  (x3 = 8) -> Hex: 002081B3
        memory[2] = 32'h002081B3;
        
        // Loop forever here (Branch to self) -> Hex: 00000063
        memory[3] = 32'h00000063;
    end

    // Read the instruction. 
    // We ignore the bottom 2 bits of the address ([1:0]) for word alignment.
    assign Instruction = memory[Address[31:2]];

endmodule