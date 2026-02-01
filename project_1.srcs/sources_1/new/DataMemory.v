`timescale 1ns / 1ps

module DataMemory(
    input clk,
    input MemWrite,            // Enable write
    input MemRead,             // Enable read (optional in FPGA, usually just read always)
    input [31:0] Address,      // Address from ALU
    input [31:0] WriteData,    // Data from Register File (ReadData2)
    output [31:0] ReadData     // Data going back to Register File
    );

    // 64 Words of RAM
    reg [31:0] RAM [63:0];

    // Read Logic (Asynchronous usually, or Synchronous)
    // We mask the address to fit our small 64-word memory
    assign ReadData = RAM[Address[31:2] & 6'b111111];

    // Write Logic (Synchronous)
    always @(posedge clk) begin
        if (MemWrite) begin
            RAM[Address[31:2] & 6'b111111] <= WriteData;
        end
    end
endmodule