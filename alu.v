module alu(
       alu_da,
       alu_db,
       alu_ctl,
       alu_zero,
       alu_overflow,
       alu_dc   
        );
	  input [31:0]    alu_da;
    input [31:0]    alu_db;
    input [3:0]     alu_ctl;
    output          alu_zero;
    output          alu_overflow;
    output reg [31:0]   alu_dc;
		   
wire subctr;
wire sigctr;
wire ovctr;
wire [1:0] opctr;
wire [1:0] logicctr;
wire [1:0] shiftctr;

assign subctr = (~ alu_ctl[3]  & ~alu_ctl[2]  & alu_ctl[1]) | ( alu_ctl[3]  & ~alu_ctl[2]);
assign opctr = alu_ctl[3:2];
assign ovctr = alu_ctl[0] & ~ alu_ctl[3]  & ~alu_ctl[2] ;
assign sigctr = alu_ctl[0];
assign logicctr = alu_ctl[1:0]; 
assign shiftctr = alu_ctl[1:0]; 

reg [31:0] logic_result;

always@(*) begin
    case(logicctr)
	2'b00:logic_result = alu_da & alu_db;
	2'b01:logic_result = alu_da | alu_db;
	2'b10:logic_result = alu_da ^ alu_db;
	2'b11:logic_result = ~(alu_da | alu_db);
	endcase
end 

wire [4:0]     alu_shift;
wire [31:0] shift_result;
assign alu_shift=alu_db[4:0];

shifter shifter(.alu_da(alu_da),
                .alu_shift(alu_shift),
				.shiftctr(shiftctr),
				.shift_result(shift_result));

wire [31:0] bit_m,xor_m;
wire add_carry,add_overflow;
wire [31:0] add_result;

assign bit_m={32{subctr}};
assign xor_m=bit_m^alu_db;

adder adder(.a(alu_da),
            .b(xor_m),
			.cin(subctr),
			.alu_ctl(alu_ctl),
			.add_carry(add_carry),
			.add_overflow(add_overflow),
			.add_zero(alu_zero),
			.add_result(add_result));

assign alu_overflow = add_overflow & ovctr;

wire [31:0] slt_result;
wire less_m1,less_m2,less_s,slt_m;

assign less_m1 = add_carry ^ subctr;
assign less_m2 = add_overflow ^ add_result[31];
assign less_s = (sigctr==1'b0)?less_m1:less_m2;
assign slt_result = (less_s)?32'h00000001:32'h00000000;

always @(*) 
begin
  case(opctr)
     2'b00:alu_dc<=add_result;
     2'b01:alu_dc<=logic_result;
     2'b10:alu_dc<=slt_result;
     2'b11:alu_dc<=shift_result; 
  endcase
end
endmodule

module shifter(input [31:0] alu_da,
               input [4:0] alu_shift,
			   input [1:0] shiftctr,
			   output reg [31:0] shift_result);
			   

     wire [5:0] shift_n;
	 assign shift_n = 6'd32 - shiftctr;
     always@(*) begin
	   case(shiftctr)
	   2'b00:shift_result = alu_da << alu_shift;
	   2'b01:shift_result = alu_da >> alu_shift;
	   2'b10:shift_result = ({32{alu_da[31]}} << shift_n) | (alu_da >> alu_shift);
	   default:shift_result = alu_da;
	   endcase
	 end


endmodule

module adder(input [31:0] a,
             input [31:0] b,
			 input cin,
			 input [3:0] alu_ctl,
			 output add_carry,
			 output add_overflow,
			 output add_zero,
			 output [31:0] add_result);


    assign {add_carry,add_result}=a+b+cin;
   assign add_zero = ~(|add_result);
   assign add_overflow=((alu_ctl==4'b0001) & ~a[31] & ~b[31] & add_result[31]) 
                      | ((alu_ctl==4'b0001) & a[31] & b[31] & ~add_result[31])
                      | ((alu_ctl==4'b0011) & a[31] & ~b[31] & ~add_result[31]) 
					  | ((alu_ctl==4'b0011) & ~a[31] & b[31] & add_result[31]);
endmodule
