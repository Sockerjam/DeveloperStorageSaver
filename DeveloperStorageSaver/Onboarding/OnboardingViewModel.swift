//
//  OnboardingViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 02/04/2023.
//

import Foundation
import AppKit

enum OnboardingStep {
    case step1, step2
}

class OnboardingViewModel: ObservableObject {

    @Published var onboardingStep: OnboardingStep = .step1
    @Published var directorySelected: Bool = false
    @Published var xcodeApplicationSelected: Bool = false
    @Published var directorySelectedIsWrong: Bool = false
    @Published var xcodeApplicationSelectedIsWrong: Bool = false

    private let nsOpenPalen = NSOpenPanel()
    private let userDefaultManager = UserDefaultManager.shared
    private let fileManager = FileManager.default

    @MainActor
    func setupNSOpenPanel(xcode: Bool) {

        nsOpenPalen.prompt = "Select"
        nsOpenPalen.message = xcode ? "Please select the Applications/Xcode.app" : "Please select your developer directory"

        nsOpenPalen.canChooseFiles = xcode
        nsOpenPalen.allowedContentTypes = [.directory]
        nsOpenPalen.allowsOtherFileTypes = false

        nsOpenPalen.allowsMultipleSelection = false
        nsOpenPalen.canChooseDirectories = true

        launchNSOpenPanel(xcode: xcode)

    }

    @MainActor
    private func launchNSOpenPanel(xcode: Bool) {
       
        nsOpenPalen.orderFront(nil)
        let dialogueButtonPressed = nsOpenPalen.runModal()

        if dialogueButtonPressed == NSApplication.ModalResponse.OK {

            guard let userSelectedDirectory = nsOpenPalen.urls.first else { return }

            guard directoryIsCorrect(selectedDirectory: userSelectedDirectory, xcode: xcode) else { return }

            let appendedDirectory = userSelectedDirectory.appending(path: xcode ? "Contents/Developer/usr/bin" : "")

            saveToBookmark(selectedDirectory: appendedDirectory, xcode: xcode)

        } else if dialogueButtonPressed == NSApplication.ModalResponse.cancel {
            nsOpenPalen.close()
        }
    }

    private nonisolated func saveToBookmark(selectedDirectory: URL, xcode: Bool) {

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

    private nonisolated func directoryIsCorrect(selectedDirectory: URL, xcode: Bool) -> Bool {

        if xcode {
            let infoPlistPath = selectedDirectory.appendingPathComponent("Contents/Info.plist")
            if fileManager.fileExists(atPath: infoPlistPath.path()) {
                guard let plistDictionary = NSDictionary(contentsOf: URL(filePath: infoPlistPath.path())) else { xcodeApplicationSelectedIsWrong = true; return false }
                guard plistDictionary["CFBundleName"] as? String == "Xcode" else { xcodeApplicationSelectedIsWrong = true; return false }
                xcodeApplicationSelectedIsWrong = false
                return true
            } else {
                xcodeApplicationSelectedIsWrong = true
                return false
            }
        } else {
            if fileManager.fileExists(atPath: selectedDirectory.appendingPathComponent("CoreSimulator").path()) && fileManager.fileExists(atPath: selectedDirectory.appendingPathComponent("Xcode").path()) {
                directorySelectedIsWrong = false
                onboardingStep = .step2
                return true
            } else {
                directorySelectedIsWrong = true
                onboardingStep = .step1
                return false
            }
        }

    }
}
