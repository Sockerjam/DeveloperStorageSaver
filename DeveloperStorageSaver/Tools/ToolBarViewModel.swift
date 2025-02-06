//
//  ToolBarViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 10/04/2023.
//

import Foundation
import SwiftUI
import Combine

class ToolbarViewModel: ObservableObject {

    @Published var launchAtStartup: Bool = false

    private let userDefaultManager = UserDefaultManager.shared
    private let launchAtStartupManager = LaunchAtStartupManager.shared

    private var cancellable: AnyCancellable?

    init() {
        fetchLaunchAtStartupState()
        setupSubscription()
    }

    private func setupSubscription() {
        
        cancellable = $launchAtStartup
            .sink { state in
                switch state {
                case true:
                    self.launchAtStartupManager.setStartAppAtLaunch(state: true)
                case false:
                    self.launchAtStartupManager.setStartAppAtLaunch(state: false)
                }
            }
    }

    private func fetchLaunchAtStartupState() {
        launchAtStartup = userDefaultManager.fetchLaunchAtLoginState()
    }

    func terminateApplication() {
        NSApplication.shared.terminate(self)
    }
}
