//
//  RectangleBrush.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

class RectangleBrush: BaseBrush {
    override func drawInContext(context: CGContext?) {
        context?.addRect(CGRect(x: min(beginPoit.x, endPoint.x), y: min(beginPoit.y, endPoint.y), width: abs(endPoint.x - beginPoit.x), height: abs(endPoint.y - beginPoit.y)))
    }
}
