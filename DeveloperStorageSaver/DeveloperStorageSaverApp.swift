//
//  DeveloperStorageSaverApp.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 15/03/2023.
//

import SwiftUI

@main
struct DeveloperStorageSaverApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    static private(set) var instance: AppDelegate?

    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()

    func applicationDidFinishLaunching(_ notification: Notification) {

        AppDelegate.instance = self
        statusBarItem.button?.image = NSImage(named: NSImage.Name("hammer.circle.fill"))
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }
}
