#include <iostream>

using namespace std;

double HERMITER ( int orden, float x)
{
  double res;
  if( orden == 0 ){
    res = 1;
  }else {
    if (orden == 1) {
      res = 2 * x;
    } else {
      int ordenmenosuno =orden -1;
      double aux1;
      aux1=HERMITER( ordenmenosuno- 1, x);
      aux1 *= (ordenmenosuno);
      aux1 *= 2;
      res=HERMITER(ordenmenosuno, x);
      res*= x;
      res*= 2;
      res = res - aux1;
    }
  }

  return res;
}

double HERMITEI( int orden, float x)
{
  double res = 0;
  double H1 = 1;
  double H2 = 2 * x;
   if( orden == 0 ){
     return H1;
   }else if( orden == 1 ){
      return H2;
   }
  for ( int i = 2; i <= orden; i++ ){
    res = ( 2 * x * H2 ) - ( 2 * ( ( ( double ) i)- 1 ) * H1 );
    H1 = H2;
    H2 = res;
  }
  return res;
}

int main ( void )
{
  int orden;
  double x;
  double resultado = 0;

  cout << "Introduzca el orden: ";
  cin >> orden;
  cout << "Introduzca el valor de 'X': ";
  cin >> x;

  resultado = HERMITER ( orden, x );

  cout << "El resultado recursivo es: " << resultado << endl;
  resultado = HERMITEI ( orden, x );

  cout << "El resultado iterativo es: " << resultado << endl;
  return 0;
}