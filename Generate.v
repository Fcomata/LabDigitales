

// fila Generica
`define FILAMAX   4-1 //la primera fila toma dos filas por eso -1
`define COLMAX    4+1 //ciudado con el cero de col-1

genvar fila, col;

generate
for (fila = 0; fila < FILAMAX; fila = fila + 1) begin
  for (col = 0; col < COLMAX; col = col + 1) begin

if(fila == 0)begin

if(col == 0) begin  //PRIMERA Col CONDICIONES INCIALES

	MODULE_ADDER bloquecitoINICIAL (
		.wA(A[0]&B[0]),
		.wB(0),
		.wCi(0),
		.wCo(Carry[0][0]),
		.wRo(Temp[0][0])
	);

	assign O[0] = Temp[0][0];
end
if(col > 0 && col < COLMAX-1) begin
	MODULE_ADDER bloquecitoGENINICIAL (
		.wA(A[col]&B[0]),
		.wB(A[col-1]&B[1]),
		.wCi(Carry[fila][col-1]),
		.wCo(Carry[fila][col]),
		.wRo(Temp[fila][col])
	);
end
if(col == COLMAX-1) begin
	MODULE_ADDER bloquecitoGENINICIAL (
		.wA(0),
		.wB(A[col-1]&B[1]),
		.wCi(Carry[fila][col-1]),
		.wCo(Carry[fila][col]),
		.wRo(Temp[fila][col])
	);


end

end //end fila ==0

//FIN DE PRIMERA FILA

//FILAS GENERICAS
if (fila > 0 && fila < FILAMAX-1)

	if(col < COLMAX-1) begin  //CELDA GENERICA
	
	MODULE_ADDER bloquecitoGEN (
		.wA(A[col]&B[fila+1]),
		.wB(Temp[fila-1][col+1]),
		.wCi(Carry[fila][col-1]),
		.wCo(Carry[fila][col]),
		.wRo(Temp[fila][col])
	);
 
	if(col==0)  assign O[fila] = Temp[fila][0]; //PRIMERA CELDA
	
	end

	if(col == COLMAX-1) begin //ULTIMA CELDA GENERICA (CARRY B)

	MODULE_ADDER bloquecitoGENFINAL (
		.wA(A[col]&B[fila+1]),    //A[col] & B [fila+1]
		.wB(Carry[fila-1][col]),  //Carry[fila-1][col]
		.wCi(Carry[fila][col-1]), // Carry[fila][col-1]
		.wCo(Carry[fila][col]),   // Carry[fila][col]
		.wRo(Temp[fila][col]) 	  // Temp [fila][col]
	);

	end

	if(fila==FILAMAX-1 && col==COLMAX-1) 
		assign O[FILAMAX-1] = Co[fila][col];

	
end //if condicion generica


	end //end COL
   end //end FILA

endgenerate
