//
//  LineBrush.swift
//  MyDrawBoard
//
//  Created by ้็ซน้ on 2021/11/19.
//

import UIKit

class LineBrush: BaseBrush {
    override func drawInContext(context: CGContext?) {
        context?.move(to: beginPoit)
        context?.addLine(to: endPoint)
    }
//    override func supportContinuousDrawing() -> Bool {
//        return true
//    }
}
