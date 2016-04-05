`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'd1};
	2: oInstruction = { `STO ,`R3,16'd5}; 
	3: oInstruction = { `STO, `R4,16'd10};
	4: oInstruction = { `STO, `R5,16'd8 };
	5: oInstruction = { `ADD ,`R4,`R5,`R3}; 
	6: oInstruction = { `ADD ,`R5,`R4,`R3}; 
	7: oInstruction = { `NOP ,24'd4000    };
	8: oInstruction = { `NOP ,24'd4000    };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
