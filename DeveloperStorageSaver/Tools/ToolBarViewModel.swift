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
    @Published var isOnboarded: Bool = false

    private let userDefaultManager = UserDefaultManager.shared
    private let launchAtStartupManager = LaunchAtStartupManager.shared

    private var cancellable = Set<AnyCancellable>()

    init() {
        fetchUserIsOnboarded()
        fetchLaunchAtStartupState()
        setupSubscription()
    }

    private func setupSubscription() {
        
        $launchAtStartup
            .sink { state in
                switch state {
                case true:
                    self.launchAtStartupManager.setStartAppAtLaunch(state: true)
                case false:
                    self.launchAtStartupManager.setStartAppAtLaunch(state: false)
                }
            }.store(in: &cancellable)
        
        userDefaultManager.launchAtLoginPublisher
            .sink { state in
                switch state {
                case true:
                    self.launchAtStartup = true
                case false:
                    self.launchAtStartup = false
                }
            }
            .store(in: &cancellable)
        
        userDefaultManager.userIsOnboardedPublisher
            .sink { state in
                switch state {
                case true:
                    self.isOnboarded = true
                case false:
                    self.isOnboarded = false
                }
            }
            .store(in: &cancellable)
    }
    
    private func fetchUserIsOnboarded() {
        isOnboarded = userDefaultManager.isUserOboarded()
    }

    private func fetchLaunchAtStartupState() {
        launchAtStartup = userDefaultManager.fetchLaunchAtLoginState()
    }

    func terminateApplication() {
        NSApplication.shared.terminate(self)
    }
}
