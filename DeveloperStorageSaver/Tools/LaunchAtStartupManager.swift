//
//  LaunchAtStartupManager.swift
//  DiskDevPro
//
//  Created by Niclas Jeppsson on 06/02/2025.
//

import Foundation
import ServiceManagement

class LaunchAtStartupManager {
    
    private enum Constant {
        static let bundleID = "com.niclasjeppsson.AutoLauncher"
    }
    
    static let shared = LaunchAtStartupManager()
    private let appService = SMAppService()
    private let userDefaultManager = UserDefaultManager.shared

    private init() {}
    
    func setStartAppAtLaunch(state: Bool) {
        
        if state {
            do {
                print("Launch At Login: True")
                SMAppService.loginItem(identifier: Constant.bundleID)
                try self.appService.register()
                self.userDefaultManager.setLaunchAtLoginState(true)
            } catch {
                print("AppService Register Error: \(error.localizedDescription)")
            }
        } else {
            print("Launch At Login: False")
            self.appService.unregister { error in
                guard let error = error else {
                    print("AppService Unregistered")
                    return
                }
                print("AppService Unregister Error: \(error.localizedDescription)")
            }
            self.userDefaultManager.setLaunchAtLoginState(false)
        }
    }
    
}
