`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 11:47:23 AM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb();


    localparam T =  10; // period


    reg clk, reset_n;

    //GPIO confi uart-0
    reg       rd_uart, wr_uart, rx;
    reg [7:0] w_data;
    reg [10:0] dvsr;

    wire tx_full, rx_empty;
    wire tx;
    wire [7:0] r_data;

    always @(tx) begin
        rx = tx;
    end

    //mudule decalation////
    //uart_0
    uart_unit
    #(  .DBIT(8),       // databit
        .SB_TICK(16),   // tick for stop bits
        .FIFO_W(2)      // addr bits of FIFO
    ) uart_0 
    (
        .clk(clk),
        .reset_n(reset_n),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .rx(rx),
        .w_data(w_data),
        .dvsr(dvsr),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .tx(tx),
        .r_data(r_data)
    );
    

    //


    /////START/////
    initial begin
        clk = 0;
        forever begin
            #(T/2) clk = ~clk;
        end
  
    end

    //setup data tx uart
    initial begin
        reset_n = 0;
        repeat(1) @(negedge clk);
        reset_n = 1;


        #(T*10)
        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd1;
        repeat(1) @(negedge clk);
        wr_uart = 0;
        

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd2;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd3;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd4;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(1000000) @(negedge clk);
        wr_uart = 0;  


        ////
        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd7;
        repeat(1) @(negedge clk);
        wr_uart = 0;
        

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd8;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd9;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(1) @(negedge clk);
        wr_uart = 1;
        w_data = 8'd10;
        repeat(1) @(negedge clk);
        wr_uart = 0;

        repeat(3) @(negedge clk);
        wr_uart = 0;  
        

    end

    initial begin
        rd_uart = 0;

        dvsr = 'd650;
        #100000000000
        $stop;
    end



endmodule
