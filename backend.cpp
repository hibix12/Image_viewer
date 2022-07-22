#include "backend.h"
#include "myimageprovider.h"

bool black_or_color = 0;

BackEnd::BackEnd(QObject *parent) :QObject(parent)
{
}

void BackEnd::changeValue(int a)
{
    if(a ==1){
        valueChanged("Wartosc zmieniona: 1");
    }
    else if(a == 2){
       valueChanged("Wartosc zmieniona: 2");
    }
    else{
        valueChanged("Trzecia opcja");
    }
}
void BackEnd::imageRead(QString a)
{
   valueChanged(a);

}

void BackEnd::imageRotate(bool direction)
{
    if(direction){
        valueChanged("Obrót w lewo");
    }
    else {
        valueChanged("Obrót w prawo");

    }
}

void BackEnd::imageRefresh()
{
    valueChanged("Przywrócenie obrazu");
}

void BackEnd::imageMono()
{
    if(black_or_color){
        valueChanged("Obraz czarnobiały");
        black_or_color = !black_or_color;
    }
    else{
        valueChanged("Obraz kolorowy");
        black_or_color = !black_or_color;


    }

}

