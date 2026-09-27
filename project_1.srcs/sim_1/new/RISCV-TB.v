`timescale 1ns / 1ps

module RISCV_TB;

    // Inputs to the CPU
    reg clk;
    reg reset;
    reg sw_stall;

    // Outputs from the CPU (for debugging)
    // FIXED: Changed to 16 bits to perfectly match RISCV_Top
    wire [15:0] DataAddr; 

    // Instantiate the Unit Under Test (UUT)
    RISCV_Top #(.CPU_TICK_CYCLES(6)) uut (
        .clk(clk),
        .reset(reset),
        .sw_stall(sw_stall),
        // FIXED: Removed WriteData
        .DataAddr(DataAddr)
    );

    // Clock Generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        sw_stall = 0;

        // Wait 20 ns for global reset to finish
        #20;
        reset = 0; // Release reset, CPU starts running!

        // Let it run for 2000ns (gives the divided clock time to tick)
        #2000;

        if (uut.reg_file.registers[1] < 2 ||
            uut.reg_file.registers[2] !== 32'd1 ||
            (uut.PC_Out !== 32'd8 && uut.PC_Out !== 32'd12))
            $fatal(1, "Counter loop failed: x1=%h x2=%h PC=%h",
                   uut.reg_file.registers[1],
                   uut.reg_file.registers[2], uut.PC_Out);
        $display("PASS: counter loop, x1=%d", uut.reg_file.registers[1]);
        
        // Stop simulation
        $finish;
    end
      
endmodule
