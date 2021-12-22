//
//  PaintingBrushSettingsView.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

import UIKit

class PaintingBrushSettingsView: UIView {

    var strokeWidthChangedBlock: ((_ strokeWidht: CGFloat) -> Void)?
    var strokeColorChangedBLock: ((_ strokeColor: UIColor) -> Void)?
    
    @IBOutlet weak var strokeWIdhtSlider: UISlider!
    @IBOutlet weak var strokeColorPreview: UIView!
    @IBOutlet weak var colorPIcker: RGBColorPicker!
//
//    override class func awakeFromNib() {
//        super.awakeFromNib()
////        self.strokeColorPreview.layer.borderColor = UIColor.black.cgColor
//        print("awkeFromNib")
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awkeFromNib")
        self.strokeColorPreview?.layer.borderColor = UIColor.black.cgColor
        self.strokeColorPreview?.layer.borderWidth = 1
        self.strokeWIdhtSlider?.value = 1
        self.colorPIcker?.colorChangedBlock = { [unowned self] (color: UIColor)  in
            self.strokeColorPreview?.backgroundColor = color
            print("=====");
            if let colorChangeBlock = self.strokeColorChangedBLock {
                colorChangeBlock(color)
            }
        }
    }
    func setBackgroundColor(color: UIColor){
        self.strokeColorPreview.backgroundColor = color;
    }
    
    @IBAction func strokeWidthChanged(_ slider: UISlider) {
        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedBlock(CGFloat(slider.value))
        }
    }
//    func strokeWidthChanged(slider: UISlider) -> Void {
//        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
//            strokeWidthChangedBlock(CGFloat(slider.value))
//        }
//    }
}
