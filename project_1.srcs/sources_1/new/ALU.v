`timescale 1ns / 1ps

module ALU(
    input [31:0] A,          // First operand
    input [31:0] B,          // Second operand
    input [3:0] ALUControl,  // Control signal to choose operation
    output reg [31:0] Result,// Result of the operation
    output Zero              // High if Result is 0 (for branches)
    );

    // Assign the Zero flag: true if Result is exactly 0
    assign Zero = (Result == 0);

    // The logic block
    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;       // AND
            4'b0001: Result = A | B;       // OR
            4'b0010: Result = A + B;       // ADD (and ADDI, Load, Store addresses)
            4'b0110: Result = A - B;       // SUB (and BEQ comparisons)
            4'b0111: Result = (A < B) ? 32'b1 : 32'b0; // SLT (Set Less Than)
            4'b1100: Result = ~(A | B);    // NOR (Optional, helpful for debugging)
            4'b0011: Result = A ^ B;       // XOR
            4'b0100: Result = A << B;      // SLL (Shift Left Logical)
            4'b0101: Result = A >> B;      // SRL (Shift Right Logical)
            default: Result = 32'b0;       // Default case to prevent latches
        endcase
    end
endmodule