//
//  OnboardingViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 02/04/2023.
//

import Foundation
import AppKit

class OnboardingViewModel: ObservableObject {

    @Published var directorySelected: Bool = false
    @Published var xcodeApplicationSelected: Bool = false
    @Published var showAlert: Bool = false

    private let nsOpenPalen = NSOpenPanel()
    private let userDefaultManager = UserDefaultManager.shared

    func setupNSOpenPanel(xcode: Bool) {

        nsOpenPalen.prompt = "Select"
        nsOpenPalen.message = xcode ? "Please select your Xcode Application" : "Please select your Develop Directory"

        nsOpenPalen.canChooseFiles = xcode
        nsOpenPalen.allowedContentTypes = [.directory]
        nsOpenPalen.allowsOtherFileTypes = false

        nsOpenPalen.allowsMultipleSelection = false
        nsOpenPalen.canChooseDirectories = true

        launchNSOpenPanel(xcode: xcode)

    }

    private func launchNSOpenPanel(xcode: Bool) {

        let dialogueButtonPressed = nsOpenPalen.runModal()

        if dialogueButtonPressed == NSApplication.ModalResponse.OK {

            guard let userSelectedDirectory = nsOpenPalen.urls.first else { return }

            guard userSelectedDirectory.absoluteString.contains("Developer") || userSelectedDirectory.absoluteString.contains("Xcode") else { return }

            let appendedDirectory = userSelectedDirectory.appending(path: xcode ? "Contents/Developer/usr/bin" : "")

            print(appendedDirectory)

            saveToBookmark(selectedDirectory: appendedDirectory, xcode: xcode)

        } else if dialogueButtonPressed == NSApplication.ModalResponse.cancel {
            nsOpenPalen.close()
        }
    }

    private func saveToBookmark(selectedDirectory: URL, xcode: Bool) {

        do {
            let bookmarkData = try selectedDirectory.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            userDefaultManager.saveDirectoryBookmark(data: bookmarkData, xcode: xcode)
        } catch {
            print(error.localizedDescription)
            return
        }

        if xcode {
            xcodeApplicationSelected = true
        } else {
            directorySelected = true
        }
    }
}
