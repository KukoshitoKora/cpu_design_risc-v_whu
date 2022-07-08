module riscv_top(
	input clk,
	input rst_n,
	output [7:0]rom_addr
    );

//	wire [7:0]rom_addr;
	wire [31:0]ram_addr;
	wire [31:0]instr;
	wire [31:0]rd_mem_data;
	wire [31:0]wr_mem_data;
	wire w_en;
	wire r_en;
	wire [2:0]rw_type;
	
	instr_memory instr_memory_inst (
    .addr(rom_addr), 
    .instr(instr)
    );

	riscv riscv_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .instr(instr), 
    .rd_mem_data(rd_mem_data), 
    .rom_addr(rom_addr), 
    .wr_mem_data(wr_mem_data), 
    .w_en(w_en), 
    .r_en(r_en), 
    .ram_addr(ram_addr), 
    .rw_type(rw_type)
    );

	
	
	
	data_memory data_memory_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .w_en(w_en), 
    .r_en(r_en), 
    .addr(ram_addr), 
    .rw_type(rw_type), 
    .din(wr_mem_data), 
    .dout(rd_mem_data)
    );	

endmodule
