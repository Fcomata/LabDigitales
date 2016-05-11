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
	6: oInstruction = { `NOP ,24'd4000};
	7: oInstruction = { `BNE , 8'd6, 16'd0};
	
	8: oInstruction = { `STO ,`R3,16'h4}; 
	9: oInstruction = { `STO, `R4,16'hF};
	
	10: oInstruction = { `LCD, `R4,`R3,`R4};//O
	11: oInstruction = { `NOP ,24'd4000};
	12: oInstruction = { `BNE , 8'd11, 16'd0};
	
	13: oInstruction = { `STO ,`R3,16'h4}; 
	14: oInstruction = { `STO, `R4,16'hC};

	15: oInstruction = { `LCD, `R4,`R3,`R4};//L
	16: oInstruction = { `NOP ,24'd4000};
	17: oInstruction = { `BNE , 8'd16, 16'd0};
	
	18: oInstruction = { `STO ,`R3,16'h4}; 
	19: oInstruction = { `STO, `R4,16'h1};
	
	20: oInstruction = { `LCD, `R4,`R3,`R4};//A
	21: oInstruction = { `NOP ,24'd4000};
	22: oInstruction = { `BNE , 8'd21, 16'd0};
	
	23: oInstruction = { `NOP ,24'd4000    };
	
	/*`ifdef NOUSE
	
		{ LCD, CHARATER_A };
	//17	
		{ NOP }
		{ BNE, 17, R_BUSY, R0 }
	`endif
*/
	
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
