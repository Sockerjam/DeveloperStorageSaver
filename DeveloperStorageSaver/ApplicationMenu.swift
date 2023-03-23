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
        let storageView = StorageView()
        let topView = NSHostingController(rootView: storageView)
        topView.view.frame.size = CGSize(width: 300, height: 200)

        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view

        menu.addItem(customMenuItem)
        return menu
    }
}
