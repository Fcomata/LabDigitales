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
	3: oInstruction = { `STO , `R7,16'd1};
	4: oInstruction = { `STO ,`R3,16'd3}; 
	5: oInstruction = { `STO, `R4,16'd2};
	6: oInstruction = { `STO, `R5,16'd4};
	7: oInstruction = { `TMUL ,`R4,`R5,`R3}; 
	8: oInstruction = { `NOP ,24'd4000    };
	9: oInstruction = { `TMUL ,`R5,`R4,`R3}; 
	10: oInstruction = { `NOP ,24'd4000    };
	
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
