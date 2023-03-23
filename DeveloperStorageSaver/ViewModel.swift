//
//  ViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 16/03/2023.
//

import Foundation
import SwiftUI

enum StorageCategory {
    case coreSimulatorDevices
    case coreSimulatorCaches
    case xcodeDerivedData

    var path: String {
        switch self {
        case .coreSimulatorDevices:
            return "Developer/CoreSimulator/Devices"
        case .coreSimulatorCaches:
            return "Developer/CoreSimulator/Caches"
        case .xcodeDerivedData:
            return "Developer/Xcode/DerivedData"
        }
    }
}

@MainActor
class ViewModel: ObservableObject {

    @Published var storageSizes: [StorageSize] = []

    var row = 0

    let byteCountFormatter = ByteCountFormatter()

    init() {
        Task {
            async let coreSimulatorDevices = StorageSize(directory: "Core Simulator Devices", size: fetchSize(for: .coreSimulatorDevices) ?? "Empty")
            async let coreSimulatorCaches = StorageSize(directory: "Core Simulator Caches", size: fetchSize(for: .coreSimulatorCaches) ?? "Empty")
            async let xcodeDerivedData = StorageSize(directory: "Xcode Derived Data", size: fetchSize(for: .xcodeDerivedData) ?? "Empty")
            storageSizes = await [coreSimulatorDevices, coreSimulatorCaches, xcodeDerivedData]
        }
    }

    private func fetchSize(for category: StorageCategory) async -> String? {

        guard let libraryPath = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first else { return nil }

        let storagePath = libraryPath.appending(path: category.path)

        byteCountFormatter.countStyle = .file

        var sizeInMB: String?

        do {
            let _ = try storagePath.checkResourceIsReachable()
            guard let storageURLS = FileManager.default.enumerator(at: storagePath, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            let storageSizeInKB = try storageURLS.reduce(0) { $0 + (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0)}
            sizeInMB = byteCountFormatter.string(for: storageSizeInKB)
        } catch {
            print(error.localizedDescription)
        }

        return sizeInMB
    }
}
