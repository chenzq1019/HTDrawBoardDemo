//
//  EraserBrush.swift
//  MyDrawBoard
//
//  Created by ้็ซน้ on 2021/11/19.
//

import UIKit

class EraserBrush: PencilBrush {
    override func drawInContext(context: CGContext?) {
        context?.setBlendMode(.clear)
        super.drawInContext(context: context)
    }
}
