`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/09 21:19:06
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a, //32 位输入，操作数 1
    input [31:0] b, //32 位输入，操作数 2
    input [3:0] aluc, //4 位输入，控制 alu 的操作
    output reg [31:0] r, //32 位输出，由 a、b 经过 aluc 指定的操作生成
    output reg zero, //0 标志位（ZF）
    output reg carry, // 进位标志位（CF）
    output reg negative, // 负数标志位（SF）
    output reg overflow // 溢出标志位（OF）
);
integer i;

always @(*)
begin
    if(aluc == 4'b0000) // addu (无符号加法)
    begin
        r = a+b;
        if(r == 0) zero = 1;
        else zero = 0;
        if(((a[31]==1||b[31]==1)&&r[31]==0)||(a[31]==1&&b[31]==1)) carry = 1;
        else carry = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b0010) // add (有符号加法)
    begin
        r = a + b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
        if(r[31]!=a[31] && r[31]!=b[31]) overflow=1;
        else overflow=0;
    end
    
    else if(aluc==4'b0001) // subu (无符号减法)
    begin
        r = a - b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (a < b) carry = 1;
        else carry = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b0011) // sub (有符号减法)
    begin
        r = a - b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
        if (r[31]!=a[31]&&r[31]==b[31]) overflow=1;
        else overflow = 0;
    end
    
    else if(aluc==4'b0100) // and (逻辑与)
    begin
        r = a & b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b0101) // or (逻辑或)
    begin
        r = a | b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b0110) // xor (逻辑异或)
    begin
        r = a ^ b;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b0111) // nor (逻辑或非)
    begin
        r = ~(a | b);
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b1000||aluc==4'b1001) // lui (立即数高位加载)
    begin
        r = {b[15:0], 16'b0};
        if(r==0) zero=1;
        else zero=0; 
        if(r[31]==1) negative=1;
        else negative=0;
    end
    
    else if(aluc==4'b1011) // slt (有符号小于则置位)
    begin
        if ($signed (a) < $signed(b))  r = 1;
        else r=0;
        if (a == b) zero = 1;
        else zero = 0;
        if($signed (a)<$signed(b)) negative = 1;
        else negative = 0;    
    end
    
    else if(aluc==4'b1010) // sltu (无符号小于则置位)
    begin
        r = (a < b) ? 1 : 0;
        if (a == b) zero = 1;
        else zero = 0;
        if (r[31]==1) negative = 1;
        else negative = 0;
        if(a<b) carry=1;
        else carry=0;
    end
    
    else if(aluc==4'b1100) // sra (算术右移)
    begin
        if(a!=0) carry=b[a-1];
        else carry=0;
        
        // 使用Verilog内置算术右移操作符
        r = $signed(b) >>> a;
                    
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b1110||aluc==4'b1111) // sll (逻辑左移)
    begin
        if(a==0) carry=0;
        else carry = b[32-a];
        r = b << a;
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
    
    else if(aluc==4'b1101) // srl (逻辑右移)
    begin
        if(a!=0) carry=b[a-1];
        else carry=0;
        
        // 逻辑右移直接使用右移操作符(高位自动补0)
        r = b >> a;
                        
        if (r == 0) zero = 1;
        else zero = 0;
        if (r[31] == 1) negative = 1;
        else negative = 0;
    end
end

endmodule

