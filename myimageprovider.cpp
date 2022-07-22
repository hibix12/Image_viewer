#include "myimageprovider.h"
#include "backend.h"

MyImageProvider::MyImageProvider()
    :QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

QPixmap MyImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{

    const int width = requestedSize.width() > 0 ? requestedSize.width() : 100;
    const int height = requestedSize.height() > 0 ? requestedSize.height() : 50;
    //qDebug( "Height: %d  width: %d", height, width  );

    if (size != nullptr)
    {
        *size = QSize(width, height);
    }
    QPixmap pixmap(width, height);

    //qDebug(id.toLatin1());

    if(id != "")
{
        QStringList path = id.split("///");

        if(path[1] != ""){
            pixmap.load(path[1]);
            image = pixmap.copy();
            image_original = image.copy();
           // qDebug("Załadowano");
            image = image.scaledToWidth(width);


        }
        for(int i = 2; i<path.length();i++){
            if(path[i] == "left_rotate"){
                image =  image.transformed(QTransform().rotate(-90)); //rotacja
              }
            else if(path[i] == "right_rotate"){
                image =  image.transformed(QTransform().rotate(90)); //rotacja
            }
            else if(path[i] == "reset"){
                image =  image_original;  //reset
            }
            else if(path[i] == "pion"){
                  image =  image.transformed(QTransform().scale(-1, 1)); //przerzucanie przez osie
            }
            else if(path[i] == "poziom"){
                  image =  image.transformed(QTransform().scale(1, -1)); //przerzucanie przez osie
            }
            else if(path[i].contains("plus")){
                QStringList help  = path[i].split(":");
                  image =  image.transformed(QTransform().scale(help[1].toDouble(), help[1].toDouble())); //przerzucanie przez osie

            }
            else if(path[i] == "minus"){
                  image =  image.transformed(QTransform().scale(1, -1)); //przerzucanie przez osie

            }
            else if(path[i] == "convert"){
                  imageQ = image.toImage();
                  imageQ.convertTo(QImage::Format_Grayscale8, Qt::AutoColor);
                  image.convertFromImage(imageQ,Qt::AutoColor);


            }
            else if(path[i].contains("save")){
                i++;
                image.save(path[i], "png");
             //qDebug(" Path: %s", path[i].toStdString().c_str());

            }
        }

    }

    return image;

}
