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
}

enum UserDefaultError: Error {
    case urlIsNil
}

class UserDefaultManager {

    @Published var directoryIsSaved: Bool?
    @Published var xcodeApplicationIsSaved: Bool?

    static let shared = UserDefaultManager()

    init() {}

    private let standard = UserDefaults.standard

    func saveDirectoryBookmark(data: Data, xcode: Bool) {

        standard.set(data, forKey: xcode ? UserDefaultKey.xcode.rawValue : UserDefaultKey.directory.rawValue)

        if xcode {
            xcodeApplicationIsSaved = true
        } else {
            directoryIsSaved = true
        }
    }

    func fetchDeveloperBookmark() throws -> URL? {

        guard let bookmarkData = standard.data(forKey: UserDefaultKey.directory.rawValue) else { directoryIsSaved = false; return nil }

        var bookmarkIsStale = false

        do {
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkIsStale)
            if bookmarkIsStale {
                directoryIsSaved = false
                return nil
            }
            directoryIsSaved = true
            return url
        } catch {
            throw UserDefaultError.urlIsNil
        }

    }

    func fetchXcodeBookmark() throws -> URL? {

        guard let bookmarkData = standard.data(forKey: UserDefaultKey.xcode.rawValue) else { xcodeApplicationIsSaved = false; return nil}

        var bookmarkIsStale = false

        do {
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkIsStale)
            if bookmarkIsStale {
                xcodeApplicationIsSaved = false
                return nil
            }
            xcodeApplicationIsSaved = true
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
