`timescale 1ns / 1ps

module ClockDivider #(
    parameter integer MAX_COUNT = 16_777_215
)(
    input clk,
    input reset,
    output reg enable_tick
    );

    
    reg [26:0] count; //
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            enable_tick <= 1'b0;
        end else begin
            if (count == MAX_COUNT) begin
                count <= 0;
                enable_tick <= 1'b1; 
            end else begin
                count <= count + 1;
                enable_tick <= 1'b0; 
            end
        end
    end
endmodule
