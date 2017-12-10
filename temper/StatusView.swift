//
//  StatusView.swift
//  temper
//
//  Created by Andrey Sevrikov on 13/06/2017.
//  Copyright © 2017 Andrey Sevrikov. All rights reserved.
//

import Foundation
import Cocoa

protocol StatusViewDelegate: class {
    func didReceiveClick()
}

class StatusView: NSView {
    
    // MARK: - IBOutlets
    
    @IBOutlet var view: NSView!
    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var leftFanIndicator: NSProgressIndicator!
    @IBOutlet weak var rightFanIndicator: NSProgressIndicator!
    
    // MARK: - Properties
    
    weak var delegate: StatusViewDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "StatusView"), owner: self, topLevelObjects: nil)
        self.view.frame = self.bounds
        
        leftFanIndicator.isIndeterminate = false
        rightFanIndicator.isIndeterminate = false
        
        leftFanIndicator.alphaValue = 0.5
        rightFanIndicator.alphaValue = 0.5
        
        self.addSubview(self.view)
        
        let r = NSClickGestureRecognizer(target: self, action: #selector(didClick))
        temperatureLabel.addGestureRecognizer(r)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Actions
    
    @objc func didClick() {
        setHighlighted(value: true)
        delegate?.didReceiveClick()
    }
    
    // MARK: - Public
    
    func setHighlighted(value: Bool) {
        if value {
            self.view.layer?.backgroundColor = CGColor(red: 0.001, green: 0.41, blue: 0.851, alpha: 1.0)
        } else {
            self.view.layer?.backgroundColor = CGColor.clear
        }
    }
    
    func setTemperature(value: Double) {
        self.temperatureLabel.stringValue = String(format: "%.0f°", value)
    }
    
    func setLeftFan(min: Int, current: Int, max: Int) {
        self.leftFanIndicator.minValue = Double(min)
        self.leftFanIndicator.maxValue = Double(max)
        self.leftFanIndicator.doubleValue = Double(current)
    }
    
    func setRightFan(min: Int, current: Int, max: Int) {
        self.rightFanIndicator.minValue = Double(min)
        self.rightFanIndicator.maxValue = Double(max)
        self.rightFanIndicator.doubleValue = Double(current)
    }
}
