module alu(
	   ALU_DA,
       ALU_DB,
       ALU_CTL,
       ALU_ZERO,
       ALU_OverFlow,
       ALU_DC   
        );
	  input [31:0]    ALU_DA;
    input [31:0]    ALU_DB;
    input [3:0]     ALU_CTL;
    output          ALU_ZERO;
    output          ALU_OverFlow;
    output reg [31:0]   ALU_DC;
		   
wire SUBctr;
wire SIGctr;
wire Ovctr;
wire [1:0] Opctr;
wire [1:0] Logicctr;
wire [1:0] Shiftctr;

assign SUBctr = (~ ALU_CTL[3]  & ~ALU_CTL[2]  & ALU_CTL[1]) | ( ALU_CTL[3]  & ~ALU_CTL[2]);
assign Opctr = ALU_CTL[3:2];
assign Ovctr = ALU_CTL[0] & ~ ALU_CTL[3]  & ~ALU_CTL[2] ;
assign SIGctr = ALU_CTL[0];
assign Logicctr = ALU_CTL[1:0]; 
assign Shiftctr = ALU_CTL[1:0]; 

reg [31:0] logic_result;

always@(*) begin
    case(Logicctr)
	2'b00:logic_result = ALU_DA & ALU_DB;
	2'b01:logic_result = ALU_DA | ALU_DB;
	2'b10:logic_result = ALU_DA ^ ALU_DB;
	2'b11:logic_result = ~(ALU_DA | ALU_DB);
	endcase
end 

wire [4:0]     ALU_SHIFT;
wire [31:0] shift_result;
assign ALU_SHIFT=ALU_DB[4:0];

Shifter Shifter(.ALU_DA(ALU_DA),
                .ALU_SHIFT(ALU_SHIFT),
				.Shiftctr(Shiftctr),
				.shift_result(shift_result));

wire [31:0] BIT_M,XOR_M;
wire ADD_carry,ADD_OverFlow;
wire [31:0] ADD_result;

assign BIT_M={32{SUBctr}};
assign XOR_M=BIT_M^ALU_DB;

Adder Adder(.A(ALU_DA),
            .B(XOR_M),
			.Cin(SUBctr),
			.ALU_CTL(ALU_CTL),
			.ADD_carry(ADD_carry),
			.ADD_OverFlow(ADD_OverFlow),
			.ADD_zero(ALU_ZERO),
			.ADD_result(ADD_result));

assign ALU_OverFlow = ADD_OverFlow & Ovctr;

wire [31:0] SLT_result;
wire LESS_M1,LESS_M2,LESS_S,SLT_M;

assign LESS_M1 = ADD_carry ^ SUBctr;
assign LESS_M2 = ADD_OverFlow ^ ADD_result[31];
assign LESS_S = (SIGctr==1'b0)?LESS_M1:LESS_M2;
assign SLT_result = (LESS_S)?32'h00000001:32'h00000000;

always @(*) 
begin
  case(Opctr)
     2'b00:ALU_DC<=ADD_result;
     2'b01:ALU_DC<=logic_result;
     2'b10:ALU_DC<=SLT_result;
     2'b11:ALU_DC<=shift_result; 
  endcase
end
endmodule

module Shifter(input [31:0] ALU_DA,
               input [4:0] ALU_SHIFT,
			   input [1:0] Shiftctr,
			   output reg [31:0] shift_result);
			   

     wire [5:0] shift_n;
	 assign shift_n = 6'd32 - Shiftctr;
     always@(*) begin
	   case(Shiftctr)
	   2'b00:shift_result = ALU_DA << ALU_SHIFT;
	   2'b01:shift_result = ALU_DA >> ALU_SHIFT;
	   2'b10:shift_result = ({32{ALU_DA[31]}} << shift_n) | (ALU_DA >> ALU_SHIFT);
	   default:shift_result = ALU_DA;
	   endcase
	 end


endmodule

module Adder(input [31:0] A,
             input [31:0] B,
			 input Cin,
			 input [3:0] ALU_CTL,
			 output ADD_carry,
			 output ADD_OverFlow,
			 output ADD_zero,
			 output [31:0] ADD_result);


    assign {ADD_carry,ADD_result}=A+B+Cin;
   assign ADD_zero = ~(|ADD_result);
   assign ADD_OverFlow=((ALU_CTL==4'b0001) & ~A[31] & ~B[31] & ADD_result[31]) 
                      | ((ALU_CTL==4'b0001) & A[31] & B[31] & ~ADD_result[31])
                      | ((ALU_CTL==4'b0011) & A[31] & ~B[31] & ~ADD_result[31]) 
					  | ((ALU_CTL==4'b0011) & ~A[31] & B[31] & ADD_result[31]);
endmodule



