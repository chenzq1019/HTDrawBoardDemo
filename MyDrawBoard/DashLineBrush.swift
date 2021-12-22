//
//  DashLineBrush.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

class DashLineBrush: BaseBrush {

    override func drawInContext(context: CGContext?) {
        let lenghths: [CGFloat] = [self.strokWidth * 3, self.strokWidth * 3]
        context?.setLineDash(phase: 0, lengths: lenghths)
        context?.move(to: beginPoit)
        context?.addLine(to: endPoint)
    }
}
