`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 12:24:24 AM
// Design Name: 
// Module Name: uart_axi_lite_tb
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

module uart_axi_lite_tb;
    localparam T = 10; // clock period in ns
    localparam BAUD_RATE = 9600; // Baud rate in bps
    localparam CLK_FREQ = 100_000_000; // Clock frequency in Hz
    localparam BIT_PERIOD = 10417;//CLK_FREQ / BAUD_RATE; // Clock cycles per UART bit

    // Parameters
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter FIFO_DEPTH_BIT = 8;
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Signals
    reg clk;
    reg resetn;

    // AXI-Lite Write Address Channels
    reg [ADDR_WIDTH-1:0] i_axi_awaddr;
    reg i_axi_awvalid;
    wire o_axi_awready;

    // AXI-Lite Write Data Channel
    reg [DATA_WIDTH-1:0] i_axi_wdata;
    reg [3:0] i_axi_wstrb;
    reg i_axi_wvalid;
    wire o_axi_wready;

    // AXI-Lite Write Response Channels
    wire o_axi_bvalid;
    reg i_axi_bready;

    // AXI-Lite Read Address Channels
    reg [ADDR_WIDTH-1:0] i_axi_araddr;
    reg i_axi_arvalid;
    wire o_axi_arready;

    // AXI-Lite Read Data Channel
    wire [DATA_WIDTH-1:0] o_axi_rdata;
    wire o_axi_rvalid;
    reg i_axi_rready;

    // UART Signals
    wire tx0;
    reg  rx0;

    // Instantiate the DUT (Device Under Test)
    uart_axi_lite #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH_BIT(FIFO_DEPTH_BIT)
    ) dut (
        .clk(clk),
        .resetn(resetn),
        .i_axi_awaddr(i_axi_awaddr),
        .i_axi_awvalid(i_axi_awvalid),
        .o_axi_awready(o_axi_awready),
        .i_axi_wdata(i_axi_wdata),
        .i_axi_wstrb(i_axi_wstrb),
        .i_axi_wvalid(i_axi_wvalid),
        .o_axi_wready(o_axi_wready),
        .o_axi_bvalid(o_axi_bvalid),
        .i_axi_bready(i_axi_bready),
        .i_axi_araddr(i_axi_araddr),
        .i_axi_arvalid(i_axi_arvalid),
        .o_axi_arready(o_axi_arready),
        .o_axi_rdata(o_axi_rdata),
        .o_axi_rvalid(o_axi_rvalid),
        .i_axi_rready(i_axi_rready),
        .tx0(tx0),
        .rx0(rx0)
    );

    // Clock generation
    initial begin
        clk = 0;
        
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Reset generation
    initial begin
        resetn = 0;
        #20;
        resetn = 1;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        i_axi_awaddr = 0;
        i_axi_awvalid = 0;
        i_axi_wdata = 0;
        i_axi_wstrb = 4'b1111; // Enable all bytes
        i_axi_wvalid = 0;
        i_axi_bready = 0;
        i_axi_araddr = 0;
        i_axi_arvalid = 0;
        i_axi_rready = 0;
        rx0 = 1; // UART idle state

        // Wait for reset to complete
        @(posedge resetn);
        #100;

        // Test 1: Write to DVSR register (address 0x01)
        axi_lite_write(32'h00000001, 32'd650); // Set baud rate divisor (e.g., 325 for 9600 baud at 100 MHz)

        // Test 2: Write data to UART TX (address 0x02)
        axi_lite_write(32'h00000002, 32'h000000ff); // Write 0x55 to TX
        axi_lite_write(32'h00000002, 32'h00000045); // Write 0x55 to TX
        axi_lite_write(32'h00000002, 32'h00000035); // Write 0x55 to TX
        axi_lite_write(32'h00000002, 32'h00000025); // Write 0x55 to TX

        #1000
        send_uart_frame(8'h08); // Send 0x08
        repeat(100) @(negedge clk);
        send_uart_frame(8'h01); // Send 0x01

        // // Test 3: Read UART status and data (address 0x03)
        #100
        axi_lite_read(32'h00000003);
        #100
        axi_lite_read(32'h00000003);

        // // Simulate RX data (0xAA)
        // send_uart_rx(8'hAA);

        // // Test 4: Read received data (address 0x03)
        // #1000;
        // axi_lite_read(32'h00000003);

        // End simulation
        #10000000;
        $finish;
    end

    // AXI-Lite Write Task
    task axi_lite_write;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;
        begin
            @(posedge clk);
            // Write Address Phase
            i_axi_awaddr = addr;
            i_axi_awvalid = 1;
            wait(o_axi_awready);
            @(posedge clk);
            i_axi_awvalid = 0;

            // Write Data Phase
            i_axi_wdata = data;
            i_axi_wvalid = 1;
            wait(o_axi_wready);
            @(posedge clk);
            i_axi_wvalid = 0;

            // Write Response Phase
            i_axi_bready = 1;
            wait(o_axi_bvalid);
            @(posedge clk);
            i_axi_bready = 0;
        end
    endtask

    // AXI-Lite Read Task
    task axi_lite_read;
        input [ADDR_WIDTH-1:0] addr;
        begin
            @(posedge clk);
            // Read Address Phase
            i_axi_araddr = addr;
            i_axi_arvalid = 1;
            wait(o_axi_arready);
            @(posedge clk);
            i_axi_arvalid = 0;

            // Read Data Phase
            i_axi_rready = 1;
            wait(o_axi_rvalid);
            @(posedge clk);
            $display("Read Data at address %h: %h", addr, o_axi_rdata);
            i_axi_rready = 0;
        end
    endtask

    // UART RX Simulation Task (8N1 format: 1 start bit, 8 data bits, 1 stop bit)
     // Task to send UART frame
    task send_uart_frame;
        input [7:0] data;
        integer i;
        begin
            // Start bit (logic 0)
            rx0 = 0;
            #(BIT_PERIOD * T);

            // Send data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx0 = data[i];
                #(BIT_PERIOD * T);
            end

            // Stop bit (logic 1)
            rx0 = 1;
            #(BIT_PERIOD * T);
        end
    endtask

    // Monitor TX output
    initial begin
        $monitor("Time=%0t | TX=%b | RX=%b", $time, tx0, rx0);
    end

endmodule
