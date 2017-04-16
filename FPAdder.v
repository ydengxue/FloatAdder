/*****************************************************************************************************
* Description:                 Floating point Adder
*
* Author:                      Dengxue Yan
*
* Email:                       Dengxue.Yan@wustl.edu
*
* Rev History:
*       <Author>        <Date>        <Hardware>     <Version>        <Description>
*     Dengxue Yan   2016-09-04 17:00       --           1.00             Create
*****************************************************************************************************/
`timescale 100ps / 1ps

module FPAdder(sum, a, b);
    output [31:0] sum;
    reg    [31:0] sum;

    input  [31:0] a;
    input  [31:0] b;

    reg [7:0]   sum_exponent = 8'hFF;
    reg [22:0]  sum_precision = 23'h7FFFFF;
    reg [45:0]  sum_precision_temp;

    reg [7:0]   sum_left_shift = 8'h00;

    // When calculate we expect that a's exponent not smaller than b's.
    wire compare_ab = (a[30:23] < b[30:23] ) ? 1'b1: 1'b0;
    wire [31:0]  a_calc = compare_ab ? b : a;
    wire [31:0]  b_calc = compare_ab ? a : b;;

    // Extract sign, exponent, and precision of a_calc
    wire a_sign = a_calc[31];
    wire a_exponent_non_zero = a_calc[30:23] ? 1'b1 : 1'b0; 
    wire [7:0]  a_exponent  = a_exponent_non_zero ? a_calc[30:23] : 8'h01;
    wire [46:0] a_precision = {a_exponent_non_zero ? 1'b1 : 1'b0, a_calc[22:0], 23'h000000};

    // Extract sign, exponent, and precision of b_calc
    wire b_sign = b_calc[31];
    wire b_exponent_non_zero = b_calc[30:23] ? 1'b1 : 1'b0; 
    wire [7:0]  b_exponent  = b_exponent_non_zero ? b_calc[30:23] : 8'h01;
    wire [46:0] b_precision = {b_exponent_non_zero ? 1'b1 : 1'b0, b_calc[22:0], 23'h000000};

    // Adjust b_calc's precision to make its exponent be same as a_calc's
    wire [7:0]  exponent_diff_ab = a_exponent - b_exponent;
    wire [46:0] b_precision_offset = b_precision >> exponent_diff_ab;

    // Add the sign to the precision, also consider there might be one bit overflow when add
    wire [48:0] a_precision_sign = a_sign ? -a_precision: a_precision;
    wire [48:0] b_precision_sign = b_sign ? -b_precision_offset: b_precision_offset;

    // Now two operands have the same exponent and both are signed value, so we can add them directly.
    wire [48:0] sum_precision_sign = a_precision_sign + b_precision_sign;

    // Extract sign, the original precision of sum.
    wire sum_sign = sum_precision_sign[48];
    wire [47:0] sum_precision_calc = sum_sign ? -sum_precision_sign : sum_precision_sign;

    always @( sum_precision_calc )
    begin
        // Overflow of sum
        if (sum_precision_calc[47])
        begin
            // Infinite or overflow of a_exponent.
            // Not a number is handled in output part and we don't care about it here
            if ((8'hFF == a_exponent) || (8'hFE == a_exponent))
            begin
                sum_exponent  = 8'hFF;
                sum_precision = 23'h000000;
            end
            else
            begin
                sum_exponent  = a_exponent + 1;
                sum_precision = sum_precision_calc[46: 24];// Round is not considered
                // If consider round, the following expression could be used.
                // Since we know sum_precision_calc[46: 24] could not be 23'hFFFFFF, we could round the result directly here
//                sum_precision = sum_precision_calc[23] ? sum_precision_calc[46: 24] + 1: sum_precision_calc[46: 24];
            end
        end
        else
        begin
            // Exponent and mantissa adjust
            if (sum_precision_calc[46])
            begin
                sum_left_shift  = 0;
            end
            else if (sum_precision_calc[45])
            begin
                sum_left_shift  = 1;
            end
            else if (sum_precision_calc[44])
            begin
                sum_left_shift  = 2;
            end
            else if (sum_precision_calc[43])
            begin
                sum_left_shift  = 3;
            end
            else if (sum_precision_calc[42])
            begin
                sum_left_shift  = 4;
            end
            else if (sum_precision_calc[41])
            begin
                sum_left_shift  = 5;
            end
            else if (sum_precision_calc[40])
            begin
                sum_left_shift  = 6;
            end
            else if (sum_precision_calc[39])
            begin
                sum_left_shift  = 7;
            end
            else if (sum_precision_calc[38])
            begin
                sum_left_shift  = 8;
            end
            else if (sum_precision_calc[37])
            begin
                sum_left_shift  = 9;
            end
            else if (sum_precision_calc[36])
            begin
                sum_left_shift  = 10;
            end
            else if (sum_precision_calc[35])
            begin
                sum_left_shift  = 11;
            end
            else if (sum_precision_calc[34])
            begin
                sum_left_shift  = 12;
            end
            else if (sum_precision_calc[33])
            begin
                sum_left_shift  = 13;
            end
            else if (sum_precision_calc[32])
            begin
                sum_left_shift  = 14;
            end
            else if (sum_precision_calc[31])
            begin
                sum_left_shift  = 15;
            end
            else if (sum_precision_calc[30])
            begin
                sum_left_shift  = 16;
            end
            else if (sum_precision_calc[29])
            begin
                sum_left_shift  = 17;
            end
            else if (sum_precision_calc[28])
            begin
                sum_left_shift  = 18;
            end
            else if (sum_precision_calc[27])
            begin
                sum_left_shift  = 19;
            end
            else if (sum_precision_calc[26])
            begin
                sum_left_shift  = 20;
            end
            else if (sum_precision_calc[25])
            begin
                sum_left_shift  = 21;
            end
            else if (sum_precision_calc[24])
            begin
                sum_left_shift  = 22;
            end
            else if (sum_precision_calc[23])
            begin
                sum_left_shift  = 23;
            end
            else if (sum_precision_calc[22])
            begin
                sum_left_shift  = 24;
            end
            else if (sum_precision_calc[21])
            begin
                sum_left_shift  = 25;
            end
            else if (sum_precision_calc[20])
            begin
                sum_left_shift  = 26;
            end
            else if (sum_precision_calc[19])
            begin
                sum_left_shift  = 27;
            end
            else if (sum_precision_calc[18])
            begin
                sum_left_shift  = 28;
            end
            else if (sum_precision_calc[17])
            begin
                sum_left_shift  = 29;
            end
            else if (sum_precision_calc[16])
            begin
                sum_left_shift  = 30;
            end
            else if (sum_precision_calc[15])
            begin
                sum_left_shift  = 31;
            end
            else if (sum_precision_calc[14])
            begin
                sum_left_shift  = 32;
            end
            else if (sum_precision_calc[13])
            begin
                sum_left_shift  = 33;
            end
            else if (sum_precision_calc[12])
            begin
                sum_left_shift  = 34;
            end
            else if (sum_precision_calc[11])
            begin
                sum_left_shift  = 35;
            end
            else if (sum_precision_calc[10])
            begin
                sum_left_shift  = 36;
            end
            else if (sum_precision_calc[9])
            begin
                sum_left_shift  = 37;
            end
            else if (sum_precision_calc[8])
            begin
                sum_left_shift  = 38;
            end
            else if (sum_precision_calc[7])
            begin
                sum_left_shift  = 39;
            end
            else if (sum_precision_calc[6])
            begin
                sum_left_shift  = 40;
            end
            else if (sum_precision_calc[5])
            begin
                sum_left_shift  = 41;
            end
            else if (sum_precision_calc[4])
            begin
                sum_left_shift  = 42;
            end
            else if (sum_precision_calc[3])
            begin
                sum_left_shift  = 43;
            end
            else if (sum_precision_calc[2])
            begin
                sum_left_shift  = 44;
            end
            else if (sum_precision_calc[1])
            begin
                sum_left_shift  = 45;
            end
            else
            begin
                sum_left_shift  = 46;
            end

            // If a_exponent > sum_left_shift, the leading digit is 1, and omit it;
            // Otherwise the leading digit will be 0, and we cannot omit any bit.
            // Here, a_exponent >= 1, so when 1'b1 == sum_precision_calc[46], sum_exponent would never be 0;
            // In addition, the round situation is a little complicated here,
            // because sum_precision_temp[45:23] might be 23'hFFFFFF. So we don't consider round here
            if (a_exponent > sum_left_shift)
            begin
                sum_exponent = a_exponent - sum_left_shift;
                sum_precision_temp = (sum_precision_calc << sum_left_shift);
            end
            else
            begin
                sum_exponent  = 0;
                sum_precision_temp = (sum_precision_calc << (a_exponent - 1));
            end
            sum_precision = sum_precision_temp[45:23];
        end
    end

    always @ (a, b, sum_sign, sum_exponent, sum_precision)
    begin
        // 1. If a is not-a-number,  then sum = a;
        // 2. If a is infinite, and b is a valid number,  then sum = a;
        // 3. If a is infinite, but b is not-a-number, then sum = b;
        // 5. If a and b are both infinite and both have same sign,  then sum = a;
        // 6. If a and b are both infinite, but have different sign, then sum = not-a-number;
        if (8'hFF == a[30:23])
        begin
            if ((23'h000000 == a[22:0]) && (8'hFF == b[30:23]))
            begin
                if (23'h000000 != b[22:0])// b is not a number;
                begin
                    sum = b;
                end
                else
                begin
                    if (a[31] == b[31])
                    begin
                        sum = a;
                    end
                    else// a and b are +inf and -inf
                    begin
                        sum = 32'hFFC00000;
                    end
                end
            end
            else
            begin
                sum = a;
            end
        end
        // 1. If a is a valid num and b is infinite, then sum = b;
        // 2. If a is a valid num and b is not-a-number, then sum = b;
        else if (8'hFF == b[30:23])
        begin
            sum = b;
        end
        else
        begin
            sum = {sum_sign, sum_exponent, sum_precision};
        end
    end

endmodule
