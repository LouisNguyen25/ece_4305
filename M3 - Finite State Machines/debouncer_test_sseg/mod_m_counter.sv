`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2021 03:47:15 AM
// Design Name: 
// Module Name: mod_m_counter
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


module mod_m_counter
    #(parameter M = 50_000_000)
    (
        input logic clk, reset,
        input [$clog2(M)-1:0] delay_input,                      // Input delay from synch_rom file
        output logic delay_tick
    );
    
    // largest delay of 500ms
    // assuming clk is 100 MHz (clock period of 10ns)
    // 500ms / 10ns in ns = 50_000_000
    localparam N = $clog2(50_000_000);                          // Use largest delay of 500ms to define our variable size

    // signal declaration
    logic [N-1:0] r_next, r_reg;
        
    // body
    // [1] Register segment
    always_ff @(posedge clk or posedge reset)    
    begin
        if(reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end
    
    // [2] next-state logic segment
    assign r_next = (r_reg > delay_input)? 0: r_reg + 1;          // Changed from lecture example == to > so that if delay_input goes lower than r_reg
                                                                  // the count will reset accordingly
    
    assign delay_tick = (r_reg == delay_input - 1) ? 1'b1: 1'b0;                  
    
endmodule
