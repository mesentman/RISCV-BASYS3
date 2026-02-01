`timescale 1ns / 1ps

module ProgramCounter(
    input clk,
    input reset,                // Active high reset (usually the center button)
    input [31:0] NextPC,        // The address of the NEXT instruction
    output reg [31:0] PC        // The address of the CURRENT instruction
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'b0;        // Reset to address 0 on start
        else
            PC <= NextPC;       // Otherwise, move to the next address
    end
endmodule