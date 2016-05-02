`define N  16

module MULTPLY_CELL
(
input wire [15:0]  iA,iB,
output wire [31:0] oR
);


wire [`N-1 : 0 ] wCarry [`N-1 : 0];
wire [`N-1 : 0 ] wR[`N  : 0];


genvar C,R;
generate 

		for (C = 0; C < `N; C = C + 1)
		begin : COL_inicial 

			if(C == `N-1) begin
				assign wR[0][`N] = wCarry[0][`N-1]; //wCarry de la col final
	
				MODULE_ADDER ADD_0_F
				(
					.iA( 0 ), 
					.iB(  iA[C] & iB[1] ), 	 
					.iCi( wCarry[ 0 ][ C ]     ),   	 
					.oCo( wCarry[ 0 ][C+1]   ), 
					.oRo( wR[0][C]   )
				);

			end//if(C == `N-1)

			if(C<`N-1)	begin	
			MODULE_ADDER ADD_0_X
				(
					.iA(  iA[C+1]&iB[0]), 
					.iB(  iA[C] & iB[1] ), 	 
					.iCi( wCarry[ 0 ][ C ]     ),   	 
					.oCo( wCarry[ 0 ][C+1]   ), 
					.oRo( wR[0][C]   )
				);
			end//if(C<`N-1)
		end//for (C = 0; C < `N; C = C + 1)
	


	for (R = 1; R < `N; R = R + 1)
	begin : ROW 

		for (C = 0; C < `N; C = C + 1)
		begin : COL 

			if(C == `N-1) 
			begin

				assign wR[R][`N] = wCarry[R][`N]; //wCarry de la col final

			end
			else
		   begin
				MODULE_ADDER ADD_X_X
				(
					.iA(  wR[R - 1 ][ C + 1] ), 
					.iB(  iA[C] & iB[ R + 1] ), 	 
					.iCi( wCarry[ R ][ C ]     ),   	 
					.oCo( wCarry[ R ][C+1]   ), 
					.oRo( wR[R][C]   )
				);
				
				if (R == `N-1)begin
					assign oR[C+(`N-1)] = wR[`N-1][C]; //Ultima fila asignar los resultados 
					end
			end//if(C == `N-1)

		end//for (C = 0; C < `N; C = C + 1)
	if(R<`N-1)
		assign oR[ R  ] = wR[ R ][ 0 ]; 
		
	end//for (R = 1; R < `N; R = R + 1)

endgenerate


assign oR[0] = iA[0] & iB[0];
assign oR[31] = wCarry[15][15];
assign oR[14]=wR[14][0];



endmodule


   

module MODULE_ADDER
(
    input  wire  	iA,
    input  wire  	iB, //Resultado anterior
    input  wire  	iCi,
    output wire  	oCo,
    output wire 	oRo
);

assign {oCo,oRo} = iA + iB + iCi;

endmodule

