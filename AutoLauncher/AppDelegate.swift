//
//  AppDelegate.swift
//  AutoLauncher
//
//  Created by Niclas Jeppsson on 09/04/2023.
//

import Cocoa

class AutoLauncherAppDelegate: NSObject, NSApplicationDelegate {
    
    enum Constants {
        static let mainAppBundleID = "com.niclasjeppsson.DiskDevPro"
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Constants.mainAppBundleID
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            let applicationPathString = path as String
            guard let pathURL = URL(string: applicationPathString) else { return }
            NSWorkspace.shared.launchApplication(pathURL.absoluteString)
        }
        
    }
}

