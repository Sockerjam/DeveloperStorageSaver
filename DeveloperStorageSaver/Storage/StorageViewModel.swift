//
//  ViewModel.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 16/03/2023.
//

import Foundation
import SwiftUI
import Combine

enum StorageDirectory: String, Hashable {
    case coreSimulatorDevices = "Core Simulator Device"
    case coreSimulatorCaches = "Core Simulator Caches"
    case xcodeDerivedData = "Xcode Derived Data"

    var path: String {
        switch self {
        case .coreSimulatorDevices:
            return "CoreSimulator/Devices"
        case .coreSimulatorCaches:
            return "CoreSimulator/Caches"
        case .xcodeDerivedData:
            return "Xcode/DerivedData"
        }
    }
}

enum DeleteSimulator: String {
    case all
    case unavailable
}

enum LoadingState {
    case loading
    case loaded
}

enum UserState {
    case onboarding
    case storageView
}

@MainActor
class StorageViewModel: NSObject, ObservableObject {

    @Published var storageSizes: [StorageSize] = []
    @Published var directoryToDelete: StorageDirectory?
    @Published var loadingTime: Double = 0.0
    @Published var buttonDisabled: Bool?
    @Published var loadingState: LoadingState = .loading
    @Published var userState: UserState = .onboarding

    @Published var directoryIsSaved: Bool = false
    @Published var xcodeApplicationIsSaved: Bool = false
  
    private let fileManager = FileManager.default
    private let userDefaultManager = UserDefaultManager.shared
    private let byteCountFormatter = ByteCountFormatter()

    private var task: Process?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private var cancellable = Set<AnyCancellable>()

    override init() {
        super.init()
        userDefaultManager.resetDefaults()
        if userDefaultManager.isUserOboarded() {
            print("User is onboarded")
            setupStorageViewSubscription()
            userState = .storageView
        } else {
            print("launching onboarding")
            setupOnboardingSubscription()
        }

    }
    
    private func setupOnboardingSubscription() {

        userDefaultManager.directoryPublisher
            .combineLatest(userDefaultManager.xcodePublisher)
            .flatMap { directory, xcode -> AnyPublisher<Bool, Never> in
                if directory && xcode == true {
                    return Just(true).eraseToAnyPublisher()
                } else {
                    return Just(false).eraseToAnyPublisher()
                }
            }
            .sink { completion in
                print("Onboarding Subscription Completed with :", completion)
            } receiveValue: { value in
                if value {
                    self.userState = .storageView
                    self.setupStorageViewSubscription()
                } else {
                    self.userState = .onboarding
                }
            }
            .store(in: &cancellable)
    }

    private func setupStorageViewSubscription() {

        userDefaultManager.directoryBookmarkPublisher
            .combineLatest(userDefaultManager.xcodeDirectoryBookmarkPublisher)
            .receive(on: RunLoop.main)
            .flatMap { directory, xcode -> AnyPublisher<Bool, Never> in
                if directory && xcode == true {
                    return Just(true).eraseToAnyPublisher()
                } else {
                    return Just(false).eraseToAnyPublisher()
                }
            }
            .sink { completion in
                print("Storage View Subscription Completed with :", completion)
            } receiveValue: { value in
                if value {
                    self.userState = .storageView
                } else {
                    self.userState = .onboarding
                    self.setupOnboardingSubscription()
                }
            }
            .store(in: &cancellable)
    }

    private func fetchDeveloperPath() -> URL? {

        guard let developerURL = try? userDefaultManager.fetchDeveloperBookmark() else { return nil }
        print("Fetched Developer Bookmark")
        _ = developerURL.startAccessingSecurityScopedResource()
        return developerURL
    }

    private func fetchXcodeApplicationPathURL() -> URL? {

        guard let xcodeApplicationURL = try? userDefaultManager.fetchXcodeBookmark() else { return nil }
        print("Fetched Xcode Bookmark")
        _ = xcodeApplicationURL.startAccessingSecurityScopedResource()
        return xcodeApplicationURL
    }

    func loadSizes() {
        print("Loading Sizes")
        Task {
            async let coreSimulatorDevices = fetchSize(for: .coreSimulatorDevices)
            async let coreSimulatorCaches = fetchSize(for: .coreSimulatorCaches)
            async let xcodeDerivedData = fetchSize(for: .xcodeDerivedData)
            storageSizes = await [coreSimulatorDevices, coreSimulatorCaches, xcodeDerivedData].compactMap {$0}
            loadingState = .loaded
        }
    }
    
    func reloadScreen() {
        self.task = nil
        self.loadSizes()
        self.buttonDisabled = false
        self.directoryToDelete = nil
        self.setLoadingTime(to: 0.0)
    }

    private func setLoadingTime(to value: Double) {
        loadingTime = value
    }
    
    private func fetchSize(for directory: StorageDirectory) async -> StorageSize? {

        guard let libraryPath = fetchDeveloperPath() else { return nil }

        let storagePath = libraryPath.appending(path: directory.path)

        byteCountFormatter.countStyle = .file

        var sizeInMB: String?

        do {
            let _ = try storagePath.checkResourceIsReachable()
            guard let storageURLS = fileManager.enumerator(at: storagePath, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            let storageSizeInKB = try storageURLS.reduce(0) { $0 + (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0)}
            sizeInMB = byteCountFormatter.string(for: storageSizeInKB)
        } catch {
            print(error.localizedDescription)
        }

        libraryPath.stopAccessingSecurityScopedResource()

        return StorageSize(directory: directory, size: sizeInMB ?? "0 MB")
    }

    func remove(directory: StorageDirectory?) {

        guard let directory = directory else { return }
        guard let developerPath = fetchDeveloperPath() else { return }

        buttonDisabled = true
        directoryToDelete = directory

        let storagePath = developerPath.appending(path: directory.path)

        print(storagePath)

        do {
            let _ = try storagePath.checkResourceIsReachable()
            let storageURLS = try fileManager.contentsOfDirectory(at: storagePath, includingPropertiesForKeys: nil)
            try storageURLS.forEach { try fileManager.removeItem(at: $0) }
            setLoadingTime(to: 1.0)
        } catch {
            reloadScreen()
            print(error.localizedDescription)
        }

        developerPath.stopAccessingSecurityScopedResource()
    }

    func removeSimulators(option: DeleteSimulator, directory: StorageDirectory?) {

        task = Process()
        errorPipe = Pipe()
        outputPipe = Pipe()

        guard let task = task,
        let errorPipe = errorPipe,
        let outputPipe = outputPipe else { return }
        guard let directory = directory else { return }
        guard let xcodeApplicationPath = fetchXcodeApplicationPathURL() else { return }
        let applicationPath = xcodeApplicationPath.absoluteString

        buttonDisabled = true
        setLoadingTime(to: 0.0)
        directoryToDelete = directory

        let executableURL = applicationPath.appending("/simctl")

        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.executableURL = URL(filePath: executableURL, directoryHint: .isDirectory, relativeTo: nil)
        task.arguments = ["delete", option.rawValue]
        task.terminationHandler = { [weak self] process in
            guard let self = self else { return }
            Task {
                await MainActor.run {
                    self.setLoadingTime(to: 1.0)
                }
            }
        }

        do {
            try task.run()
        } catch {
            print(error.localizedDescription)
        }

        xcodeApplicationPath.stopAccessingSecurityScopedResource()
    }
}
