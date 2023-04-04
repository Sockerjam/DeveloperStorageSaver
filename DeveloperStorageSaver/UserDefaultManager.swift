//
//  CoreDataManager.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 02/04/2023.
//

import Foundation
import Combine

enum UserDefaultKey: String, CaseIterable {
    case directory
    case xcode
    case onboarded
}

enum UserDefaultError: Error {
    case urlIsNil
}

class UserDefaultManager {

    let directoryPublisher = PassthroughSubject<Bool, Never>()
    let xcodePublisher = PassthroughSubject<Bool, Never>()
    let directoryBookmarkPublisher = PassthroughSubject<Bool, Never>()
    let xcodeDirectoryBookmarkPublisher = PassthroughSubject<Bool, Never>()

    private let standard = UserDefaults.standard

    static let shared = UserDefaultManager()

    init() {}

    func saveDirectoryBookmark(data: Data, xcode: Bool) {

        standard.set(data, forKey: xcode ? UserDefaultKey.xcode.rawValue : UserDefaultKey.directory.rawValue)

        if xcode {
            xcodePublisher.send(true)
            xcodePublisher.send(completion: .finished)
        } else {
            directoryPublisher.send(true)
            directoryPublisher.send(completion: .finished)
        }

        setUserOnboarded()
    }

    func setUserOnboarded() {
        guard standard.data(forKey: UserDefaultKey.xcode.rawValue) != nil  && standard.data(forKey: UserDefaultKey.directory.rawValue) != nil else { return }
        standard.set(true, forKey: UserDefaultKey.onboarded.rawValue)
        print("onboarding set")
    }

    func isUserOboarded() -> Bool {
        print("User is onboarded:", standard.bool(forKey: UserDefaultKey.onboarded.rawValue))
        return standard.bool(forKey: UserDefaultKey.onboarded.rawValue)
    }

    func fetchDeveloperBookmark() throws -> URL? {

        guard let bookmarkData = standard.data(forKey: UserDefaultKey.directory.rawValue) else { directoryBookmarkPublisher.send(false); return nil }

        var bookmarkIsStale = false

        do {
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkIsStale)
            if bookmarkIsStale {
                directoryBookmarkPublisher.send(false)
                return nil
            }
            directoryBookmarkPublisher.send(true)
            directoryBookmarkPublisher.send(completion: .finished)
            return url
        } catch {
            throw UserDefaultError.urlIsNil
        }

    }

    func fetchXcodeBookmark() throws -> URL? {

        guard let bookmarkData = standard.data(forKey: UserDefaultKey.xcode.rawValue) else { xcodeDirectoryBookmarkPublisher.send(false); return nil}

        var bookmarkIsStale = false

        do {
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkIsStale)
            if bookmarkIsStale {
                xcodeDirectoryBookmarkPublisher.send(false)
                return nil
            }
            xcodeDirectoryBookmarkPublisher.send(true)
            xcodeDirectoryBookmarkPublisher.send(completion: .finished)
            return url
        } catch {
            throw UserDefaultError.urlIsNil
        }
    }
}

extension UserDefaultManager {
    func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            standard.removePersistentDomain(forName: bundleID)
        }
    }
}
