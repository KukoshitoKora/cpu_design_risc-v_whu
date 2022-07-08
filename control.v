`include "define.v"
module control(
	opcode,
	func3,
	func7,
	memread,
	memtoreg,
	memwrite,
	alusrc,
	regwrite,
	lui,
	u_type,
	jal,
	jalr,
	beq,
	bne,
	blt,
	bge,
	bltu,
	bgeu,
	rw_type,
	aluctl

    );
	input 	 [6:0]opcode;
	input 	 [2:0]func3;
	input 	 func7;
	output   memread;
	output   memtoreg;
	output   memwrite;
	output   alusrc;
	output   regwrite;
	output   lui;
	output   u_type;
	output   jal;
	output   jalr;
	output   beq;
	output   bne;
	output   blt;
	output   bge;
	output   bltu;
	output   bgeu;
	output   [2:0]rw_type;
	output   [3:0]aluctl;
	
	wire [1:0]aluop;
	
	main_control main_control_inst(
	.opcode(opcode),
	.func3(func3),
	.memread(memread),
	.memtoreg(memtoreg),
	.aluop(aluop),
	.memwrite(memwrite),
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
	.rw_type(rw_type)
    );
	
	alu_control alu_control_inst(
	.aluop(aluop),
	.func3(func3),
	.func7(func7),
	.aluctl(aluctl)
    );
	
endmodule

