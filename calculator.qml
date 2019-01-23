// Mac OS Version

import QtQuick 2.5
import QtQuick.Window 2.0
import QtScxml 5.8

Window {
    id: window
    visible: true

    width: 400
    height: 480

    CalculatorStateMachine {
        id: statemachine
        running: true
        EventConnection {
            events: ["updateDisplay"]
            onOccurred: resultText.text = event.data.display
        }
    }

    Rectangle {
        id: resultArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * 3 / 8 - 10
        border.color: "white"
        border.width: 1
        color: "#46a2da"
        Text {
            id: resultText
            anchors.leftMargin: operations.implicitMargin
            anchors.rightMargin: operations.implicitMargin
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: "0"
            color: "white"
            font.pixelSize: window.height * 3 / 32
            font.family: "Open Sans Regular"
            fontSizeMode: Text.Fit
        }
    }

    Item {
        id: operations
        anchors.top: resultArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        property real implicitMargin: {
            var ret = 0;
            for (var i = 0; i < visibleChildren.length; ++i) {
                var child = visibleChildren[i];
                ret += (child.implicitMargin || 0) / visibleChildren.length;
            }
            return ret;
        }

        Repeater {
            model: ["÷", "×", "+", "-"]
            Button {
                y: 0
                x: index * width
                width: parent.width / 4
                height: parent.height / 5
                color: pressed ? "#5caa15" : "#80c342"
                text: modelData
                fontHeight: 0.4
                onClicked: statemachine.submitEvent(eventName)
                property string eventName: {
                    switch (text) {
                    case "÷": return "OPER.DIV"
                    case "×": return "OPER.STAR"
                    case "+": return "OPER.PLUS"
                    case "-": return "OPER.MINUS"
                    }
                }
            }
        }

        Repeater {
            model: ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0", ".", "C"]
            Button {
                x: (index % 3) * width
                y: Math.floor(index / 3 + 1) * height
                width: parent.width / 4
                height: parent.height / 5
                color: pressed ? "#d6d6d6" : "#eeeeee"
                text: modelData
                onClicked: statemachine.submitEvent(eventName)
                property string eventName: {
                    switch (text) {
                    case ".": return "POINT"
                    case "C": return "C"
                    default: return "DIGIT." + text
                    }
                }
            }
        }

        Button {
            x: 3 * width
            y: parent.height / 5
            textHeight: y - 2
            fontHeight: 0.4
            width: parent.width / 4
            height: y * 4
            color: pressed ? "#e0b91c" : "#face20"
            text: "="
            onClicked: statemachine.submitEvent("EQUALS")
        }
    }
}
