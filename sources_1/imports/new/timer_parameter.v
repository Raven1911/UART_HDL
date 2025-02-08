`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2024 12:20:43 AM
// Design Name: 
// Module Name: timer_parameter
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


module timer_parameter
    #(parameter COUNTER_VALUE = 'd255)(
    input clk,
    input reset_n,
    input enable,
   
    output done
    );
    
    localparam BITS = $clog2(COUNTER_VALUE);
    
    reg [BITS-1:0] counter = 0;
    
    // before no optimize --> clock up to 40MHz
    // always @(posedge clk, negedge reset_n) begin
    //     if(~reset_n) begin 
    //         Q_reg <= 'b0;
    //         //Q_next <= 'b0;
    //     end
        
    //     else if(enable) 
    //         Q_reg <= Q_next;
    //     else 
    //         Q_reg <= Q_reg;    
    // end
    
    // always @(posedge clk) begin
    //     if(Q_next == COUNTER_VALUE || (~reset_n)) 
    //         Q_next <= 'b0;
    //     else if(enable)
    //         Q_next <= Q_next + 1;
    // end

    // Affter  optimize --> clock up to 200MHz
    always @(posedge clk or negedge reset_n)begin
        if(~reset_n)begin
            counter <= 'b0;
        end

        else if (counter == COUNTER_VALUE) begin
            counter <= 'b0;
        end

        else if (enable) begin
            counter <= counter + 1;
        end

    end
    
    assign done = (counter == COUNTER_VALUE) ? 1 : 0;
    
endmodule
