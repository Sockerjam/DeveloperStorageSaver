//
//  CoreDataManager.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 02/04/2023.
//

import Foundation
import Combine

enum UserDefaultKey: String {
    case directory
    case xcode
}

class UserDefaultManager {

    @Published var directoryIsSaved: Bool = false
    @Published var xcodeApplicationIsSaved: Bool = false

    static let shared = UserDefaultManager()

    init() {}

    private let standard = UserDefaults.standard

    func saveDirectoryBookmark(data: Data, xcode: Bool) {

        standard.set(data, forKey: xcode ? UserDefaultKey.xcode.rawValue : UserDefaultKey.directory.rawValue)
    }

    func fetchBookmark() {
        
    }
}
