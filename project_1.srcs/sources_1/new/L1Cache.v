`timescale 1ns / 1ps

module L1Cache (
    input wire clk,
    input wire reset,
    
    input wire [31:0] cpu_addr,
    output wire [31:0] cpu_instr,
    output wire stall_cpu,  
    
    output reg [31:0] mem_addr,
    input wire [31:0] mem_instr,
    input wire mem_ready
);

    parameter ENTRIES = 256;
    
    reg [31:0] data_array [0:ENTRIES-1];
    reg [21:0] tag_array  [0:ENTRIES-1];
    reg        valid_array [0:ENTRIES-1];
    
    localparam IDLESTATE = 1'b0;
    localparam STATE_FETCH = 1'b1;
    
    reg state;
    reg [31:0] miss_addr;
    integer i;

    wire [7:0]  index = cpu_addr[9:2];
    wire [21:0] tag   = cpu_addr[31:10];
    
    wire hit = valid_array[index] && (tag_array[index] == tag);

    assign cpu_instr = hit ? data_array[index] : 32'h00000013;
    assign stall_cpu = !hit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            state <= IDLESTATE;
            mem_addr <= 0;
            miss_addr <= 0;
            for (i = 0; i < ENTRIES; i = i + 1) begin
                valid_array[i] <= 0;
            end
        end 
        else begin
            case (state)
                IDLESTATE: begin
                    if (!hit) begin
                        miss_addr <= cpu_addr;
                        mem_addr <= cpu_addr;
                        state <= STATE_FETCH;
                    end
                end

                STATE_FETCH: begin
                    // mem_addr was registered on the preceding clock edge.
                    // mem_ready means mem_instr is valid for this request.
                    if (mem_ready) begin
                        data_array[miss_addr[9:2]] <= mem_instr;
                        tag_array[miss_addr[9:2]] <= miss_addr[31:10];
                        valid_array[miss_addr[9:2]] <= 1'b1;
                        state <= IDLESTATE;
                    end
                end
            endcase
        end
    end
endmodule
