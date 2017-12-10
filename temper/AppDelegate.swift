//
//  AppDelegate.swift
//  temper
//
//  Created by Andrey Sevrikov on 13/06/2017.
//  Copyright © 2017 Andrey Sevrikov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    let statusView = StatusView(frame: NSRect(x: 0, y: 0, width: 36, height: 22))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let menu = NSMenu()
        statusItem.menu = menu
        statusItem.view = statusView
        
        do {
            try SMCKit.open()
        } catch {
            let alert = NSAlert()
            alert.messageText = "Couldn't open connection to the SMC driver!"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = NSAlertStyle.critical
            alert.runModal()
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.checkTemp()
        }
    }

    func checkTemp()  {
        if let temperature = try? SMCKit.temperature(1413689414) {
            statusView.setTemperature(value: temperature)
        }
        
        if let keys = try? SMCKit.allFans() {
            for key in keys {
                guard let speed = try? SMCKit.fanCurrentSpeed(key.id) else {
                    continue
                }
            
                if key.id == 0 {
                    statusView.setLeftFan(min: key.minSpeed, current: speed, max: key.maxSpeed)
                }
                
                if key.id == 1 {
                    statusView.setRightFan(min: key.minSpeed, current: speed, max: key.maxSpeed)
                }
            }
        }
    }
}
