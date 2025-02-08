`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 04:03:34 PM
// Design Name: 
// Module Name: uart_test_demo_tb
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


module uart_test_demo_tb(
    );

    localparam T = 10; // clock period in ns
    localparam BAUD_RATE = 9600; // Baud rate in bps
    localparam CLK_FREQ = 100_000_000; // Clock frequency in Hz
    localparam BIT_PERIOD = 10417;//CLK_FREQ / BAUD_RATE; // Clock cycles per UART bit

    // Testbench signals
    reg clk, reset_n, rx;
    reg btn;
    wire tx_full, rx_empty;
    wire tx;

    // Instantiate the UART module
    uart_test_demo uut (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .btn(btn),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .tx(tx)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(T/2) clk = ~clk;
    end

    // Initialize signals
    initial begin
        reset_n = 0;
        btn = 0;
        rx = 1; // Idle state for UART

        // Apply reset
        repeat(5) @(negedge clk);
        reset_n = 1;
        repeat(1000) @(negedge clk);
        // Send data frames
        send_uart_frame(8'h08); // Send 0x08
        repeat(100) @(negedge clk);
        send_uart_frame(8'h01); // Send 0x01

        // Wait and finish
        repeat(100000) @(negedge clk);
        btn = 1;
        repeat(1000) @(negedge clk);
        btn = 0;

        repeat(1000) @(negedge clk);
        btn = 1;
        repeat(1000) @(negedge clk);
        btn = 0;


        repeat(10000) @(negedge clk);
        $finish;
    end

    // Task to send UART frame
    task send_uart_frame;
        input [7:0] data;
        integer i;
        begin
            // Start bit (logic 0)
            rx = 0;
            #(BIT_PERIOD * T);

            // Send data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD * T);
            end

            // Stop bit (logic 1)
            rx = 1;
            #(BIT_PERIOD * T);
        end
    endtask
endmodule
