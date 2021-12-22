//
//  ViewController.swift
//  MyDrawBoard
//
//  Created by 陈竹青 on 2021/11/19.
//

////https://blog.csdn.net/zhangao0086/article/details/43836789

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bord: Board!
    @IBOutlet weak var toolbar: UIToolbar!
    var brushes = [PencilBrush(),LineBrush(),DashLineBrush(),RectangleBrush(),EllipsBrush(),EraserBrush()]
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    @IBOutlet weak var toolbarConstraintHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bord.brush = brushes[0]
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(endSetting))
        ]
        self.toolbarItems = self.toolbar.items
        self.setupBrushSettingsView()
    }
    @IBAction func undo(_ sender: UIButton) {
        self.bord.undo()
    }
    @IBAction func redo(_ sender: UIButton) {
        self.bord.redo()
    }
    
    @IBAction func swichBrush(_ sender: UISegmentedControl) {
        assert(sender.tag < self.brushes.count , "!!!!")
        
        self.bord.brush = brushes[sender.selectedSegmentIndex]
    }
    
    @IBAction func paintingBrushSettings(_ sender: UIBarButtonItem) {
        self.currentSettingsView = self.toolbar.viewWithTag(1)
        self.currentSettingsView?.isHidden = false
        self.updateToolbarForSettingView()
    }
    
    @objc func endSetting() -> Void {
        self.toolbarConstraintHeight.constant = 44
        self.toolbar.setItems(self.toolbarItems, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.toolbar.layoutIfNeeded()
        }
        self.currentSettingsView?.isHidden = true
    }
    
    func updateToolbarForSettingView() -> Void {
        self.toolbarConstraintHeight.constant = (self.currentSettingsView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)! + 200
        self.toolbar.setItems(self.toolbarEditingItems, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.toolbar.layoutIfNeeded()
        }
        self.toolbar.bringSubviewToFront(self.currentSettingsView!)
    }
    
    func addConstrainsToToolbarForSettingsView(view: UIView) -> Void {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.toolbar.addSubview(view)
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[settingsView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["settingsView": view]))
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[settingsView(==height)]", options: .directionLeadingToTrailing, metrics: ["height": 310], views: ["settingsView":view]))
    }
    
    func setupBrushSettingsView() -> Void {
        let brushSettingsView = UINib(nibName: "PaintingBrushSettingsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PaintingBrushSettingsView
        self.addConstrainsToToolbarForSettingsView(view: brushSettingsView)
        
        brushSettingsView.isHidden = true
        brushSettingsView.tag = 1
        brushSettingsView.setBackgroundColor(color: self.bord.strokeColor)
        
        brushSettingsView.strokeWidthChangedBlock = { [unowned self] (strokeWidth: CGFloat) in
            self.bord.strokeWidth = strokeWidth
        }
        
        brushSettingsView.strokeColorChangedBLock = {[unowned self] (strokeColor: UIColor) in
            
            self.bord.strokeColor = strokeColor
            
        }
        
        
    }
}

