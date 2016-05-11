
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset_I,
 output wire [7:0] oLed

 
);

wire [15:0] wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken, rWriteLCD;
reg [7:0]	rCaracter;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]  rResult, rResultTop;
wire [31:0] wMult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination, wInstructionSave;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;
wire [15:0] wA,wB,wResltAnt;
wire [3:0] oLCD_Data;
wire oLCD_Enabled, oLCD_RegisterSelect,oLCD_StrataFlashControl, oLCD_ReadWrite;
wire Reset; //Reset que sale de LCD

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

Module_Power_On_LCD  LCD(

	.Clock(Clock),
	.Reset(Reset_I),
	.LCD_Write(rWriteLCD),
	.Nibble(rCaracter),
	.oLCD_Enabled(oLCD_Enabled),
	.oLCD_RegisterSelect(oLCD_RegisterSelect),
	.oLCD_StrataFlashControl(oLCD_StrataFlashControl),
	.oLCD_ReadWrite(oLCD_ReadWrite),
	.RstAlu(Reset),
	.oLCD_Data(oLCD_Data)


);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D(wB),
	.Q( oLed    )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_IDST
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( 1'b1 ),
	.D( wDestination ),
	.Q( wInstructionSave )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 ) FF_Result
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( 1'b1 ),
	.D( rResult ),
	.Q( wResltAnt )
);




assign wImmediateValue = {wSourceAddr1,wSourceAddr0};
//HAZARD CONTROL RED WRITE
//RegistrosDeLectura == RegistrosDeEscritura Anterior => Asignar Data como el resultado
assign wA = ( wSourceAddr0 == wInstructionSave) ? wResltAnt : wSourceData0;
assign wB = ( wSourceAddr1 == wInstructionSave) ? wResltAnt : wSourceData1;

always @ ( * ) begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end	
	//-------------------------------------
	`SMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		{rResultTop,rResult}  <= wA * wB;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end
	
	//-------------------------------------
	`IMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		{rResultTop,rResult}  <= wMult;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end

	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wA + wB;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
		if (wB <= wA )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
	end
	//-------------------------------------
	`LCD:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rWriteLCD 	 <= 1;
		rCaracter    <= {wA[3:0],wB[3:0]}; //
	end
	
	
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rWriteLCD 	 <=0;
		rCaracter    <=0;
		
		
	end	
	//-------------------------------------	
	endcase	
end


endmodule
