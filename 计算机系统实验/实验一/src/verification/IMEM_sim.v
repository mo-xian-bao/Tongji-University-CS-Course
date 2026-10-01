`timescale 1ns / 1ps

module IMEM(
    input [31:0] PC,
    output [31:0] Instr
);

    reg [31:0] rom [0:255];
    wire [7:0] rom_addr;
    reg [8*64-1:0] program_file;
    integer load_status;

    assign rom_addr = (PC - 32'h00400000) >> 2;
    assign Instr = rom[rom_addr];

    integer index;
    initial begin
        program_file = "program_smoke.hex";
        load_status = $value$plusargs("PROGRAM=%s", program_file);
        for (index = 0; index < 256; index = index + 1) begin
            rom[index] = 32'h00000000;
        end
        $readmemh(program_file, rom);
    end
endmodule