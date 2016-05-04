`timescale 1ns / 1ps
`define STATE_RESET 0
`define STATE_POWERON_INIT_0 1
`define STATE_POWERON_INIT_1 2
`define STATE_POWERON_INIT_2 3
`define STATE_POWERON_INIT_3 4
`define STATE_POWERON_INIT_4 5
`define STATE_POWERON_INIT_5 6
`define STATE_POWERON_INIT_6 7
`define STATE_POWERON_INIT_7 8
`define STATE_POWERON_INIT_8 9
`define STATE_POWERON_INIT_9 10
`define STATE_POWERON_INIT_10 11
`define STATE_POWERON_INIT_11 12
`define STATE_POWERON_INIT_12 13
`define STATE_POWERON_INIT_13 14
`define STATE_POWERON_INIT_14 15
`define STATE_POWERON_INIT_15 16
`define STATE_POWERON_INIT_16 17
`define STATE_POWERON_INIT_17 18
`define STATE_POWERON_INIT_18 19
`define STATE_POWERON_INIT_19 20

module Module_Power_On_LCD
(
	input wire Clock,
	input wire Reset,
	input wire LCD_Write,
	input wire Nibble[7:0],
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
				rNextState = `STATE_POWERON_INIT_0;
				

			end

			//------------------------------------------
			/*
			Wait 15 ms or longer.
			The 15 ms interval is 750,000 clock cycles at 50 MHz.
			*/

			`STATE_POWERON_INIT_0:
			begin
				rWrite_Enabled = 1'b0;
				oLCD_Data = 4'h0;
				oLCD_RegisterSelect = 1'b0; //these are commands


			if (rTimeCount > 32'd750000 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_1;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_0;
				end
			end

			//------------------------------------------
			/*
			Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
			*/

			`STATE_POWERON_INIT_1:
			begin
				rWrite_Enabled = 1'b1;
				oLCD_Data = 4'h3;
				oLCD_RegisterSelect = 1'b0; //these are commands

				if (rTimeCount > 32'd12 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_2;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_1;
				end
			end
			//------------------------------------------
			/*
			Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
			*/

			`STATE_POWERON_INIT_2:
			begin
				rWrite_Enabled = 1'b0;
				oLCD_Data =  4'h0;
				oLCD_RegisterSelect = 1'b0; //these are commands
	

				if (rTimeCount > 32'd205000 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_3;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_2;
				end
			end


			//------------------------------------------
/*			Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
*/
			//------------------------------------------

			`STATE_POWERON_INIT_3:
			begin
				rWrite_Enabled = 1'b1;
				oLCD_Data = 4'h3;
				oLCD_RegisterSelect = 1'b0;
				rTimeCountReset = 1'b1;



			if (rTimeCount > 32'd12 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_4;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_3;
				end
			
			end

			//------------------------------------------

/*			Wait 100 μs or longer, which is 5,000 clock cycles at 50 MHz.
*/

			//------------------------------------------

			`STATE_POWERON_INIT_4:
			begin

				rWrite_Enabled = 1'b0;
				oLCD_Data =  4'h0;
				oLCD_RegisterSelect =  1'b0;

				if (rTimeCount > 32'd5000 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_5;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_4;
				end
			end

			//------------------------------------------

/*			Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles
*/

			//------------------------------------------

			`STATE_POWERON_INIT_5:
			begin
				rWrite_Enabled = 1'b1;
				oLCD_Data = 4'h3;
				oLCD_RegisterSelect = 1'b0;
				rTimeCountReset = 1'b1;

				if (rTimeCount > 32'd12 )
					begin
						rTimeCountReset = 1'b1;
						rNextState = `STATE_POWERON_INIT_6;
					end
					else
					begin
						rTimeCountReset = 1'b0;
						rNextState = `STATE_POWERON_INIT_5;
					end
			
			end

			//------------------------------------------

/*			Wait 40 μs or longer, which is 2,000 clock cycles at 50 MHz
*/

			//------------------------------------------

			`STATE_POWERON_INIT_6:
			begin

				rWrite_Enabled = 1'b0;
				oLCD_Data =  4'h0;
				oLCD_RegisterSelect = 1'b0;
				if (rTimeCount > 32'd2000 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_7;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_6;
				end
			end

			//------------------------------------------

/*			Write SF_D<11:8> = 0x2, pulse LCD_E High for 12 clock cycles.
*/

			//------------------------------------------

			`STATE_POWERON_INIT_7:
			begin
				rWrite_Enabled = 1'b1;
				oLCD_Data = 4'h2;
				oLCD_RegisterSelect = 1'b0;
				rTimeCountReset = 1'b1;

				if (rTimeCount > 32'd12 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_8;
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_7;
				end
			
			end

			//------------------------------------------

/*			Wait 40 μs or longer, which is 2,000 clock cycles at 50 MHz
*/
			//------------------------------------------

			`STATE_POWERON_INIT_8:
			begin
			end

				rWrite_Enabled = 1'b0;
				oLCD_Data =  4'h0;
				oLCD_RegisterSelect = 1'b0;

				if (rTimeCount > 32'd2000 )
				begin
					rTimeCountReset = 1'b1;
					rNextState = `STATE_POWERON_INIT_9; //END POWER ON
				end
				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_8;
				end





			//------------------------------------------
			/*
			Issue a Function Set command, 0x28, to POWERONure the display for operation on the
			Spartan-3E Starter Kit board.
			*/

			`STATE_POWERON_INIT_9:
			begin
				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//FIRST NIBBLE
				oLCD_Data = 4'h2;

				if (rTimeCount > 32'd50 ) //Pasa 1uS 
				begin
					rNextState = `STATE_POWERON_INIT_10;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_9;
				end
			
			end

			`STATE_POWERON_INIT_10:
			begin

				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//SECOND NIBBLE
				oLCD_Data = 4'h8;
				if (rTimeCount > 32'd2000 ) //Pasa 40uS 
				begin
					rNextState = `STATE_POWERON_INIT_11;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_10;
				end
				
			end


			//------------------------------------------
			/*
			Issue an Entry Mode Set command, 0x06, to set the display to automatically
			increment the address pointer.
			*/

			`STATE_POWERON_INIT_11:
			begin
				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//FIRST NIBBLE
				oLCD_Data = 4'h0;

				if (rTimeCount > 32'd50 ) //Pasa 1uS 
				begin
					rNextState = `STATE_POWERON_INIT_12;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_11;
				end
			
			end

			`STATE_POWERON_INIT_12:
			begin

				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//SECOND NIBBLE
				oLCD_Data = 4'h6;
				if (rTimeCount > 32'd2000 ) //Pasa 40uS 
				begin
					rNextState = `STATE_POWERON_INIT_13;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_12;
				end
				
			end
			//------------------------------------------
			/*
			Issue a Display On/Off command, 0x0C, to turn the display on and disables the
			cursor and blinking.
			*/

			`STATE_POWERON_INIT_13:
			begin
				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//FIRST NIBBLE
				oLCD_Data = 4'h0;

				if (rTimeCount > 32'd50 ) //Pasa 1uS 
				begin
					rNextState = `STATE_POWERON_INIT_14;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_13;
				end
			
			end

			`STATE_POWERON_INIT_14:
			begin

				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//SECOND NIBBLE
				oLCD_Data = 4'hC;
				if (rTimeCount > 32'd2000 ) //Pasa 40uS 
				begin
					rNextState = `STATE_POWERON_INIT_15;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_14;
				end
				
			end


			//------------------------------------------
			/*
			Finally, issue a Clear Display command. Allow at least 1.64 ms (82,000 clock cycles)
			after issuing this command.
			*/
			//------------------------------------------

			`STATE_POWERON_INIT_15:
			begin
				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//FIRST NIBBLE
				oLCD_Data = 4'h0;

				if (rTimeCount > 32'd50 ) //Pasa 1uS 
				begin
					rNextState = `STATE_POWERON_INIT_16;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_15;
				end
			
			end

			`STATE_POWERON_INIT_16:
			begin

				oLCD_RegisterSelect = 0; //0=Command, 1=Data
				//SECOND NIBBLE
				oLCD_Data = 4'h1;
				if (rTimeCount > 32'd2000 ) //Pasa 40uS 
				begin
					rNextState = `STATE_POWERON_INIT_17;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_16;
				end
				
			end

			//------------------------------------------
			/*
			Write Characters
			*/
			//------------------------------------------

			`STATE_POWERON_INIT_17:
			begin
				oLCD_RegisterSelect = 1;
				if(LCD_Write)
					oLCD_Data = Nibble[7:4];

					if (rTimeCount > 32'd50 ) //Pasa 1uS 
					begin
						rNextState = `STATE_POWERON_INIT_18;
						rTimeCountReset = 1'b1;
					end

					else
					begin
						rTimeCountReset = 1'b0;
						rNextState = `STATE_POWERON_INIT_17;
				end
				else
					rNextState = `STATE_POWERON_INIT_17;
			end


			`STATE_POWERON_INIT_18:
			begin

				oLCD_RegisterSelect = 1; //0=Command, 1=Data
				//SECOND NIBBLE
				oLCD_Data = Nibble[3:0];
				if (rTimeCount > 32'd2000 ) //Pasa 40uS 
				begin
					rNextState = `STATE_POWERON_INIT_17;
					rTimeCountReset = 1'b1;
				end

				else
				begin
					rTimeCountReset = 1'b0;
					rNextState = `STATE_POWERON_INIT_18;
				end
				
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
