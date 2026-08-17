`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2026 14:29:10
// Design Name: 
// Module Name: debounce_tb
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


module debounce_tb(

    );
    
    reg clk;
    reg res;
    reg in;
    wire out;
    reg out_ref;
    
    parameter clock_time = 5;
    parameter clk_freq = 1000/(2*clock_time);
    parameter debounce_time = 5*(clock_time);
    reg [8*20:0] str;
    
    debounce#(.clk_freq(clk_freq), .debounce_time(debounce_time)) dut(.clk(clk), .resn(res), .out(out), .in(in));
    
    task reset();
        begin
        str = "reset";
        @(posedge clk)
        @(negedge clk)
        res = 0;
        @(posedge clk)
        #2
        res = 1;
        end
    endtask
    
    task long_signal_change();
        begin
            str = "dluga zmiana stanu";
            @(posedge clk)
            in = 1;
            #(debounce_time+1)
            in = 0;
            @(posedge clk)
            in = 1;
        end 
    endtask
    
    task short_signal_change();
        begin
            str = "krotka zmiana stanu";
            @(posedge clk)
            in = 0;
            #(debounce_time/2)
            in = 1;
        end
    endtask
    
    initial begin
        res = 1;
        clk = 0;
    end 
    
    always #5 clk = ~clk;
    
    always @(negedge clk or posedge out or negedge out) begin//co cykl zegara plus przy jakiejkolwiek zmianie sygnalu wyjsciowego
        if(out!=out_ref)begin
            $display("TEST - %s - FAIL, time %t",str, $time);
            #5;
            $finish;
        end 
    end
    parameter short =debounce_time/2;
    //generowanie sygnałów referencyjnych
    //reset->dlugie przytrzymanie->za krotkie przytrzymanie
    initial begin
        //reset
        @(posedge clk)
        @(posedge clk)
        out_ref = 0;
        @(posedge clk)
        #(debounce_time+1)
        @(posedge clk)
        @(posedge clk)
        out_ref = 1;
        #(debounce_time/2)
        @(posedge clk)
        @(posedge clk)
        out_ref = 1;
        #20
        $display("SUKCES - modul poprawnie przeszedl testy");
        $finish;
        
    end 
    
    //blok przeprowadzanych testów
    initial begin
        reset();
        long_signal_change();
        short_signal_change();
    end
    
    
    
    
endmodule
