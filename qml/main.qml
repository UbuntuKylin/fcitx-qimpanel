import QtQuick 2.0

Rectangle {
    id: mainWindow
    objectName: "mainWindowQml"
    visible : mainModel.showTips || mainModel.showPreedit || mainModel.showLookupTable
    border.color: "#0080FF"
    border.width: mainSkin.inputBackImg ? 0 : 1
    color: "transparent"
    
    BorderImage {
        visible : mainModel.showPreedit || mainModel.showLookupTable
        anchors.fill: parent
        border {
            left: mainSkin.marginLeft;
            top: mainSkin.marginTop;
            right: mainSkin.marginRight;
            bottom: mainSkin.marginBottom;
        }
        horizontalTileMode: mainSkin.horizontalTileMode
        verticalTileMode: mainSkin.verticalTileMode
        source: mainSkin.inputBackImg
    }
    
    BorderImage {
        visible : mainModel.showTips && !mainModel.showPreedit && !mainModel.showLookupTable
        anchors.fill: parent
        border {
            left: 10;
            top: 10;
            right: 10;
            bottom: 10;
        }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: mainSkin.tipsImg
    }
    
    Text {
        x: 5
        y: 3
        id: "tipsString"
        visible : mainModel.showTips
        text: mainModel.tipsString
        font.pointSize : mainSkin.fontSize
        color: mainSkin.inputColor
    }
        
    Text {
        id: "inputString"
        visible : mainModel.showPreedit
        text: mainModel.inputString
        font.pointSize : mainSkin.fontSize
        color: mainSkin.inputColor
    }

    MouseArea {
        anchors.fill: parent
        property variant previousPosition
        onPressed: {
            previousPosition = Qt.point(mouseX, mouseY)
        }
        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton) {
                var dx = mouseX - previousPosition.x
                var dy = mouseY - previousPosition.y
                mainWidget.pos = Qt.point(mainWidget.pos.x + dx,
                                        mainWidget.pos.y + dy)
            }
        }
    }

    Row {    
        id: "horizontal"
        visible : mainModel.showLookupTable && mainModel.isHorizontal
        Repeater {
            model: mainModel.candidateWords
            Text {
                id: "candidateWord"
                text: "<font color='" + mainSkin.indexColor + "'>" + cddLabel + "</font>" + 
                         "<font color='" + ((index == mainModel.highLight) ? mainSkin.firstCandColor : 
                            mainSkin.otherColor) + "'>" + cddText + "</font>" + "  "
                font.pointSize : mainSkin.candFontSize != 0 ? mainSkin.candFontSize : mainSkin.fontSize
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                            parent.opacity = 0.6
                    }
                    onExited: {
                            parent.opacity = 1
                    }
                    onClicked: {
                            mainCtrl.selectCandidate(index)
                    }
                }
            }
        }
    }
    
    Column {
        id: "vertical"
        visible : mainModel.showLookupTable && !mainModel.isHorizontal
        
        Repeater {
            model: mainModel.candidateWords
            Text {
                id: "candidateWord"
                text: "<font color='" + mainSkin.indexColor + "'>" + cddLabel + "</font>" + 
                         "<font color='" + ((index == mainModel.highLight) ? mainSkin.firstCandColor : 
                            mainSkin.otherColor) + "'>" + cddText + "</font>" + "  "
                font.pointSize : mainSkin.candFontSize != 0 ? mainSkin.candFontSize : mainSkin.fontSize
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                            parent.opacity = 0.6
                    }
                    onExited: {
                            parent.opacity = 1
                    }
                    onClicked: {
                            mainCtrl.selectCandidate(index)
                    }
                }
            }
        }
    }

    Image {
        id: "prev_page"
        visible : mainModel.hasPrev || mainModel.hasNext
        source: mainSkin.backArrowImg
        opacity: mainModel.hasPrev ? 1 : 0.5
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mainModel.hasPrev)
                    mainCtrl.getPrevPage()
            }
        }
    }
    
    Image {
        id: "next_page"
        visible : mainModel.hasPrev || mainModel.hasNext
        source: mainSkin.forwardArrowImg
        opacity: mainModel.hasNext ? 1 : 0.5
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mainModel.hasNext)
                    mainCtrl.getNextPage()
            }
        }
    }
    
    function clearAllAnchors(obj) {
        obj.anchors.left = undefined;
        obj.anchors.leftMargin = 0;
        obj.anchors.top = undefined;
        obj.anchors.topMargin = 0;
        obj.anchors.right = undefined;
        obj.anchors.rightMargin = 0;
        obj.anchors.bottom = undefined;
        obj.anchors.bottomMargin = 0;
    }
    
    function setObjAbsolutePosition(bindObj, x, y) {
        if (x > 0) {
            bindObj.anchors.left = mainWindow.left;
            bindObj.anchors.leftMargin = x;
        } else if (x < 0) {
            bindObj.anchors.right = mainWindow.right;
            bindObj.anchors.rightMargin = -x;
        }
        
        if (y > 0) {
            bindObj.anchors.top = mainWindow.top;
            bindObj.anchors.topMargin = y;
        } else if (y < 0) {
            bindObj.anchors.bottom = mainWindow.bottom;
            bindObj.anchors.bottomMargin = -y;
        }
    }
    
    Component.onCompleted: {
    
        if (mainSkin.inputStringPosX == 0)
            mainSkin.inputStringPosX = mainSkin.marginLeft;
            
        if (mainSkin.inputStringPosY == 0)
            mainSkin.inputStringPosY = mainSkin.marginTop;
        clearAllAnchors(inputString);
        setObjAbsolutePosition(inputString, mainSkin.inputStringPosX, mainSkin.inputStringPosY);

        if (mainSkin.outputCandPosX == 0)
            mainSkin.outputCandPosX = mainSkin.marginLeft;
            
        if (mainSkin.outputCandPosY == 0)
            mainSkin.outputCandPosY = inputString.height + mainSkin.marginTop;
        clearAllAnchors(horizontal);
        setObjAbsolutePosition(horizontal, mainSkin.outputCandPosX, mainSkin.outputCandPosY);
        clearAllAnchors(vertical);
        setObjAbsolutePosition(vertical, mainSkin.outputCandPosX, mainSkin.outputCandPosY);

        if (mainSkin.backArrowPosX == 0)
            mainSkin.backArrowPosX = - prev_page.width - next_page.width - 5 - 10;

        if (mainSkin.backArrowPosY == 0)
            mainSkin.backArrowPosY = mainSkin.inputStringPosY;
            
        clearAllAnchors(prev_page);
        setObjAbsolutePosition(prev_page, mainSkin.backArrowPosX, mainSkin.backArrowPosY);    
                console.log("111111111111111111")
        console.log(mainSkin.backArrowPosX)
               console.log("111111111111111111")
        if (mainSkin.forwardArrowPosX == 0)
            mainSkin.forwardArrowPosX = - next_page.width - 10;
            
        if (mainSkin.forwardArrowPosY == 0)
            mainSkin.forwardArrowPosY = mainSkin.inputStringPosY;
            
        clearAllAnchors(next_page);
        setObjAbsolutePosition(next_page, mainSkin.forwardArrowPosX, mainSkin.forwardArrowPosY);

    }
    
    function max(x, y) { return x > y ? x : y; }
    
    Connections {
        target: mainModel
        
        onMainWindowSizeChanged: {
            var tmp, i;
            var width, width1;
            var height, height1;
            
            if (mainModel.showTips && !mainModel.showPreedit && !mainModel.showLookupTable) {
                mainWindow.width = tipsString.width + 10;
                mainWindow.height = tipsString.height + 10;
                
                return;
            }

            width = mainSkin.marginLeft;
            width1 = 0;
            height = mainSkin.marginTop;
            height1 = 0;

            if (mainModel.showTips) {
                tmp = tipsString.x + tipsString.width;
                width = max(width, tmp);

                tmp = tipsString.y + tipsString.height;
                height = max(height, tmp);
            }            
                
            if (mainModel.showPreedit) {
                if (mainSkin.inputStringPosX > 0) {
                    tmp = inputString.x + inputString.width;
                    width = max(width, tmp);
                } else {
                    width1 = max(width1, -mainSkin.inputStringPosX);
                }
                
                if (mainSkin.inputStringPosY > 0) {
                    tmp = inputString.y + inputString.height;
                    height = max(height, tmp);
                } else {
                    height1 = max(height1, -mainSkin.inputStringPosY);
                }
            }
                
            if (mainModel.showLookupTable) {
                if (mainSkin.outputCandPosX > 0) {
                    if (mainModel.isHorizontal) {
                        tmp = horizontal.x;
                        for (i = 0; i < horizontal.children.length; i++)
                            tmp += horizontal.children[i].width;
                    } else {
                        tmp = 0;
                        for (i = 0; i < vertical.children.length; i++)
                            tmp = max(tmp, vertical.children[i].width);
                        tmp += vertical.x;
                    }
                    width = max(width, tmp);
                } else {
                    width1 = max(width1, -mainSkin.outputCandPosX);
                }
                
                if (mainSkin.outputCandPosY > 0) {
                    if (mainModel.isHorizontal) {
                        tmp = 0;
                        for (i = 0; i < horizontal.children.length; i++)
                            tmp = max(tmp, horizontal.children[i].height);
                        tmp += horizontal.y;
                    } else {
                        tmp = vertical.y;
                        for (i = 0; i < vertical.children.length; i++)
                            tmp += vertical.children[i].height;
                    }
                    height = max(height, tmp);
                } else {
                    height1 = max(height1, -mainSkin.outputCandPosY);
                }
            }
            
            if (mainModel.hasPrev || mainModel.hasNext) {
                if (mainSkin.backArrowPosX > 0) {
                    tmp = prev_page.x + prev_page.width;
                    width = max(width, tmp);
                } else {
                    width1 = max(width1, -mainSkin.backArrowPosX);
                }
    
                if (mainSkin.forwardArrowPosX > 0) {
                    tmp = next_page.x + next_page.width;
                    width = max(width, tmp);
                } else {
                    width1 = max(width1, -mainSkin.forwardArrowPosX);
                }

                if (mainSkin.backArrowPosY > 0) {
                    tmp = prev_page.y + prev_page.height;
                    height = max(height, tmp);
                } else {
                    height1 = max(height1, -mainSkin.backArrowPosY);
                }
    
                if (mainSkin.forwardArrowPosY > 0) {
                    tmp = next_page.y + next_page.height;
                    height = max(height, tmp);
                } else {
                    height1 = max(height1, -mainSkin.forwardArrowPosY);
                }
            }
            
            mainWindow.width = width + width1 + mainSkin.marginRight + mainSkin.adjustWidth;
            mainWindow.height = height + height1 + mainSkin.marginBottom + mainSkin.adjustHeight;
        }
    }
}
