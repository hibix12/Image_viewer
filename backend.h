#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <qqml.h>
#include <QQuickImageProvider>
#include <QImage>


class BackEnd : public QObject
{
    Q_OBJECT

public:
    explicit BackEnd(QObject *parent = nullptr);

signals:
    void valueChanged(QString s);
    void imageShow(QByteArray s);


public slots:
    void changeValue(int a);
    void imageRead(QString a);
    void imageRotate(bool direction);
    void imageRefresh();
    void imageMono();

};

#endif // BACKEND_H
