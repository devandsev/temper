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

    let statusItem = NSStatusBar.system.statusItem(withLength: -1)
    let statusView = StatusView(frame: NSRect(x: 0, y: 0, width: 36, height: 22))
    let menu = NSMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.view = statusView
        statusItem.menu = menu
        menu.delegate = self
        
        statusView.delegate = self
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        do {
            try SMCKit.open()
        } catch {
            let alert = NSAlert()
            alert.messageText = "Couldn't open connection to the SMC driver!"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = NSAlert.Style.critical
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

extension AppDelegate: StatusViewDelegate {
    
    func didReceiveClick() {
        statusItem.popUpMenu(menu)
    }
}

extension AppDelegate: NSMenuDelegate {
    
    func menuDidClose(_ menu: NSMenu) {
        statusView.setHighlighted(value: false)
    }
}
