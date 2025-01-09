`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 01:23:59 PM
// Design Name: 
// Module Name: buad_gen_tb
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


module buad_gen_tb();

    localparam T = 10;

    reg           clk, reset_n;
    reg   [10:0]  dvsr;

    wire          tick;



    buad_gen uut(
    .clk(clk),
    .reset_n(reset_n),
    .dvsr(dvsr),

    .tick(tick)
    );

    initial begin
        clk = 0;
        dvsr = 'd651;
        forever begin
            #(T/2) clk = ~clk;
        end
    end
    initial begin
        reset_n = 0;
        repeat(1) @(negedge clk);
        reset_n = 1;
    end



endmodule
