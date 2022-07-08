module alu_control(
	aluop,
	func3,
	func7,
	aluctl
    );
	input [1:0]aluop;
	input [2:0]func3;
	input func7;
	output [3:0]aluctl;
	
	wire [3:0]branchop;
	reg  [3:0]riop;
	
	
	
	assign branchop=(func3[2] & func3[1])? `sltu : (func3[2] ^ func3[1])? `slt : `sub;
	
	always@(*)
	begin
		case(func3)
			3'b000: if(aluop[1] & func7) //r
					riop=`sub;
					else                 //i
					riop=`add;
			3'b001: riop=`sll;
			3'b010: riop=`slt;
			3'b011: riop=`sltu;
			3'b100: riop=`xor;
			3'b101: if(func7)
					riop=`sra;
					else
					riop=`srl;
			3'b110: riop=`or;
			3'b111: riop=`and;
			default:riop=`add;
		endcase
	end
	
	assign aluctl=(aluop[1]^aluop[0])? riop:(aluop[1]&aluop[0])?branchop:`add;

endmodule
