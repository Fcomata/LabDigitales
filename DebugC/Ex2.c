#include <iostream>
using namespace std;

int main ()
{

int R=0;
for (int C = 0; C < 16; C++){
		

			if(C == 15) {
			cout<<"assign wR[0][15]=wCarry[0][14];"<<endl; //wCarry de la col final
	
cout<<"["<<R<<"]["<<C<<"]"<<" (.iA(0),.iB(iA["<<C<<"]&iB[1]),.iCi(wCarry[0]["<<C<<"]), .oCo(wCarry[0]["<<C+1<<"]),.oRo(wR[0]["<<C<<"]   )"<<endl;
				

			}

			if(C<15)	{	
cout<<"["<<R<<"]["<<C<<"]"<<" (.iA(iA["<<C+1<<"]&iB[0]),.iB(iA["<<C<<"]&iB[1]),.iCi(wCarry[0]["<< C<<"] ),.oCo( wCarry[0]["<<C+1<<"]), .oRo( wR[0]["<<C<<"])"<<endl;
				
			}
		}
	

cout<<endl<<"FIN PRIMERA FILA"<<endl<<endl;

	for (int R = 1; R < 16; R++){
	

		for (int C = 0; C < 16; C++){
		

			if(C == 15) {
			

				cout << "assign wR["<<R<<"][15] = wCarry["<<R<<"][15];"<<endl; 

			}
			else{
		  
			cout<<"["<<R<<"]["<<C<<"]"<< " (.iA(wR["<<R-1<<" ]["<<C + 1<<"]),.iB(iA["<<C<<"]&iB["<< R + 1<<"]),.iCi(wCarry["<< R<<"]["<< C<<"]),.oCo(wCarry["<< R <<"]["<<C+1<<"]),.oRo(wR["<<R<<"]["<<C<<"])"<<endl;
				
				
				if (R == 15){
					cout<<endl<<"ASIGNAR RESULTADO"<<endl<<endl;
					cout<<"assign oR["<<C+(15)<<"]=wR[15]["<<C<<"];"<<endl; //Ultima fila asignar los resultados

			}
					
			}

	

		}

	
	cout<<endl<<"FIN FILA"<<endl<<endl;
	if(R<14){
	cout<<"assign oR["<<R<<"]=wR["<< R<<"][0];"<<endl; 
	

	}	
}


cout<<"Invariables"<<endl;
	cout<<"assign oR[31] = wCarry[15][15];"<<endl;
	cout<<"assign oR[0] = iA[0] & iB[0];"<<endl;
 	cout<<"assign oR[14]=wR[14][0];"<<endl;
}
