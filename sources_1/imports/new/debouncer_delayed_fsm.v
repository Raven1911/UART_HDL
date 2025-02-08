`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2024 11:42:14 PM
// Design Name: 
// Module Name: debouncer_delayed_fsm
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


module debouncer_delayed_fsm(
    input   clk,
    input   reset_n,
    input   noisy,
    input   timer_done,
    output  timer_reset, debounced
    );
    
    reg [1:0]   state_reg,  state_next;
    parameter   S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    
    //Sequential state register
    always @(posedge clk or negedge reset_n) begin
        if(~reset_n)    state_reg <= S0;
        
        else            state_reg <= state_next;        
       
    end
    
    //datapath circuit
    always @(*) begin
        state_next = state_reg;
        case (state_reg)
            S0: begin
                if(~noisy)  state_next = S0;
                else if(noisy) state_next = S1;
            end
            
            S1: begin
                if(~noisy) state_next = S0;
                else if(noisy & (~timer_done)) state_next = S1;
                else if(noisy & timer_done) state_next = S2;
            end
            
            S2: begin
                if(noisy) state_next = S2;
                else if(~noisy) state_next = S3;        
            end
            
            S3: begin
                if(noisy) state_next = S2;
                else if((~noisy) & (~timer_done)) state_next = S3;
                else if((~noisy) & timer_done) state_next = S0;
            end
            
            default: state_next = S0;
 
        endcase 
    end
    
    assign timer_reset = (state_reg == S0) | (state_reg == S2);
    assign debounced = (state_reg == S2) | (state_reg == S3);
    
    
endmodule
