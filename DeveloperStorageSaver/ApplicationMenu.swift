//
//  ApplicationMenu.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 16/03/2023.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {

    let menu = NSMenu()

    func createMenu() -> NSMenu {
        let storageView = StorageMainView()
        let topView = NSHostingController(rootView: storageView)
        topView.view.frame.size = CGSize(width: 300, height: 220)
    
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view

        menu.addItem(customMenuItem)

        let infoView = InfoView(delegate: self)
        let infoViewHostingController = NSHostingController(rootView: infoView)
        infoViewHostingController.view.frame.size = CGSize(width: 300, height: 25)

        let aboutMenuItem = NSMenuItem()
        aboutMenuItem.view = infoViewHostingController.view

        aboutMenuItem.target = self

        menu.addItem(aboutMenuItem)
        
        return menu
    }
}

extension ApplicationMenu: InfoDelegate {
    func showInfoWindow() {

        guard let url = Bundle.main.url(forResource: "ImportantInfo", withExtension: "rtf") else { return }
        guard let importantInfo = try? NSAttributedString(url: url,
                                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                          documentAttributes: nil) else { return }
        NSApp.orderFrontStandardAboutPanel(options: [.applicationIcon: NSImage(named: NSImage.Name("AppIcon")),
                                                     .credits: importantInfo])
        
    }
    
    func terminateApplication() {
        NSApplication.shared.terminate(self)
    }


}
