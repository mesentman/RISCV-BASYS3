`timescale 1ns / 1ps

module tb_L1Cache();

    // 1. Inputs to the Cache (Registers)
    reg clk;
    reg reset;
    reg [31:0] cpu_addr;
    reg [31:0] mem_instr;
    reg mem_ready;

    // 2. Outputs from the Cache (Wires)
    wire [31:0] cpu_instr;
    wire stall_cpu;
    wire [31:0] mem_addr;

    // 3. Instantiate the Cache
    L1Cache uut (
        .clk(clk),
        .reset(reset),
        .cpu_addr(cpu_addr),
        .cpu_instr(cpu_instr),
        .stall_cpu(stall_cpu),
        .mem_addr(mem_addr),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready)
    );

    // 4. Generate a 100MHz Clock
    always #5 clk = ~clk;

    // 5. The Test Sequence
    initial begin
        #500;
        $fatal(1, "Cache test timed out");
    end

    initial begin
        // Initialize everything
        clk = 0;
        reset = 1;
        cpu_addr = 32'h00000000;
        mem_instr = 32'h00000000;
        mem_ready = 1; // Start with "instant" memory

        // Hold reset for a few cycles to clear valid_array
        #20;
        reset = 0;
        #10;

        $display("--- TEST 1: First Request (Compulsory Miss) ---");
        // CPU asks for instruction at address 0
        cpu_addr = 32'h00000000; 
        // Fake Memory will provide this dummy instruction:
        mem_instr = 32'hAAAA1111; 
        
        // Wait for the cache to finish its state machine
        wait (stall_cpu === 1'b0);
        #1;
        if (cpu_instr !== 32'hAAAA1111 || mem_addr !== 0)
            $fatal(1, "First fill failed: instr=%h addr=%h", cpu_instr, mem_addr);
        #9;

        $display("--- TEST 2: Second Request (Another Miss) ---");
        cpu_addr = 32'h00000004; 
        mem_instr = 32'hBBBB2222;
        #1;
        if (stall_cpu !== 1) $fatal(1, "Address 4 should miss");
        wait (stall_cpu === 1'b0);
        #1;
        if (cpu_instr !== 32'hBBBB2222 || mem_addr !== 4)
            $fatal(1, "Second fill failed: instr=%h addr=%h", cpu_instr, mem_addr);
        #9;

        $display("--- TEST 3: Loop Back to Address 0 (HIT!) ---");
        // We ask for Address 0 again. 
        // Because it's in the cache, stall_cpu should NEVER go high!
        cpu_addr = 32'h00000000; 
        #1;
        if (stall_cpu !== 0 || cpu_instr !== 32'hAAAA1111)
            $fatal(1, "Address 0 hit failed");
        #9;

        $display("--- TEST 4: Loop Back to Address 4 (HIT!) ---");
        cpu_addr = 32'h00000004;
        #1;
        if (stall_cpu !== 0 || cpu_instr !== 32'hBBBB2222)
            $fatal(1, "Address 4 hit failed");
        #9;

        $display("--- TEST 5: Delayed Memory Test ---");
        // Now let's pretend Main Memory is slow (mem_ready = 0)
        mem_ready = 0;
        cpu_addr = 32'h00000008; // New address (Miss)
        mem_instr = 32'hCCCC3333;
        
        // Wait 3 clock cycles while memory is "thinking"
        #30;
        if (stall_cpu !== 1 || mem_addr !== 8)
            $fatal(1, "Delayed memory did not hold the request");
        mem_ready = 1; // Memory is finally ready!
        wait (stall_cpu === 1'b0);
        #1;
        if (cpu_instr !== 32'hCCCC3333)
            $fatal(1, "Delayed fill returned %h", cpu_instr);

        // Address 0x400 conflicts with address 0 in this direct-mapped cache.
        #9;
        cpu_addr = 32'h00000400;
        mem_instr = 32'hDDDD4444;
        #1;
        if (stall_cpu !== 1) $fatal(1, "Conflicting address should miss");
        wait (stall_cpu === 1'b0);
        #1;
        if (cpu_instr !== 32'hDDDD4444)
            $fatal(1, "Conflicting-line refill failed");
        cpu_addr = 0;
        #1;
        if (stall_cpu !== 1)
            $fatal(1, "Old line should miss after replacement");

        $display("PASS: misses, hits, delayed response, and tag replacement");
        $finish;
    end

endmodule
