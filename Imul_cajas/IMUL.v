module IMUL(
	input wire [15:0] A,
	input wire [15:0] B,
	output wire [31:0] O 
);

	wire [15:0] Carry [0:0]; //colunmas
	wire [5:0] Temp [0:0]; //colunmas

//primer fila  0 

//condicion inicial
	MODULE_ADDER bloquecito0C0 (
		.wA(A[0]&B[0]),
		.wB(0),
		.wCi(0),
		.wCo(Carry[0][0]),
		.wRo(Temp[0][0])
	);

	assign O[0] = Temp[0][0];

 
	MODULE_ADDER bloquecito0C1 (
		.wA(A[1]&B[0]),
		.wB(A[0]&B[1]),
		.wCi(Carry[0][0]),
		.wCo(Carry[0][1]),
		.wRo(Temp[0][1])
	);

	MODULE_ADDER bloquecito0C2 (
		.wA(A[2]&B[1]),
		.wB(A[3]&B[0]),
		.wCi(Carry[0][1]),
		.wCo(Carry[0][2]),
		.wRo(Temp[0][2])
	);

	MODULE_ADDER bloquecito0C3 (
		.wA(A[3]&B[1]),
		.wB(0),
		.wCi(Carry[0][2]),
		.wCo(Carry[0][3]),
		.wRo(Temp[0][3])
	);

// fila 1

	

	MODULE_ADDER bloquecito1C0 (
		.wA(A[0]&B[2]),
		.wB(Temp[0][1]),
		.wCi(Carry[1][0]),
		.wCo(Carry[1][0]),
		.wRo(Temp[1][0])
	);
 
	//if(colunm==0) 
	assign O[1] = Temp[1][0];  //assign O[fila] = Temp[fila][0]
	//endif

	MODULE_ADDER bloquecito1C1 (
		.wA(A[1]&B[2]),  //A[col] & B [fila+1]
		.wB(Temp[0][2]), //Temp[fila-1][col+1]
		.wCi(Carry[1][1]), // Carry[fila][col]
		.wCo(Carry[1][1]), // Carry[fila][col]
		.wRo(Temp[1][1]) // Temp [fila][col]
	);

	MODULE_ADDER bloquecito1C2 (
		.wA(A[2]&B[2]),  //A[col] & B [fila+1]
		.wB(Temp[0][3]), //Temp[fila-1][col+1]
		.wCi(Carry[0][2]), // Carry[fila][col]
		.wCo(Carry[1][2]), // Carry[fila][col]
		.wRo(Temp[1][2]) // Temp [fila][col]
	);

	//if(colunm==COLMAX)

	MODULE_ADDER bloquecito1C3 (
		.wA(A[3]&B[2]),  //A[col] & B [fila+1]
		.wB(Carry[0][2]), //Carry[fila-1][col] ..Carry
		.wCi(Carry[0][3]), // Carry[fila][col]
		.wCo(Carry[1][3]), // Carry[fila][col]
		.wRo(Temp[1][3]) // Temp [fila][col]
	);

	//endif



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
