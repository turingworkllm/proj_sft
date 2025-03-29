// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module PipelinedDataTransfer_tb;
    parameter DATA_WIDTH = 16;
    
    reg clk, reset, valid_in;
    reg [DATA_WIDTH-1:0] sensor_data;
    wire [DATA_WIDTH-1:0] processed_data;
    wire valid_out;
    
    // Instantiate DUT (Device Under Test)
    PipelinedDataTransfer #(DATA_WIDTH) dut (
        .clk(clk),
        .reset(reset),
        .sensor_data(sensor_data),
        .valid_in(valid_in),
        .processed_data(processed_data),
        .valid_out(valid_out)
    );
    
    // Clock Generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        valid_in = 0;
        sensor_data = 0;
        
        // Dump waveform
        $dumpfile("pipelined_data_transfer_tb.vcd");
        $dumpvars(0, PipelinedDataTransfer_tb);
        
        // Reset sequence
        #10 reset = 0;
        
        // Apply test vectors
        #10 valid_in = 1; sensor_data = 16'hA5A5;
        #10 valid_in = 0;
        #10 valid_in = 1; sensor_data = 16'h5A5A;
        #10 valid_in = 0;
        
        // Wait and finish
        #50;
        $finish;
    end
endmodule
