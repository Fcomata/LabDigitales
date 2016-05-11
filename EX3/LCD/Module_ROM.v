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

	4: oInstruction = { `NOP ,24'd4000    };
	5: oInstruction = { `NOP ,24'd4000    };
	6: oInstruction = { `NOP ,24'd4000    };
	
	7: oInstruction = { `STO ,`R3,16'h4}; 
	8: oInstruction = { `STO, `R4,16'h8};
	
	9: oInstruction = { `LCD, `R4,`R3,`R4};//H
	10: oInstruction = { `NOP ,24'd4000};
	11: oInstruction = { `BNE , 8'd6, 16'd0};
	
	12: oInstruction = { `STO ,`R3,16'h4}; 
	13: oInstruction = { `STO, `R4,16'hF};
	
	14: oInstruction = { `LCD, `R4,`R3,`R4};//O
	15: oInstruction = { `NOP ,24'd4000};
	16: oInstruction = { `BNE , 8'd11, 16'd0};
	
	17: oInstruction = { `STO ,`R3,16'h4}; 
	18: oInstruction = { `STO, `R4,16'hC};

	19: oInstruction = { `LCD, `R4,`R3,`R4};//L
	20: oInstruction = { `NOP ,24'd4000};
	21: oInstruction = { `BNE , 8'd16, 16'd0};
	
	22: oInstruction = { `STO ,`R3,16'h4}; 
	23: oInstruction = { `STO, `R4,16'h1};
	
	24: oInstruction = { `LCD, `R4,`R3,`R4};//A
	25: oInstruction = { `NOP ,24'd4000};
	26: oInstruction = { `BNE , 8'd21, 16'd0};
	
	27: oInstruction = { `NOP ,24'd4000    };
	
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
