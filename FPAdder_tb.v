/*****************************************************************************************************
* Description:                 Floating point Adder test bench
*
* Author:                      Dengxue Yan
*
* Email:                       Dengxue.Yan@wustl.edu
*
* Rev History:
*       <Author>        <Date>        <Hardware>     <Version>        <Description>
*     Dengxue Yan   2016-08-27 17:00       --           1.00             Create
*****************************************************************************************************/
`timescale 100ps / 1ps

module FPAdder_tb;

    reg clk;
    reg [31:0] a;
    reg [31:0] b;
 
    wire [31:0] sum;

    FPAdder DUT(
    .sum(sum),
    .a(a), 
    .b(b)
    );
    
    initial
    begin

        $dumpfile("FPAdder.vcd"); 
        $dumpvars(0, FPAdder_tb); 
            
        #0 
        clk = 0;

        a = 32'h3F800000;
        b = 32'h3F800000;

        #2     
        a = 32'h42C88000;
        b = 32'h3F9E6000;

        #2     
        a = 32'h00000003;
        b = 32'h00000001;

        #2     
        a = 32'h007FFFFF;
        b = 32'h00000001;

        #2     
        a = 32'h007FFFFF;
        b = 32'h00405A5A;

        #2     
        a = 32'h007FFFFF;
        b = 32'h00C05A5A;

        #2     
        a = 32'h700F0FFF;
        b = 32'h80C05A5A;

        #2     
        a = 32'h7E8F0FFF;
        b = 32'hFDF5FFFA;

        #2     
        a = 32'h80000000;
        b = 32'hFDF5FFFA;

        #2     
        a = 32'h00000000;
        b = 32'hFDF5FFFA;

        #2     
        a = 32'h00000000;
        b = 32'h00000000;

        #2     
        a = 32'h00000000;
        b = 32'h00000001;

        #2     
        a = 32'h80000000;
        b = 32'h00000000;

        #2     
        a = 32'h00000000;
        b = 32'h7F003400;

        #10

        #1
        $finish;
    end
    always
        #1 clk= !clk;
    
endmodule
