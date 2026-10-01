`timescale 1ns / 1ps

module ALU(
    input [31:0] a,         // 操作数1
    input [31:0] b,         // 操作数2
    input [3:0] aluc,       // ALU控制信号
    output reg [31:0] r,    // 运算结果
    output reg zero,        // 零标志位
    output reg carry,       // 进位标志位
    output reg negative,    // 负数标志位
    output reg overflow     // 溢出标志位
);

always @(*) begin
    // 默认值
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    r = 32'b0;
    
    case(aluc)
        4'b0000: begin  // addu (无符号加法)
            r = a + b;
            zero = (r == 0);
            carry = ((a[31] || b[31]) && !r[31]) || (a[31] && b[31]);
            negative = r[31];
        end
        
        4'b0010: begin  // add (有符号加法)
            r = a + b;
            zero = (r == 0);
            negative = r[31];
            overflow = (r[31] != a[31]) && (r[31] != b[31]);
        end
        
        4'b0001: begin  // subu (无符号减法)
            r = a - b;
            zero = (r == 0);
            carry = (a < b);
            negative = r[31];
        end
        
        4'b0011: begin  // sub (有符号减法)
            r = a - b;
            zero = (r == 0);
            negative = r[31];
            overflow = (r[31] != a[31]) && (r[31] == b[31]);
        end
        
        4'b0100: begin  // and
            r = a & b;
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b0101: begin  // or
            r = a | b;
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b0110: begin  // xor
            r = a ^ b;
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b0111: begin  // nor
            r = ~(a | b);
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b1000, 4'b1001: begin  // lui
            r = {b[15:0], 16'b0};
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b1011: begin  // slt (有符号比较)
            r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            zero = (a == b);
            negative = ($signed(a) < $signed(b));
        end
        
        4'b1010: begin  // sltu (无符号比较)
            r = (a < b) ? 32'd1 : 32'd0;
            zero = (a == b);
            negative = r[31];
            carry = (a < b);
        end
        
        4'b1100: begin  // sra (算术右移)
            r = $signed(b) >>> a;
            carry = (a != 0) ? b[a-1] : 1'b0;
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b1110: begin  // sll (逻辑左移)
            r = b << a[4:0];
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b1101: begin  // srl (逻辑右移)
            r = b >> a[4:0];
            zero = (r == 0);
            negative = r[31];
        end
        
        4'b1111: begin  // clz (计数前导零)
            r = (a[31]) ? 0  : (a[30]) ? 1  : (a[29]) ? 2  : (a[28]) ? 3  :
                (a[27]) ? 4  : (a[26]) ? 5  : (a[25]) ? 6  : (a[24]) ? 7  :
                (a[23]) ? 8  : (a[22]) ? 9  : (a[21]) ? 10 : (a[20]) ? 11 :
                (a[19]) ? 12 : (a[18]) ? 13 : (a[17]) ? 14 : (a[16]) ? 15 :
                (a[15]) ? 16 : (a[14]) ? 17 : (a[13]) ? 18 : (a[12]) ? 19 :
                (a[11]) ? 20 : (a[10]) ? 21 : (a[9])  ? 22 : (a[8])  ? 23 :
                (a[7])  ? 24 : (a[6])  ? 25 : (a[5])  ? 26 : (a[4])  ? 27 :
                (a[3])  ? 28 : (a[2])  ? 29 : (a[1])  ? 30 : (a[0])  ? 31 : 32;
            zero = (r == 32);
            negative = 1'b0;
        end
        
        default: begin
            r = 32'b0;
        end
    endcase
end

endmodule
