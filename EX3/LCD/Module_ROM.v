`timescale 1ns / 1ps
`include "Defintions.v"

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `NOP ,24'd4000    };
	2: oInstruction = { `NOP ,24'd4000    };
	
	3: oInstruction = { `STO ,`R3,16'h4}; 
	4: oInstruction = { `STO, `R4,16'h8};
	
	5: oInstruction = { `LCD, `R4,`R3,`R4};//H
	
	6: oInstruction = { `STO ,`R3,16'h4}; 
	7: oInstruction = { `STO, `R4,16'hF};
	
	8: oInstruction = { `LCD, `R4,`R3,`R4};//O
	
	9: oInstruction = { `STO ,`R3,16'h4}; 
	10: oInstruction = { `STO, `R4,16'hC};
	
	11: oInstruction = { `LCD, `R4,`R3,`R4};//L
	
	12: oInstruction = { `STO ,`R3,16'h4}; 
	13: oInstruction = { `STO, `R4,16'h1};
	
	14: oInstruction = { `LCD, `R4,`R3,`R4};//A
	
	15: oInstruction = { `NOP ,24'd4000    };

	
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
