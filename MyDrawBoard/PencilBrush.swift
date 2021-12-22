//
//  PencilBrush.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

class PencilBrush: BaseBrush {
    ///如果lastPoint为nil，则基于beginPoint画线，反之则基于lastPoint画线。
    ///这样一来，一个铅笔工具就完成了，怎么样，很简单吧。
    override func drawInContext(context: CGContext?) {
        if let lastPoint = self.lastPoint {
            context?.move(to: lastPoint)
            context?.addLine(to: endPoint)
        }else{
            context?.move(to: beginPoit)
            context?.addLine(to: endPoint)
        }
    }
    override func supportContinuousDrawing() -> Bool {
        return true
    }
}
