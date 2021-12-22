//
//  Board.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

enum DrawingState {
    case Began
    case Move
    case Ended
}


class Board: UIImageView {
    
    private class DBUndoManager{
        class DBImageFault : UIImage{}
        
        private static let INVALID_INDEX = -1
        private var images = [UIImage]()
        private var index = INVALID_INDEX
        
        var canUndo: Bool {
            get {
                return index != DBUndoManager.INVALID_INDEX
            }
        }
        
        var canRedo: Bool {
            get {
                return index + 1 < images.count
            }
        }
        
        func addImage(image: UIImage) -> Void {
            // 当往这个 Manager 中增加图片的时候，先把指针后面的图片全部清掉，
            // 这与我们之前在 drawingImage 方法中对 redoImages 的处理是一样的
            if  index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            images.append(image)
            //
            index = images.count - 1
            setNeedsCahce()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                index -= 1
                if self.canUndo == false {
                    return nil
                }else {
                    setNeedsCahce()
                    return images[index]
                }
            }
            return nil
        }
        
        func imageForRedo() -> UIImage? {
            var image: UIImage? = nil
            if self.canRedo {
                index += 1
                image = images[index]
            }
            setNeedsCahce()
            return image
        }
        
        private static let cachesLength = 3
        
        
        
        private func setNeedsCahce() -> Void {
            if images.count >= DBUndoManager.cachesLength {
                let location = max(0,index -  DBUndoManager.cachesLength)
                let length = min(images.count - 1, index + DBUndoManager.cachesLength)
                
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        if i > index - DBUndoManager.cachesLength && i < index + DBUndoManager.cachesLength {
                            setRealImage(image: image, forIndex: i) // 如果在缓存区域中，则从文件加载
                        } else {
                            setFaultImage(image: image, forIndex: i) // 如果不在缓存区域中，则置成 Fault 对象
                        }
                    }
                }
            }
        }
        
        private static var basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        private func setFaultImage(image: UIImage, forIndex: Int) {
            if !image.isKind(of: DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                do{
                    try image.pngData()?.write(to: URL(fileURLWithPath: imagePath))
                }
                catch{
                }
                images[forIndex] = DBImageFault()
            }
        }
        
        private func setRealImage(image: UIImage, forIndex: Int) {
            if image.isKind(of:DBImageFault.self){
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                images[forIndex] = UIImage(data: NSData(contentsOfFile: imagePath)! as Data)!
            }
        }
    }
    
    
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    private var drawingState: DrawingState!
    
    var brush: BaseBrush?
    
    private var undoImages = [UIImage]()
    private var redoImages = [UIImage]()
    
    private var realImage: UIImage?
    private var boardUndoManager = DBUndoManager() // 缓存或Undo控制器
    var canUndo : Bool {
        get {
//            return self.undoImages.count > 0 || self.image != nil
            return self.boardUndoManager.canUndo
        }
    }
    
    var  canRedo: Bool {
        get {
//            return self.redoImages.count > 0
            return self.boardUndoManager.canRedo
        }
    }
    
    
    override init(frame: CGRect) {
        self.strokeWidth = 1
        self.strokeColor = UIColor.black
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.strokeWidth = 1
        self.strokeColor = UIColor.black
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            brush.beginPoit = touches.randomElement()?.location(in: self)
            brush.endPoint = brush.beginPoit
            self.drawingState = .Began
            self.drawingImage()
        }

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.randomElement()?.location(in: self)
            self.drawingState = .Move
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.randomElement()?.location(in: self)
            self.drawingState = .Ended
            self.drawingImage()
        }
       
    }
    
    //MARK: - drawing
    private func drawingImage(){
        /**
         1开启一个新的ImageContext，为保存每次的绘图状态作准备。
         2初始化context，进行基本设置（画笔宽度、画笔颜色、画笔的圆润度等）。
         3把之前保存的图片绘制进context中。
         4设置brush的基本属性，以便子类更方便的绘图；调用具体的绘图方法，并最终添加到context中。
         5从当前的context中，得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到realImage中。
         6实时显示当前的绘制状态，并记录绘制的最后一个点。

         */
        if let brush = self.brush {
            //1
            UIGraphicsBeginImageContext(self.bounds.size)
            //2
            let context = UIGraphicsGetCurrentContext()
         
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            context?.setLineCap(.round)
            context?.setLineWidth(self.strokeWidth)
            context?.setStrokeColor(self.strokeColor.cgColor)
            //3
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            //4
            brush.strokWidth = self.strokeWidth
            brush.drawInContext(context: context)
            context?.strokePath()
            
            //5
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportContinuousDrawing() {
                self.realImage = previewImage
            }
            UIGraphicsEndImageContext()
            //6
            self.image = previewImage
            brush.lastPoint = brush.endPoint
            
//            if self.drawingState  == .Began {
//                self.redoImages = []
//                if self.image != nil {
//                    self.undoImages.append(self.image!)
//                }
//            }
            if self.drawingState == .Ended {
                self.boardUndoManager.addImage(image: self.image!)
            }
                
        }
    }
    
    func undo() -> Void {
        if self.canUndo == false {
            return
        }
        
//        if self.undoImages.count > 0 {
//            self.redoImages.append(self.image!)
//            let lastImage = self.undoImages.removeLast()
//            self.image = lastImage
//        }else if self.image != nil {
//            self.redoImages.append(self.image!)
//            self.image = nil
//        }
//
        
        self.image = self.boardUndoManager.imageForUndo()
        self.realImage = self.image
        
    }
    
    func redo() -> Void {
        if self.canRedo == false {
            return
        }
//        if self.redoImages.count > 0 {
//            if self.image != nil {
//                self.undoImages.append(self.image!)
//            }
//            let lastImage = self.redoImages.removeLast()
//            self.image = lastImage
//            self.realImage = self.image
//        }
        
        self.image = self.boardUndoManager.imageForRedo()
        self.realImage = self.image
    }
    
    

    
}
