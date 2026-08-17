`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2026 14:28:50
// Design Name: 
// Module Name: debounce
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


module debounce#(
    parameter clk_freq=27000000,
    parameter debounce_time = 10//debounce time in ms
)(
    input clk,
    input resn,
    input in,
    output reg out
    );
    
    localparam debounce_freq = 1000/(debounce_time);//*1000 z ms na s zeby dostac hz
    localparam divide = clk_freq/debounce_freq;
    
    reg [$clog2(divide):0] count;
    
    reg ff1;
    reg ff2;
    
    //dodanie synchnizera 
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
    
    always@(posedge clk)begin
        if(!resn)begin
            out<=0;
            count<=0;
        end
        else begin
            if(ff2!=out)begin
                if(count==divide)begin
                    count<=0;
                    out<=ff2;
                end
                else begin
                    count<=count+1;
                end
            end
            else begin
                count<=0;
            end
        end
        
    end
    
endmodule
