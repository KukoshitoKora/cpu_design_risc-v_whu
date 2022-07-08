module riscv(
	input clk,
	input rst_n,
	input [31:0]instr,
	input [31:0]rd_mem_data,
	
	output [7:0]rom_addr,
	
	output [31:0]wr_mem_data,
	output w_en,
	output r_en,
	output [31:0]ram_addr,
	output [2:0]rw_type
    );
	
	wire [6:0]opcode;
	wire [2:0]func3;
	wire func7;
	wire memtoreg;
	wire alusrc;
	wire regwrite;
	wire lui;
	wire u_type;
	wire jal;
	wire jalr;
	wire beq;
	wire bne;
	wire blt;
	wire bge;
	wire bltu;
	wire bgeu;
	wire [3:0]aluctl;
	
	
	
	control control_inst (
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
    .memread(r_en), 
    .memtoreg(memtoreg), 
    .memwrite(w_en), 
    .alusrc(alusrc), 
    .regwrite(regwrite), 
	.lui(lui),
	.u_type(u_type),
    .jal(jal), 
    .jalr(jalr), 
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .rw_type(rw_type), 
    .aluctl(aluctl)
    );
	
	datapath datapath_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .instr(instr), 
    .memtoreg(memtoreg), 
    .alusrc(alusrc), 
    .regwrite(regwrite), 
	.lui(lui),
	.u_type(u_type),
    .jal(jal), 
    .jalr(jalr), 
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .aluctl(aluctl), 
    .rd_mem_data(rd_mem_data), 
    .rom_addr(rom_addr), 
    .wr_mem_data(wr_mem_data),
	.alu_result(ram_addr),
	.opcode(opcode),
	.func3(func3),
	.func7(func7)
    );

endmodule
