//
//  ContentView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 15/03/2023.
//

import SwiftUI

struct StorageMainView: View {

    @StateObject var viewModel = StorageViewModel()

    var body: some View {
        switch viewModel.userState {
        case .onboarding:
            OnboardingView()
        case .storageView:
            StorageDetailInfoView()
                .environmentObject(viewModel)
        }
    }
}

struct StorageDetailInfoView: View {
    
    @EnvironmentObject var viewModel: StorageViewModel

    @State private var selection: StorageSize?
    @State private var buttonDisabled = true

    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
            case .loaded:
                StorageDetailView(selection: $selection, buttonDisabled: $buttonDisabled)
            }

            HStack {
                if selection?.directory == .coreSimulatorDevices {
                    Button {
                        viewModel.removeSimulators(option: .unavailable, directory: selection?.directory)
                    } label: {
                        Label("Delete Unavailable", systemImage: "trash.circle")
                            .contentShape(Rectangle())
                            .foregroundColor(.white)
                    }
                }
                Button {
                    if selection?.directory == .coreSimulatorDevices {
                        viewModel.removeSimulators(option: .all, directory: selection?.directory)
                    } else {
                        viewModel.remove(directory: selection?.directory)
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
            .tint(buttonDisabled ? .gray : .red)
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
                    HStack(spacing: 5) {
                        Image(systemName: "gobackward")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.accentColor)
                        Text("Reset")
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 5)
                    .padding(.bottom, 2)
                }
                .buttonStyle(.link)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .frame(maxHeight: .infinity)
        .onReceive(viewModel.$buttonDisabled) { buttonEnabled in
            guard let buttonEnabled = buttonEnabled else { return }
            self.buttonDisabled = buttonEnabled
        }
        .environmentObject(viewModel)
        .padding(.top, 10)
        .background(Gradient(colors: [.purple, .pink]))
        .onAppear {
            viewModel.loadSizes()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StorageMainView()
    }
}
