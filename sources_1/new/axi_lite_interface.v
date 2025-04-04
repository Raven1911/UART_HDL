`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 09:43:30 AM
// Design Name: 
// Module Name: axi_lite_interface
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




module axi_lite_interface #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(  
    input clk,
    input resetn,

    //AXI-Lite Write Address Channels
    input [ADDR_WIDTH-1:0] i_axi_awaddr,
    input i_axi_awvalid,
    output reg o_axi_awready,

    //AXI-Lite Write Data Channel
    input [DATA_WIDTH-1:0] i_axi_wdata,
    input [3:0] i_axi_wstrb,
    input i_axi_wvalid,
    output reg o_axi_wready,

    //AXI-Lite Write Response Channels
    output reg o_axi_bvalid,
    input i_axi_bready,

    //AXI-Lite Read Address Channels
    input [ADDR_WIDTH-1:0] i_axi_araddr,
    input i_axi_arvalid,
    output reg o_axi_arready,

    //AXI4-Lite Read Data Channel
    output reg [DATA_WIDTH-1:0] o_axi_rdata,
    output reg o_axi_rvalid,
    input i_axi_rready,

    //channel for slave
    output reg  [3:0] o_wen,
    output reg  [ADDR_WIDTH-1:0] o_addr_w,
    output wire [ADDR_WIDTH-1:0] o_addr_r,             
    output reg  [DATA_WIDTH-1:0] o_data_w,
    input  wire [DATA_WIDTH-1:0] i_data_r,
    output reg                   o_valid_w,
    output reg                   o_valid_r
    );

    //state declaration

    // Write channel FSM
    localparam W_ADDRESS   = 2'b00;
    localparam W_WRITE     = 2'b01;
    localparam W_RESPONSE  = 2'b10;

    // read channel FSM
    localparam R_ADDRESS   = 2'b00;
    localparam R_READ      = 2'b01;

    reg [1:0] W_state, R_state; // Fsm state

    //signals to connect to dmem
    // reg [3:0] o_wen;
    // reg [ADDR_WIDTH-1:0] o_addr_w;
    // wire [ADDR_WIDTH-1:0] o_addr_r;                
    // reg [DATA_WIDTH-1:0] o_data_w;
    // wire [DATA_WIDTH-1:0] i_data_r;


    //Write channel FSM
    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            o_axi_awready <= 0;
            o_axi_wready  <= 0;
            o_axi_bvalid  <= 0;
            o_valid_w     <= 0;
            W_state       <= W_ADDRESS;
            o_wen           <= 4'b0000;
            o_addr_w        <= 0;
            o_data_w        <= 0;
        end
        else begin
            case (W_state)
                W_ADDRESS: begin
                    o_axi_bvalid  <= 0;
                    o_valid_w     <= 0; // slave
                    if (i_axi_awvalid) begin
                        o_axi_awready <= 1;
                        o_addr_w        <= i_axi_awaddr; // Lưu địa chỉ ghi
                        W_state       <= W_WRITE;
                    end
                     
                end
                W_WRITE: begin
                    o_axi_awready <= 0;
                    if (i_axi_wvalid) begin
                        o_axi_wready  <= 1;
                        o_wen           <= i_axi_wstrb;
                        o_data_w        <= i_axi_wdata;
                        W_state       <= W_RESPONSE;
                         
                    end
          
                    
                end
                W_RESPONSE: begin
                    o_axi_wready  <= 0;
                    o_wen           <= 4'b0000;
                    if (i_axi_bready) begin     
                        o_axi_bvalid  <= 1;
                        o_valid_w     <= 1;
                        W_state       <= W_ADDRESS;
                    end

                end

                default: W_state <= W_ADDRESS;
            endcase
        end
    end


    
    // Read Channel FSM
    always @(posedge clk or negedge resetn) begin
            if (~resetn) begin
                o_axi_arready   <= 0;
                o_axi_rvalid    <= 0;
                o_valid_r       <= 0;
                o_axi_rdata     <= 0;
                R_state         <= R_ADDRESS;
                //o_addr_r          <= 0;
            end

            else begin
                case (R_state)
                    R_ADDRESS: begin
                        o_axi_rvalid    <= 0;
                        o_valid_r       <= 0;
                        if(i_axi_arvalid) begin
                            o_axi_arready   <= 1;
                            
                            R_state         <= R_READ;
                        end
                    end

                    R_READ: begin
                        o_axi_arready   <= 0;
                        if (i_axi_rready) begin
                            o_axi_rvalid    <= 1;
                            o_valid_r       <= 1;
                            o_axi_rdata     <= i_data_r;
                            R_state         <= R_ADDRESS;
                        end
                    end

                    default: R_state <= R_ADDRESS;
                endcase

            end
    end

    assign o_addr_r = i_axi_araddr; //luu dia chi doc
    
endmodule



