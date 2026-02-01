
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2026 11:03:04 AM
// Design Name: 
// Module Name: RISCV-TB
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

module RISCV_TB;

    // Inputs to the CPU
    reg clk;
    reg reset;

    // Outputs from the CPU (for debugging)
    wire [31:0] WriteData;
    wire [31:0] DataAddr;

    // Instantiate the Unit Under Test (UUT)
    RISCV_Top uut (
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAddr(DataAddr)
    );

    // Clock Generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;

        // Wait 20 ns for global reset to finish
        #20;
        reset = 0; // Release reset, CPU starts running!

        // Let it run for 200ns
        #200;
        
        // Stop simulation
        $finish;
    end
      
endmodule