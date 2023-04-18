//
//  ApplicationMenu.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 16/03/2023.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {

    private let menu = NSMenu()

    func createMenu() -> NSMenu {

        //MARK: Main Storage View
        
        let storageView = StorageMainView()
        let topView = NSHostingController(rootView: storageView)
        topView.view.frame.size = CGSize(width: 300, height: 250)
    
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view

        menu.addItem(customMenuItem)

        //MARK: Toolbar View

        var toolbarView = ToolbarView()
        let toolbarHostingViewController = NSHostingController(rootView: toolbarView)
        toolbarHostingViewController.view.frame.size = CGSize(width: 300, height: 25)

        let toolbarMenuItem = NSMenuItem()
        toolbarMenuItem.view = toolbarHostingViewController.view

        menu.addItem(toolbarMenuItem)

        //MARK: Info View

        let infoView = InfoView(delegate: self)
        let infoViewHostingController = NSHostingController(rootView: infoView)
        infoViewHostingController.view.frame.size = CGSize(width: 300, height: 25)

        let infoViewMenuItem = NSMenuItem()
        infoViewMenuItem.view = infoViewHostingController.view

        infoViewMenuItem.target = self

        menu.addItem(infoViewMenuItem)

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
}
