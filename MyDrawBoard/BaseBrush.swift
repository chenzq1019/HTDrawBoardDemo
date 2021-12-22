//
//  BaseBrush.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

protocol PaintBrush {
    //表示是否连续不断的绘图
    func supportContinuousDrawing() -> Bool
    //基于context的绘图方法，子类必须实现具体的绘图
    func drawInContext(context: CGContext?)
}

class BaseBrush: NSObject,PaintBrush {
    var beginPoit: CGPoint!//开始点的位置
    var endPoint: CGPoint!//结束点的位置
    var lastPoint: CGPoint!//最后一个点的位置
    var strokWidth: CGFloat!//画笔的宽度
    
    func supportContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContext?) {
        assert(false,"must implement in subClass")
    }
}
