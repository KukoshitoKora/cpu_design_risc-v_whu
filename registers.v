`module "define.v"
module registers(
    input clk,
    input w_en,
    input [4:0]rs1,
    input [4:0]rs2,
    input [4:0]rd,
    input [31:0]wr_data,
    output[31:0]rd_data1,
    output[31:0]rd_data2);
    
    reg [31:0] regs[31:0];
    
    always@(posedge clk) begin
        if(w_en&(rd!=1'b0))
            regs[rd]<=wr_data;
    end
    
    assign rd_data1=(rs1==5'd0)?`zero_word:regs[rs1];
    assign rd_data2=(rs2==5'd0)?`zero_word:regs[rs2];
    
endmodule
