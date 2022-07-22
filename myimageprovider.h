#ifndef MYIMAGEPROVIDER_H
#define MYIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QImage>
#include <QIcon>


class MyImageProvider : public QQuickImageProvider
{
public:
    MyImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;

    QPixmap image, image_original, image_scaled;
    QImage imageQ;
};

#endif // MYIMAGEPROVIDER_H
