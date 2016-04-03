
`define FILAMAX 14 //PRIMERA ITERACION TRAGA DOS LINEAS
`define COLMAX 15

//problemas existenciales 
// 1) el resultado es de 2n osea O pero en que iteracion meto los n+1... resultados
// sera que la ultima fila agarra los resultados como O[fila+col]

// 2) 


module IMUL(
	input wire [15:0] A,
	input wire [15:0] B,
	output wire [31:0] O 
);

	wire [15:0] Carry [15:0]; //colunmas
	wire [15:0] Temp [15:0]; //filas X colunmas

//primer fila  0 

	genvar fila, col;
generate
for(fila = 0 ; fila < FILAMAX ; fila = fila + 1) begin
	for(col = 0 ; col < COLMAX ; col = col + 1) begin

			if(fila == 0) begin

				if (col == 0) begin //condicion inicial

						MODULE_ADDER bloquecito0C0 (.wA(A[0]&B[0]),.wB(0),
															 .wCi(0),
															 .wCo(Carry[0][0]),.wRo(Temp[0][0]));
															 
						assign O[fila] = Temp[fila][0];

				end //end col ==0
				 
				if (col > 0 && col < COLMAX) begin
				 
					MODULE_ADDER bloquecito0CX (.wA(A[col]&B[0]),.wB(A[col+1]&B[1]),
														 .wCi(Carry[0][col]),
														 .wCo(Carry[0][col]),.wRo(Temp[0][col]));
						
					end //end col X
						
				if (col == COLMAX) begin
				 
					MODULE_ADDER bloquecito0Cmax (.wA(0),.wB(A[col+1]&B[1]),
															.wCi(Carry[0][col]),
															.wCo(Carry[0][col]),.wRo(Temp[0][col]));
				end //end fila max
			
		end //fila 0
			
		// fila X
		if(fila > 0 && fila <  FILAMAX) begin
				
			if(col==0) begin
				MODULE_ADDER bloquecitoXC0 (.wA(A[col]&B[fila+1]),.wB(Temp[fila-1][col+1]),
													 .wCi(Carry[fila][col]),
													 .wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
				 
				assign O[fila] = Temp[fila][0];  //assign O[fila] = Temp[fila][0]

			end //end col 0

			if(col > 0 && col < COLMAX) begin

				MODULE_ADDER bloquecitoXCX (.wA(A[col]&B[fila+1]),.wB(Temp[fila-1][col+1]),
													 .wCi(Carry[fila][col]),
													 .wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
			 
			end //end col X

			if(col==COLMAX)
					
				MODULE_ADDER bloquecitoXCmax (.wA(A[col]&B[fila+1]),.wB(Carry[fila-1][col]),
														.wCi(Carry[fila][col]),
														.wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
			end //end col max

		end //end if fila = X


		if (fila == FILAMAX) begin

			if(col==0) begin
				MODULE_ADDER bloquecitomaxC0 (.wA(A[col]&B[fila+1]),.wB(Temp[fila-1][col+1]),
														.wCi(Carry[fila][col]),
														.wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
				 
				assign O[fila] = Temp[fila][0];  //assign O[fila] = Temp[fila][0]

			end //end col 0

			if(col > 0 && col < COLMAX) begin

				MODULE_ADDER bloquecitomaxCX (.wA(A[col]&B[fila+1]),.wB(Temp[fila-1][col+1]),
														.wCi(Carry[fila][col]),
														.wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
													 
				//ASI ES ?? assign O[fila+col] = Temp[fila][col];
			end//end col X

			if(col==COLMAX)
					
				MODULE_ADDER bloquecitomaxCmax (.wA(A[col]&B[fila+1]),.wB(Carry[fila-1][col]),
														  .wCi(Carry[fila][col]),
														  .wCo(Carry[fila][col]), .wRo(Temp[fila][col]));
														
				//ASI ES ?? assign O[fila+col] = Temp[fila][col];
			end //end col max

		end //end if FILAMAX


	end //end for col
end //end for filas

endgenerate

endmodule

   

module MODULE_ADDER
(
    input  wire  	wA,
    input  wire  	wB, //Resultado anterior
    input  wire  	wCi,
    output wire  	wCo,
    output wire 	wRo
);

assign {wCo,wRo} = wA + wB + wCi;

endmodule
