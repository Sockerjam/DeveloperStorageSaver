//
//  ContentView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 15/03/2023.
//

import SwiftUI

struct StorageMainView: View {

    @State private var userState: UserState = .onboarding
    
    var body: some View {
        switch userState {
        case .onboarding:
            OnboardingView(userState: $userState)
        case .storageView:
            StorageDetailInfoView(userState: $userState)
        }
    }
}

struct StorageDetailInfoView: View {
    
    @StateObject var viewModel = StorageViewModel()

    @State private var selection: StorageSize?
    @State private var buttonDisabled = true
    
    @Binding var userState: UserState

    var body: some View {
        VStack {
            StorageDetailView(selection: $selection, buttonDisabled: $buttonDisabled)

            HStack {
                if selection?.directory == .coreSimulatorDevices {
                    Button {
                        Task {
                            await viewModel.removeSimulators(option: .unavailable, directory: selection?.directory)
                        }
                        
                    } label: {
                        Label("Delete Unavailable", systemImage: "trash.circle")
                            .contentShape(Rectangle())
                            .foregroundColor(.white)
                    }
                }
                Button {
                    Task {
                        if selection?.directory == .coreSimulatorDevices {
                            await viewModel.removeSimulators(option: .all, directory: selection?.directory)
                        } else {
                            await viewModel.remove(directory: selection?.directory)
                        }
                    }
                    
                } label: {
                    Label(selection?.directory == .coreSimulatorDevices ? "Delete All" : "Delete", systemImage: "trash.circle")
                        .contentShape(Rectangle())
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 10)
            .disabled(buttonDisabled)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .tint(buttonDisabled ? .gray : .blue)
            .shadow(radius: 2)
            if selection?.directory == .coreSimulatorDevices {
                Text("Deleting All Requires Re-Installation Of Devices")
                    .font(.footnote)
            }
            Spacer()
            HStack {
                Button {
                    viewModel.resetApplication()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "gobackward")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text("Reset")
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.link)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }
        .frame(maxHeight: .infinity)
        .onReceive(viewModel.$buttonDisabled) { buttonEnabled in
            guard let buttonEnabled = buttonEnabled else { return }
            self.buttonDisabled = buttonEnabled
        }
        .onReceive(viewModel.$userState) { userState in
            self.userState = userState
        }
        .environmentObject(viewModel)
        .padding(.top, 10)
        .background(.gray)
        .task {
            await viewModel.loadSizes()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StorageMainView()
    }
}
