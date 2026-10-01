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
    
    else if(aluc==4'b1000) // lui (立即数高位加载)
    begin
        r = {b[15:0], 16'b0};
        if(r==0) zero=1;
        else zero=0; 
        if(r[31]==1) negative=1;
        else negative=0;
    end

    else if(aluc==4'b1001) // bgez (大于等于零则置位)
    begin
        if (a[31] == 0) begin
            r = 1; // 大于等于零
            zero = (a == 0);
            negative = 0;
        end else begin
            r = 0; // 小于零
            zero = 0;
            negative = 1;
        end
        carry = 0; // bgez 不涉及进位
        overflow = 0; // bgez 不涉及溢出
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
    
    // 把原来的 SRA/SRL 变长循环改为内置运算
    else if (aluc == 4'b1100) begin // sra
        r        = $signed(b) >>> a;
        carry    = (a != 0) ? b[a-1] : 1'b0;
        zero     = (r == 0);
        negative = r[31];
        overflow = 1'b0;
    end

    else if (aluc == 4'b1101) begin // srl
        r        = b >> a;
        carry    = (a != 0) ? b[a-1] : 1'b0;
        zero     = (r == 0);
        negative = r[31];
        overflow = 1'b0;
    end

    else if (aluc == 4'b1110) begin // sll
        r        = b << a;
        carry    = (a != 0) ? b[32-a] : 1'b0;
        zero     = (r == 0);
        negative = r[31];
        overflow = 1'b0;
    end
    
    else if (aluc == 4'b1111) begin // clz (Count Leading Zeros)
        if (a == 32'h0) begin
                    r = 32'd32;
                end else if (a[31]) begin
                    r = 32'd0;
                end else if (a[30]) begin
                    r = 32'd1;
                end else if (a[29]) begin
                    r = 32'd2;
                end else if (a[28]) begin
                    r = 32'd3;
                end else if (a[27]) begin
                    r = 32'd4;
                end else if (a[26]) begin
                    r = 32'd5;
                end else if (a[25]) begin
                    r = 32'd6;
                end else if (a[24]) begin
                    r = 32'd7;
                end else if (a[23]) begin
                    r = 32'd8;
                end else if (a[22]) begin
                    r = 32'd9;
                end else if (a[21]) begin
                    r = 32'd10;
                end else if (a[20]) begin
                    r = 32'd11;
                end else if (a[19]) begin
                    r = 32'd12;
                end else if (a[18]) begin
                    r = 32'd13;
                end else if (a[17]) begin
                    r = 32'd14;
                end else if (a[16]) begin
                    r = 32'd15;
                end else if (a[15]) begin
                    r = 32'd16;
                end else if (a[14]) begin
                    r = 32'd17;
                end else if (a[13]) begin
                    r = 32'd18;
                end else if (a[12]) begin
                    r = 32'd19;
                end else if (a[11]) begin
                    r = 32'd20;
                end else if (a[10]) begin
                    r = 32'd21;
                end else if (a[9]) begin
                    r = 32'd22;
                end else if (a[8]) begin
                    r = 32'd23;
                end else if (a[7]) begin
                    r = 32'd24;
                end else if (a[6]) begin
                    r = 32'd25;
                end else if (a[5]) begin
                    r = 32'd26;
                end else if (a[4]) begin
                    r = 32'd27;
                end else if (a[3]) begin
                    r = 32'd28;
                end else if (a[2]) begin
                    r = 32'd29;
                end else if (a[1]) begin
                    r = 32'd30;
                end else if (a[0]) begin
                    r = 32'd31;
                end else begin
                    r = 32'd32;
                end
                zero = (r == 0);
                negative = r[31];
    end
end

endmodule
