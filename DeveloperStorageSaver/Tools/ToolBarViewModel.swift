//
//  ToolBarViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 10/04/2023.
//

import Foundation
import SwiftUI
import ServiceManagement
import Combine

class ToolbarViewModel: ObservableObject {

    private enum Constant {
        static let bundleID = "com.niclasjeppsson.AutoLauncher"
    }

    @Published var launchAtLogin: Bool = true

    private let appService = SMAppService()
    private let userDefaultManager = UserDefaultManager.shared

    private var cancellable: AnyCancellable?

    init() {
        fetchLaunchAtLoginState()
        setupSubscription()
    }

    private func setupSubscription() {

        cancellable = $launchAtLogin
            .sink { state in
                switch state {
                case true:
                    print("Combine True")
                    do {
                        SMAppService.loginItem(identifier: Constant.bundleID)
                        try self.appService.register()
                        self.userDefaultManager.setLaunchAtLoginState(true)
                    } catch {
                        print("AppService Register Error: \(error.localizedDescription)")
                    }

                case false:
                    print("Combine False")
                    self.appService.unregister { error in
                        print("AppService Unregister Error: \(error)")
                    }
                    self.userDefaultManager.setLaunchAtLoginState(false)
                }

            }
    }

    private func fetchLaunchAtLoginState() {
        guard let launchAtLogin = userDefaultManager.fetchLaunchAtLoginState() else { self.launchAtLogin = true; return }
        self.launchAtLogin = launchAtLogin
    }

    func terminateApplication() {
        NSApplication.shared.terminate(self)
    }
}
