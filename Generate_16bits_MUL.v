
`define N = 16;

module MULTPLY_CELL
(
input wire [15:0]  iA,iB,
output wire [31:0] oR,
);


wire [`N-1 : 0 ] wCarry [`N -1 : 0];
wire [`N-1 : 0 ] wR[`N  : 0];







genvar C,R;
generate 

	if(R==1)
		for (C = 0; C < `N; C = C + 1)
		begin : COL_inicial 

			if(C == `N-1) begin
				assign wR[R][`N] = Carry[R][`N-1]; //Carry de la col final
	
				MODULE_ADDER ADD_0_0
				(
					.iA( 0 ), 
					.iB(  iA[C] & iB[1] ), 	 
					.iCi( wCarry[ 0 ][ C ]     ),   	 
					.oCo( wCarry[ 0 ][C+1]   ), 
					.oRo( wR[0][C]   )
				);

			end

			if(C<`N-1)	begin	
			MODULE_ADDER ADD_0_0
				(
					.iA(  iA[C+1]&iB[0]), 
					.iB(  iA[C] & iB[1] ), 	 
					.iCi( wCarry[ 0 ][ C ]     ),   	 
					.oCo( wCarry[ 0 ][C+1]   ), 
					.oRo( wR[0][C]   )
				);
			end
			
	
		
		end
	end

	for (R = 1; R < `N; R = R + 1)
	begin : ROW 


		for (C = 0; C < `N; C = C + 1)
		begin : COL 

			if(C == `N) begin

				assign wR[R][`N] = Carry[R][`N]; //Carry de la col final

			else
		
				MODULE_ADDER ADD_X_X
				(
					.iA(  wR[R - 1 ][ C + 1] ), 
					.iB(  iA[C] & iB[ R + 1] ), 	 
					.iCi( wCarry[ R ][ C ]     ),   	 
					.oCo( wCarry[ R ][C+1]   ), 
					.oRo( wR[R][C]   )
				);
				if (R == `N-1)
					assign oR[C+(`N-1)] = wR[`N-1][C+(`N-1)]; //Ultima fila asignar los resultados
			end

		end

		assign oR[ R  ] = wR[ R ][ 0 ]; 
	end

endgenerate


assign oR[0] = iA[0] & iB[0];




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

