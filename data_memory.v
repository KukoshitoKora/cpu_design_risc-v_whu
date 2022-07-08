`include "define.v"
module data_memory(
    input clk,
    input rst_n,
    input w_en,
    input r_en,
  
    input [31:0] addr,
    input [ 2:0] rw_type,
    input [31:0] din,
    output[31:0] dout);

    reg [31:0] ram [255:0];
    wire[31:0] rd_data;
    
    reg [31:0] wr_data_b;
    wire[31:0] wr_data_h;
    wire[31:0] wr_data;
    
    wire [31:0] rd_data_b_ext;
    wire [31:0] rd_data_h_ext;
    
    assign rd_data=ram[addr[31:2]];
    
    always@(*)  begin
        case(addr[1:0])
            2'b00:wr_data_b={rd_data[31:8],din[7:0]};
            2'b01:wr_data_b={rd_data[31:16],din[7:0],rd_data[7:0]};
            2'b10:wr_data_b={rd_data[31:24],din[7:0],rd_data[15:0]};
            2'b11:wr_data_b={din[7:0],rd_data[23:0]};
            default:;
        endcase
    end
    
    assign wr_data_h=(addr[1])?{din[15:0],rd_data[15:0]}:{rd_data[31:16],din[15:0]};
    
    assign wr_data=(rw_type[1:0]==2'b00)?wr_data_b:((rw_type[1:0]==2'b01)?wr_data_h:din));
    
    always@(*) begin
        case(addr[1:0])
            2'b00:rd_data_b=rd_data[7:0];
            2'b01:rd_data_b=rd_data[15:8];
            2'b10:rd_data_b=rd_data[23:16];
            2'b11:rd_data_b=rd_data[31:24];
            default:;
        endcase
    end
    
    assign rd_data_b_ext=(rw_type[2])?{24'd0,rd_data_b}:{{24{rd_data_b[7]}},rd_data_b};
    assign rd_data_h_ext=(rw_type[2])?{16'd0,rd_data_h}:{{16{rd_data_h[15]}},rd_data_h};
    
    assign dout=(rw_type[1:0]==2'b00)?rd_data_b_ext:((rw_type[1:0]==2'b01)?rd_data_h_ext:rd_data);
    
endmodule
