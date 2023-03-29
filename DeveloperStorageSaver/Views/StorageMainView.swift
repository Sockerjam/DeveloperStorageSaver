//
//  ContentView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 15/03/2023.
//

import SwiftUI

struct StorageMainView: View {

    @StateObject var viewModel = ViewModel()

    @State private var selection: StorageSize?
    @State private var buttonDisabled = true

    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
                    .foregroundColor(.white)
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
            .padding(.top, 5)
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
        }
        .frame(maxHeight: .infinity)
        .onReceive(viewModel.$buttonDisabled) { buttonEnabled in
            guard let buttonEnabled = buttonEnabled else { return }
            self.buttonDisabled = buttonEnabled
        }
        .environmentObject(viewModel)
        .padding(.top, 10)
        .background(Gradient(colors: [.purple, .pink])).edgesIgnoringSafeArea(.all)
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
