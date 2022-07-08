module instr_memory(
    input  [ 7:0]addr,
    output [31:0]instr);

reg [31:0] rom [255:0]

initial begin
//  $readmemb("./rom_binary_file.txt",rom);
//  $readmemh("./rom_hex_file.txt",rom);
end

assign instr = rom[addr];

endmodule
