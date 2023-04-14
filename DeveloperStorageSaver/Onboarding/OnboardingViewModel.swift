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
    @Published var directorySelectedIsWrong: Bool = false
    @Published var xcodeApplicationSelectedIsWrong: Bool = false

    private let nsOpenPalen = NSOpenPanel()
    private let userDefaultManager = UserDefaultManager.shared
    private let fileManager = FileManager.default

    func setupNSOpenPanel(xcode: Bool) {

        nsOpenPalen.prompt = "Select"
        nsOpenPalen.message = xcode ? "Please select your Applications/Xcode Application" : "Please select your Users/user_name/Library/Developer Directory"

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

            guard directoryIsCorrect(selectedDirectory: userSelectedDirectory, xcode: xcode) else { return }

            let appendedDirectory = userSelectedDirectory.appending(path: xcode ? "Contents/Developer/usr/bin" : "")

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

    private func directoryIsCorrect(selectedDirectory: URL, xcode: Bool) -> Bool {

        if xcode {
            let infoPlistPath = selectedDirectory.appendingPathComponent("Contents/Info.plist")
            print(infoPlistPath.path())
            if fileManager.fileExists(atPath: infoPlistPath.path()) {
                guard let plistDictionary = NSDictionary(contentsOf: URL(filePath: infoPlistPath.path())) else { xcodeApplicationSelectedIsWrong = true; return false }
                guard plistDictionary["CFBundleName"] as? String == "Xcode" else { xcodeApplicationSelectedIsWrong = true; return false }
                xcodeApplicationSelectedIsWrong = false
                return true
            } else {
                print("FALSE")
                xcodeApplicationSelectedIsWrong = true
                return false
            }
        } else {
            let developerPath = selectedDirectory.appendingPathComponent("CoreSimulator")
            print(developerPath.path())
            if fileManager.fileExists(atPath: developerPath.path()) {
                directorySelectedIsWrong = false
                return true
            } else {
                directorySelectedIsWrong = true
                return false
            }
        }

    }
}
