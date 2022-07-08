`include "define.v"
module instr_decode(
    input [31:0] instr,
    output [6:0] opcode,
    output [2:0] func3,
    output func7,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [31:0] imme);
    
    wire i_type;
    wire u_type;
    wire j_type;
    wire b_type;
    wire s_type;
    
    wire [31:0] i_imme;
    wire [31:0] u_imme;
    wire [31:0] j_imme;
    wire [31:0] b_imme;
    wire [31:0] s_imme;
    
    assign opcode=instr[6:0];
    assign func3=instr[14:12];
    assign rs1=instr[19:15];
    assign rs2=instr[24:20];
    assign rd=instr[11:7];
    
    assign i_type=(instr[6:0]==`jalr)|(instr[6:0]==`load)|(instr[6:0]==`i_type);
    assign u_type=(instr[6:0]==`lui)|(instr[6:0]==`auipc);
    assign j_type=(instr[6:0]==`jal);
    assign b_type=(instr[6:0]==`b_type);
    assign s_type=(instr[6:0]==`store);
    
    assign i_imme={{20{instr[31]}},instr[31:20]};
    assign u_imme={instr[31:12],{12{1'b0}}};
    assign j_imme={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
    assign b_imme={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
    assign s_imme={{20{instr[31]}},instr[31:25],instr[11:7]};
    
    assign imme= i_type?i_imme:
                 u_type?u_imme:
                 j_type?j_imme:
                 b_type?b_imme:
                 s_type?s_imme:32'd0;
endmodule
