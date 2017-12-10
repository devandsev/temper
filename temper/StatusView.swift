//
//  StatusView.swift
//  temper
//
//  Created by Andrey Sevrikov on 13/06/2017.
//  Copyright © 2017 Andrey Sevrikov. All rights reserved.
//

import Foundation
import Cocoa

class StatusView: NSView {
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var leftFanIndicator: NSProgressIndicator!
    @IBOutlet weak var rightFanIndicator: NSProgressIndicator!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "StatusView"), owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        
        leftFanIndicator.isIndeterminate = false
        rightFanIndicator.isIndeterminate = false
        
        leftFanIndicator.alphaValue = 0.5
        rightFanIndicator.alphaValue = 0.5
//         self.leftFanIndicator.doubleValue = 50
        
        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setTemperature(value: Double) {
//        return;
        self.temperatureLabel.stringValue = String(format: "%.0f°", value)
    }
    
    func setLeftFan(min: Int, current: Int, max: Int) {
//        return;
        self.leftFanIndicator.minValue = Double(min)
        self.leftFanIndicator.maxValue = Double(max)
        self.leftFanIndicator.doubleValue = Double(current)
    }
    
    func setRightFan(min: Int, current: Int, max: Int) {
//        return;
        self.rightFanIndicator.minValue = Double(min)
        self.rightFanIndicator.maxValue = Double(max)
        self.rightFanIndicator.doubleValue = Double(current)
    }
}
