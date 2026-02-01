`timescale 1ns / 1ps

module RegisterFile(
    input clk,                  // Clock signal
    input RegWrite,             // Control signal: 1 = Allow write, 0 = Read only
    input [4:0] ReadReg1,       // Address of first register to read (Instruction [19:15])
    input [4:0] ReadReg2,       // Address of second register to read (Instruction [24:20])
    input [4:0] WriteReg,       // Address of register to write (Instruction [11:7])
    input [31:0] WriteData,     // Data to write into the register
    output [31:0] ReadData1,    // Data output 1
    output [31:0] ReadData2     // Data output 2
    );

    // Create the bank of 32 registers (32 bits wide each)
    reg [31:0] registers [31:0];
    integer i;

    // Initialize registers to 0 (optional but helps in simulation)
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // READ OPERATIONS (Combinational)
    // We read immediately, no clock edge required.
    // Note: If address is 0, we hardcode output to 0.
    assign ReadData1 = (ReadReg1 == 0) ? 32'b0 : registers[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 32'b0 : registers[ReadReg2];

    // WRITE OPERATION (Synchronous)
    // We only write on the rising edge of the clock.
    always @(posedge clk) begin
        if (RegWrite && WriteReg != 0) begin
            registers[WriteReg] <= WriteData;
        end
    end

endmodule