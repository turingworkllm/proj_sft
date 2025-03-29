// Code your design here
`timescale 1ns / 1ps

module PipelinedDataTransfer #( 
    parameter DATA_WIDTH = 16
)(
    input  wire                  clk,
    input  wire                  reset,
    input  wire [DATA_WIDTH-1:0] sensor_data,
    input  wire                  valid_in,
    output reg  [DATA_WIDTH-1:0] processed_data,
    output reg                   valid_out
);

    reg [DATA_WIDTH-1:0] stage1_data, stage2_data;
    reg stage1_valid, stage2_valid;
    wire gated_clk;

    // Clock Gating: Disable clock when reset is high
    assign gated_clk = clk & ~reset;
    
    // Stage 1: Data Acquisition
    always @(posedge gated_clk) begin
        if (valid_in) begin
            stage1_data  <= sensor_data;
            stage1_valid <= 1;
        end else begin
            stage1_valid <= 0;
        end
    end
    
    // Stage 2: Processing (Simple Filtering - Example: Pass-through for now)
    always @(posedge gated_clk) begin
        if (stage1_valid) begin
            stage2_data  <= stage1_data; // Apply filtering logic if needed
            stage2_valid <= 1;
        end else begin
            stage2_valid <= 0;
        end
    end
    
    // Stage 3: Transmission
    always @(posedge gated_clk) begin
        if (stage2_valid) begin
            processed_data <= stage2_data;
            valid_out      <= 1;
        end else begin
            valid_out      <= 0;
        end
    end
    
endmodule
