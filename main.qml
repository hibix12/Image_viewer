import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1
import QtQuick.Dialogs 1.3



ApplicationWindow {
    visible: true
    width: 1200
    height: 600
    title: qsTr("Image viewer")
    background: Rectangle {
            color: "darkGray"

        }
    Rectangle {
        id: list_transitions
        y: 30
        visible: false
        width: 300
        height: 200
        color: "gray"
        ListModel {
            id: lista
        }
        Component {
            id: listDelegate
            Rectangle{
                readonly property ListView __lv: ListView.view
                color: __lv.currentIndex === index ? "darkBlue" : "lightGrey"
                implicitHeight: txt.implicitHeight
                anchors {
                    left: parent.left
                    right: parent.right
                }
                Text{
                    id: txt
                    text: model.name;
                    font.pixelSize: 20
                    }
                property string toolTipText: "Kliknij dwukrotnie aby usunąć przekształcenie."
                ToolTip.text: toolTipText
                ToolTip.visible: toolTipText ? transition_hint.containsMouse : false
                ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                MouseArea{
                    id: transition_hint
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: click()
                    function click(){
                        __lv.currentIndex = index
                        _var.isClicked = 1
                        if(_var.isClicked == 1 && _var.lastValue === index){ //check if button is clicked 2 times
                            lista.remove(index, 1)
                            _var.wskaznik --
                            _var.ramka() // build new frame
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }
                        else{
                            _var.isClicked = 0
                            _var.lastValue = -1
                        }

                        _var.lastValue = index


                    }
                }

            }
        }
        ListView{ //list of transitions
            id: lv
            anchors.fill: parent
            model: lista
            delegate: listDelegate
            clip: true

        }

    }

    Text {
        id: help
        y: 240
        visible: false
        text: qsTr("Aby usunąć przekształcenie kliknij dwa razy.")
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideMiddle
        font.capitalization: Font.MixedCase
        font.family: "Arial"
        font.pointSize: 10
    }

    Rectangle{  // images
        y: 100
        x: 400
        width: 700
        height: 400
        color: "transparent"

       Row {
           anchors.centerIn: parent
           spacing: 5
           Image {
               x: 400
               id: orginal_image
               source:  ""
               sourceSize.width:  300
               sourceSize.height: 300
               Text {
                   id: labbel_oryginal
                   x: 20
                   text: qsTr("Oryginalny")
                   visible: false
                   verticalAlignment: Text.AlignVCenter
                   horizontalAlignment: Text.AlignHCenter
                   elide: Text.ElideMiddle
                   font.capitalization: Font.MixedCase
                   font.family: "Arial"
                   font.pointSize: 20
               }
           }

           Image {
               id: image1
               source:  ""
               sourceSize.width:  300
               sourceSize.height: 300
               fillMode: Image.PreserveAspectFit

               Text {
                   id: labbel_edited
                   text: qsTr("Edytowany")
                   visible: false
                   verticalAlignment: Text.AlignVCenter
                   horizontalAlignment: Text.AlignHCenter
                   elide: Text.ElideMiddle
                   font.capitalization: Font.MixedCase
                   font.family: "Arial"
                   font.pointSize: 20
               }
           }

       }
      }

    Item { // "global" variables and functions
           id: _var
           property int wskaznik: 0
           property int isClicked: 0
           property int lastValue: 0
           property int lengthOfList: 0
           property int i: 0
           property string frame: ""

           function  ramka(){ // generate frame with transitions
               frame = ""
               for(i = 0;i<lista.count;i++){
                   frame = frame + "///" + lista.get(i).value
               }
           }

       }

    header: ToolBar {  // toolbar
                Flow {
                    anchors.fill: parent
                    ToolButton {
                        id: open_file
                        icon.source: "icon/upload.png"
                        property string toolTipText: "Otwórz plik."
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? open_file_hint.containsMouse : false
                                MouseArea {
                                    id: open_file_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked:{
                                        open_file.clicked(true)
                                    }


                                }
                        onClicked: fileOpenDialog.open()
                    }

                    ToolButton {
                       // text: qsTr("Obrót w lewo")
                        id: left_rotate
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/undo.png"
                        property string toolTipText: "Obrót w lewo."
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? left_rotate_hint.containsMouse : false
                                MouseArea {
                                    id: left_rotate_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: left_rotate.clicked(true)

                                }
                        onClicked: {
                            image1.source = "" // to refresh image
                            lista.insert(_var.wskaznik, {"name": "Obrót w lewo","value": "left_rotate"})
                             _var.wskaznik ++
                            _var.ramka()
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }

                    }
                    ToolButton {
                        //text: qsTr("Obrót w prawo")
                        id: right_rotate
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/redo.png"
                        property string toolTipText: "Obrót w prawo."
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? right_rotate_hint.containsMouse : false
                                MouseArea {
                                    id: right_rotate_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: right_rotate.clicked(true)

                                }
                        onClicked: {
                            image1.source = ""
                            lista.insert(_var.wskaznik, {"name": "Obrót w prawo","value": "right_rotate"})
                             _var.wskaznik ++
                            _var.ramka()
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }
                    }

                    ToolButton {
                        //cofnij
                        id: undo
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/refresh.png"
                        property string toolTipText: "Usuń wszystkie przekształcenia"
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? undo_hint.containsMouse : false
                                MouseArea {
                                    id: undo_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: undo.clicked(true)

                                }
                        onClicked: {
                            image1.source = ""
                            clear()
                            image1.source = "image://MyImageProvider/" + orginal_image.source
                        }
                        function clear(){
                                lista.remove(0, lista.count)
                                _var.wskaznik = 0
                        }
                    }

                    ToolButton {
                        //flip_pion
                        id: flip_vertical
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/flip_pion.png"
                        property string toolTipText: "Przerzucenie obrazu przez oś pionową"
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? flip_vertical_hint.containsMouse : false
                                MouseArea {
                                    id: flip_vertical_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: flip_vertical.clicked(true)

                                }
                        onClicked: {
                            image1.source = ""
                            lista.insert(_var.wskaznik, {"name": "Przerzucenie pionowe","value": "pion"})
                             _var.wskaznik ++
                            _var.ramka()
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }
                    }

                    ToolButton {
                        //flip_poziom
                        id: flip_horizontal
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/flip_poziom.png"
                        property string toolTipText: "Przerzucenie obrazu przez oś poziomą"
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? flip_horizontal_hint.containsMouse : false
                                MouseArea {
                                    id: flip_horizontal_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: flip_horizontal.clicked(true)

                                }
                        onClicked: {
                            image1.source = ""
                            lista.insert(_var.wskaznik, {"name": "Przerzucenie poziome","value": "poziom"})
                            _var.wskaznik ++
                            _var.ramka()
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }
                    }

                    ToolButton {
                        //zoom
                        id: plus
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/zoom.png"
                        property string toolTipText: "Powiększ/pomniejsz\nNie do końca działa poprawnie"
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? zoom_hint.containsMouse : false
                                MouseArea {
                                    id: zoom_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: plus.clicked(true)

                                }
                        onClicked: {
                            zoom_input.open()
                        }
                    }

                    ToolButton {
                        //minus
                        id: minus
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/minus.png"
                        onClicked: {
                               lista.insert(_var.wskaznik, {"name": "Minus"})
                                _var.wskaznik ++
                        }
                    }

                    ToolButton {
                        //czarnobialy
                        id: black_or_color
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/black.png"
                        property string toolTipText: "Filtr czarno-biały"
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? ma.containsMouse : false
                                MouseArea {
                                    id: ma
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: black_or_color.clicked(true)

                                }

                        onClicked: {
                            image1.source = ""
                            lista.insert(_var.wskaznik, {"name": "Filtr szarości","value": "convert"})
                            _var.wskaznik ++
                            _var.ramka()
                            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
                        }
                    }

                    ToolButton {
                        id: save
                        icon.source: "icon/save.png"
                        visible: false
                        property string toolTipText: "Zapisz jako..."
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? save_hint.containsMouse : false
                                MouseArea {
                                    id: save_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: save.clicked(true)

                                }
                        onClicked: fileSaveDialog.open()
                    }

                    ToolButton {
                        //zamkniecie_obrazu
                        id: close
                        visible: false
                        icon.color: "transparent"
                        icon.source: "icon/close.png"
                        property string toolTipText: "Zamknij edytowany obraz."
                                ToolTip.text: toolTipText
                                ToolTip.visible: toolTipText ? close_hint.containsMouse : false
                                MouseArea {
                                    id: close_hint
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: close.clicked(true)

                                }
                        onClicked: close_image()

                        function close_image(){
                            orginal_image.source = "" //zamkniecie podgladu
                            image1.source = ""
                            undo.clear() //wyczyszczenie listy przeksztalcen
                            labbel_oryginal.visible = false
                            labbel_edited.visible = false

                            right_rotate.visible = false
                            left_rotate.visible = false
                            undo.visible = false
                            flip_horizontal.visible = false
                            flip_vertical.visible = false
                            black_or_color.visible = false
                            plus.visible = false
                            minus.visible = false
                            save.visible = false
                            close.visible = false

                            list_transitions.visible = false
                            help.visible = false


                        }
                    }
                }
            }

    FileDialog {
       id: fileOpenDialog
       title: "Select an image file"
      // folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
       nameFilters: [
           "Image files (*.png *.jpeg *.jpg)",
       ]

       onAccepted: {
           image1.source = "image://MyImageProvider/" + fileOpenDialog.fileUrl + "///"
           orginal_image.source = fileOpenDialog.fileUrl
           labbel_oryginal.visible = true
           labbel_edited.visible = true

           right_rotate.visible = true
           left_rotate.visible = true
           undo.visible = true
           flip_horizontal.visible = true
           flip_vertical.visible = true
           black_or_color.visible = true
           plus.visible = true
           minus.visible = false
           save.visible = true
           close.visible = true

           list_transitions.visible = true
           help.visible = true

       }
    }

    FileDialog {
       id: fileSaveDialog
       title: "Save image"
       folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
       nameFilters: [
           "Image files (*.png *.jpeg *.jpg)",
       ]
       selectExisting: false
       onAccepted: {
          // console.log(fileSaveDialog.fileUrl)
           _var.ramka()
           image1.source = "image://MyImageProvider/"
                   + orginal_image.source
                   + _var.frame + "///save"
                   + fileSaveDialog.fileUrl
       }
    }

    Dialog { // zoom window
        id: zoom_input
        title: "Zoom"

       Slider {
           id: zoom_value
           height: 100
           from: 0.2
           stepSize: 0.05
           value: 1
           to: 2
       }
       TextArea{

            text: zoom_value.value*100
        }
        standardButtons: Dialog.Ok
        onAccepted: accepted_value()
        function accepted_value()
        {
            image1.sourceSize.width = 300 * zoom_value.value
            image1.sourceSize.height = 300 * zoom_value.value

            image1.source = ""
            lista.insert(_var.wskaznik, {"name": "Powiększenie","value": "plus:" + zoom_value.value})
            _var.wskaznik ++
            _var.ramka()
            image1.source = "image://MyImageProvider/" + orginal_image.source + _var.frame
        }
    }

    footer: Label { // not using
           id: label
           x: 23
           y: 88
           width: 355
           height: 62
           text: qsTr("")
           horizontalAlignment: Text.AlignHCenter
           elide: Text.ElideMiddle
           font.capitalization: Font.MixedCase
           font.family: "Arial"
           font.pointSize: 20

           Connections{
               target: back
               onValueChanged: label.text = s;

           }
       }

}
