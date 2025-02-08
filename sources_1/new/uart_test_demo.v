`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2025 01:31:09 AM
// Design Name: 
// Module Name: uart_test_demo
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


module uart_test_demo(
    clk,
    reset_n,
    rx,
    btn,
    //dvsr,
    tx_full,
    rx_empty,
    tx
    );

    //GPIO
    input clk, reset_n, rx;
    input btn;
    //input [10:0] dvsr;

    output tx_full, rx_empty;
    output tx;



    //signal declaration
    wire btn_deb;
    wire [7:0] data;
    reg val_button;

    //module button debounce
    debouncer_delayed button_debounced1(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(btn),
        
        .debounced(btn_deb),
        .p_edge(),
        .n_edge(),
        .any_edge()
    );

    always @(posedge clk, negedge reset_n) begin
        if (~reset_n) begin
            val_button <= 1'b0;
        end
        else if (rx_empty)begin
            val_button <= 1'b0;
        end

        else begin
            val_button <= btn_deb;
        end

        
    end

    //module declaration
    uart_unit
    #(              .DBIT('d8),       // databit
                    .SB_TICK('d16),   // tick for stop bits
                    .FIFO_W('d2)      // addr bits of FIFO
    ) 
    uart_test(
        .clk(clk),
        .reset_n(reset_n),
        .rd_uart(val_button),
        .wr_uart(val_button),
        .rx(rx),
        .w_data(data),
        .dvsr('d650),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .tx(tx),
        .r_data(data)
    );


endmodule
