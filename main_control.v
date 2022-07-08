module main_control(
	opcode,
	func3,
	memread,
	memtoreg,
	aluop,
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
	rw_type
    );
	input [6:0]opcode;
	input [2:0]func3;
	
	output   memread;
	output   memtoreg;
	output   [1:0]aluop;
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
	
	wire branch;
	wire r_type;
	wire i_type;
	wire load;
	wire store;
	wire lui;
	wire auipc;

	
	assign branch=(opcode==`b_type)?1'b1:1'b0;
	assign r_type=(opcode==`r_type)?1'b1:1'b0;
	assign i_type=(opcode==`i_type)?1'b1:1'b0;
	assign u_type=(lui | auipc)? 1'b1:1'b0;
	assign load=(opcode==`load)?1'b1:1'b0;
	assign store=(opcode==`store)?1'b1:1'b0;
	
	assign jal=(opcode==`jal)?1'b1:1'b0;
	assign jalr=(opcode==`jalr)?1'b1:1'b0;
	assign lui=(opcode==`lui)?1'b1:1'b0;
	assign auipc=(opcode==`auipc)?1'b1:1'b0;
	assign beq= branch & (func3==3'b000);
	assign bne= branch & (func3==3'b001);
	assign blt= branch & (func3==3'b100);
	assign bge= branch & (func3==3'b101);
	assign bltu= branch & (func3==3'b110);
	assign bgeu= branch & (func3==3'b111);
	assign rw_type=func3;
	
	
	enable
	assign memread= load;
	assign memwrite= store;
	assign regwrite= jal| jalr | load | i_type |r_type | u_type;
	
	mux
	assign alusrc=load | store |i_type | jalr;  //select imme
	assign memtoreg= load;  //select datamemory data
	
	aluop
	assign aluop[1]= r_type|branch; //r 10 i 01 b 11 add 00
	assign aluop[0]= i_type|branch;
	
	
endmodule
