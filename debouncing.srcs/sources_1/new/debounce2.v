`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2026 22:27:46
// Design Name: 
// Module Name: debounce2
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

//inna realizacja debouncingu - przez shift register

module debounce2#(
    parameter debounce_time = 10,//czas debouncingu w ms
    parameter clk_freq=27000000//czestotliwosc zegara w hz
)(
    input clk,
    input resn,
    input in,
    output reg out
    );
    
    localparam debounce_freq = 1000/debounce_time;
    localparam divide = clk_freq/debounce_freq;
    localparam sample = divide/8;
    localparam width = $clog2(sample+1);
    
    reg [width-1:0] count;
    reg [7:0] shift;
    reg sample_tick;
    
    reg ff1;
    reg ff2;
    
    //synchronizer
    always@(posedge clk)begin
        if(!resn)begin
            ff1<=0;
            ff2<=0;
        end 
        else begin
            ff1<=in;
            ff2<=ff1;
        end
    end
    
    //blok licznika do probkowania
    always@(posedge clk)begin
        if(!resn)begin
            sample_tick<=0;
            count<=0;
        end
        else begin
            if(count==sample)begin
                sample_tick<=1;
                count<=0;
            end
            else begin
                count<=count+1;
                sample_tick<=0;
            end
        end
    end
    
    //blok rejestru przesuwnego
    always@(posedge clk)begin
        if(!resn)begin
            out<=0;
            shift <= 8'h00;
        end
        else begin
            if(sample_tick==1)begin
                shift<=shift<<1;
                shift[0]<=in;
                if(shift==8'hFF)begin
                    out<=1'b1;
                end
                else if(shift==8'h00)begin
                    out<=1'b0;
                end
            end
        end
    end
    
endmodule
