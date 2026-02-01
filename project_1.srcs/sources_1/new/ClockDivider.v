
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2026 11:47:24 AM
// Design Name: 
// Module Name: ClockDivider
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

module ClockDivider(
    input clk,      // 100 MHz clock from board
    input reset,
    output reg slow_clk // 1 Hz clock (1 second period)
    );

    reg [27:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end else begin
            // Count to 50 million (0.5 seconds) then toggle
            // 50,000,000 cycles * 10ns = 0.5 seconds
            if (counter == 50000000) begin
                counter <= 0;
                slow_clk <= ~slow_clk; // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

