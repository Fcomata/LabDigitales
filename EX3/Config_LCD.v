`timescale 1ns / 1ps
`define STATE_RESET 0
`define STATE_CONFIG_INIT_0 1
`define STATE_CONFIG_INIT_1 2
`define STATE_CONFIG_INIT_2 3
`define STATE_CONFIG_INIT_3 4



module Module_Config_LCD
(
	input wire Clock,
	input wire Reset,
	output wire oLCD_Enabled,
	output reg oLCD_RegisterSelect, //0=Command, 1=Data
	output wire oLCD_StrataFlashControl,
	output wire oLCD_ReadWrite,
	output reg[3:0] oLCD_Data
	);



reg rWrite_Enabled;
assign oLCD_ReadWrite = 0; //I only Write to the LCD display, never Read from it
assign oLCD_StrataFlashControl = 1; //StrataFlash disabled. Full read/write access to LCD
assign oLCD_Enabled = 1;

reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;
wire wWriteDone;

//----------------------------------------------
//Next State and delay logic
	always @ ( posedge Clock )

	if (Reset)
		begin
			rCurrentState = `STATE_RESET;
			rTimeCount <= 32'b0;
		end
		else
		begin
			if (rTimeCountReset)
				rTimeCount <= 32'b0;
		else
			rTimeCount <= rTimeCount + 32'b1;
			rCurrentState <= rNextState;
		end
	end
//----------------------------------------------
//Current state and output logic
	always @ ( * )
	begin
		case (rCurrentState)
//------------------------------------------
		`STATE_RESET:
			begin
				rWrite_Enabled = 1'b0;
				oLCD_Data = 4'h0;
				oLCD_RegisterSelect = 1'b0;
				rTimeCountReset = 1'b0;
				rNextState = `STATE_CONFIG_INIT_0;
			end



			

			default:
			begin
				rWrite_Enabled = 1'b0;
				oLCD_Data = 4'h0;
				oLCD_RegisterSelect = 1'b0;
				rTimeCountReset = 1'b0;
				rNextState = `STATE_RESET;
			end
//------------------------------------------
		endcase
	end
endmodule
