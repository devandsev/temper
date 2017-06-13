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
    var timer: Timer!
    
    let statusView = StatusView(frame: NSRect(x: 0, y: 0, width: 36, height: 22))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let menu = NSMenu()
        
//        menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q"))
        
        statusItem.menu = menu
//        statusItem.title = "36.6°"
        
        
//        view.wantsLayer = true
//        view.layer?.backgroundColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        statusItem.view = statusView
//        statusItem.view?.addSubview(statusView)
        
        guard ((try? SMCKit.open()) != nil) else {
            return
        }

//        self.checkTemp()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.checkTemp()
        }
        
//        if let sensors = try? SMCKit.allKnownTemperatureSensors() {
//            for sensor in sensors {
//                print("\(sensor.name): \(try? SMCKit.temperature(sensor.code))")
//            }
//        }
//        
//        if let keys = try? SMCKit.allFans() {
//            for key in keys {
//                print("\(key.name): \(key.minSpeed)-\(key.maxSpeed)")
//            }
//        }

        
//        print(try? SMCKit.allKeys())
//        print(try? SMCKit.allKnownTemperatureSensors())
//        print(try? SMCKit.allFans())
        
//        if let ss = try? SMCKit.allUnknownTemperatureSensors() {
//            print(ss)
//        }
        
    }

    func checkTemp()  {
        guard let temperature = try? SMCKit.temperature(1413689414) else {
            return
        }
        
//        statusItem.title = String(format: "%.0f°", temperature)
        
        if let keys = try? SMCKit.allFans() {
            for key in keys {
                let speed = try! SMCKit.fanCurrentSpeed(key.id)
            
                if key.id == 0 {
                    statusView.setLeftFan(min: key.minSpeed, current: speed, max: key.maxSpeed)
                }
                
                if key.id == 1 {
                    statusView.setRightFan(min: key.minSpeed, current: speed, max: key.maxSpeed)
                }
//                print("\(key.name): \(key.minSpeed)-\(speed)-\(key.maxSpeed)")
            }
        }
        
        statusView.setTemperature(value: temperature)
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

