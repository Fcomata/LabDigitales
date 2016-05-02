module TMUL(
	input wire [15:0] A,
	input wire [15:0] B,
	output wire [31:0] O 
);

	wire [11:0] Carry; //colunmas
	wire [5:0] Temp; //colunmas


//condicion inicial
	MODULE_ADDER bloquecitoI (
		.wA(A[0]&B[0]),
		.wB(0),
		.wCi(0),
		.wCo(Carry[0]),
		.wRo(O[0])
	);


//primer fila 

	MODULE_ADDER bloquecito1C1F (
		.wA(A[0]&B[1]),
		.wB(A[1]&B[0]),
		.wCi(Carry[0]),
		.wCo(Carry[1]),
		.wRo(O[1])
	);

	MODULE_ADDER bloquecito2C1F (
		.wA(A[2]&B[0]),
		.wB(A[1]&B[1]),
		.wCi(Carry[1]),
		.wCo(Carry[2]),
		.wRo(Temp[0])
	);

	MODULE_ADDER bloquecito3C1F (
		.wA(A[3]&B[0]),
		.wB(A[2]&B[1]),
		.wCi(Carry[2]),
		.wCo(Carry[3]),
		.wRo(Temp[1])
	);

	MODULE_ADDER bloquecito4C1F (
		.wA(0),
		.wB(A[3]&B[1]),
		.wCi(Carry[3]),
		.wCo(Carry[4]),
		.wRo(Temp[2])
	);

//segunda fila

	MODULE_ADDER bloquecito2C2F (
		.wA(Temp[0]),
		.wB(A[0]&B[2]),
		.wCi(0),
		.wCo(Carry[5]),
		.wRo(O[2])
	);

	MODULE_ADDER bloquecito3C2F (
		.wA(Temp[1]),
		.wB(A[1]&B[2]),
		.wCi(Carry[5]),
		.wCo(Carry[6]),
		.wRo(Temp[3])
	);

	MODULE_ADDER bloquecito4C2F (
		.wA(Temp[2]),
		.wB(A[2]&B[2]),
		.wCi(Carry[6]),
		.wCo(Carry[7]),
		.wRo(Temp[4])
	);

	MODULE_ADDER bloquecito5C2F (
		.wA(Carry[4]),
		.wB(A[3]&B[2]),
		.wCi(Carry[7]),
		.wCo(Carry[8]),
		.wRo(Temp[5])
	);

//tercer fila

	MODULE_ADDER bloquecito3C3F (
		.wA(Temp[3]),
		.wB(A[0]&B[3]),
		.wCi(0),
		.wCo(Carry[9]),
		.wRo(O[3])
	);

	MODULE_ADDER bloquecito4C3F (
		.wA(Temp[4]),
		.wB(A[1]&B[3]),
		.wCi(Carry[9]),
		.wCo(Carry[10]),
		.wRo(O[4])
	);

	MODULE_ADDER bloquecito5C3F (
		.wA(Temp[5]),
		.wB(A[2]&B[3]),
		.wCi(Carry[10]),
		.wCo(Carry[11]),
		.wRo(O[5])
	);

	MODULE_ADDER bloquecito6C3F (
		.wA(Carry[8]),
		.wB(A[3]&B[3]),
		.wCi(Carry[11]),
		.wCo(O[7]),
		.wRo(O[6])
	);




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
