module datapath(
	input   clk,
	input   rst_n,
	input   [31:0]instr,


	input   memtoreg,
	input   alusrc,
	input   regwrite,
	input   lui,
	input   u_type,
	input   jal,
	input   jalr,
	input   beq,
	input   bne,
	input   blt,
	input   bge,
	input   bltu,
	input   bgeu,
	input   [3:0]aluctl,
	
	input [31:0]rd_mem_data,
	output  [7:0]rom_addr,
	output [31:0]wr_mem_data,
	output [31:0]alu_result,
	output [6:0]opcode,
	output [2:0]func3,
	output func7
	
	
    );
	
	
	
	
	
	
	wire [4:0]rs1;
	wire [4:0]rs2;
	wire [4:0]rd;
	wire [31:0]imme;
	
	wire [31:0] wr_reg_data;
	wire [31:0] rd_data1;
	wire [31:0] rd_data2;
	
	wire zero;
	
	wire [31:0]pc_order;
	wire [31:0]pc_jump;
	
	wire   [31:0]pc_new;
	wire [31:0]pc_out;
	
	wire jump_flag;
	
	wire [31:0]alu_db;
	wire [31:0]wb_data;
	
	wire reg_sel;
	wire [31:0]wr_reg_data1;
	wire [31:0]wr_reg_data2;
	wire [31:0]pc_jump_order;
	wire [31:0]pc_jalr;
	
	
	assign reg_sel=jal | jalr ;
	assign wr_mem_data=rd_data2;
	assign rom_addr=pc_out[9:2];
	assign pc_jalr={alu_result[31:1],1'b0};
	
	pc_reg pc_reg_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .pc_new(pc_new), 
    .pc_out(pc_out)
    );

	
	instr_decode instr_decode_inst (
    .instr(instr), 
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd), 
    .imme(imme)
    );
	
    registers registers_inst (
    .clk(clk), 
    .w_en(regwrite), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd), 
    .wr_data(wr_reg_data), 
    .rd_data1(rd_data1), 
    .rd_data2(rd_data2)
    );

	
	alu alu_inst (
    .alu_da(rd_data1), 
    .alu_db(alu_db), 
    .alu_ctl(aluctl), 
    .alu_zero(zero), 
    .alu_overflow(), 
    .alu_dc(alu_result)
    );

	branch_judge branch_judge_inst (
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .jal(jal), 
    .jalr(jalr), 
    .zero(zero), 
    .alu_result(alu_result), 
    .jump_flag(jump_flag)
    );

	

	
//pc+4	
	cla_adder32 pc_adder_4 (
    .a(pc_out), 
    .b(32'd4), 
    .cin(1'd0), 
    .result(pc_order), 
    .cout()
    );
	
/pc+imme
	cla_adder32 pc_adder_imme (
    .a(pc_out), 
    .b(imme), 
    .cin(1'd0), 
    .result(pc_jump), 
    .cout()
    );
	

/pc_sel
	mux pc_mux (
    .data1(pc_jump), 
    .data2(pc_order), 
    .sel(jump_flag), 
    .dout(pc_jump_order)
    );
///pc_jalr
	mux pc_jalr_mux (
    .data1(pc_jalr), 
    .data2(pc_jump_order), 
    .sel(jalr), 
    .dout(pc_new)
    );

	
	
aludata_sel	
	mux alu_data_mux (
    .data1(imme), 
    .data2(rd_data2), 
    .sel(alusrc), 
    .dout(alu_db)
    );
	
	
/alu_result or datamem	
	mux wb_data_mux (
    .data1(rd_mem_data), 
    .data2(alu_result), 
    .sel(memtoreg), 
    .dout(wb_data)
    );
	
	
wr_data_sel
	mux jalr_mux (
    .data1(pc_order), 
    .data2(wb_data), 
    .sel(reg_sel), 
    .dout(wr_reg_data2)
    );
	
	mux lui_mux (
    .data1(imme), 
    .data2(pc_jump), 
    .sel(lui), 
    .dout(wr_reg_data1)
    );
	
	mux wr_reg_mux (
    .data1(wr_reg_data1), 
    .data2(wr_reg_data2), 
    .sel(u_type), 
    .dout(wr_reg_data)
    );

endmodule
