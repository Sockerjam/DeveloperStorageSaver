//
//  ButtonView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 28/03/2023.
//

import SwiftUI

struct ButtonView: View {

    @Binding var selection: StorageSize?
    @Binding var buttonDisabled: Bool

    let storageSize: StorageSize
    let loadingState: LoadingState

    var body: some View {
        Button {
            if selection == storageSize {
                selection = nil
                buttonDisabled = true
            } else {
                selection = storageSize
                buttonDisabled = false
            }
        } label: {
            HStack {
                Image(systemName: getSymbolName())
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(2)
                Text(storageSize.directory.rawValue + ": ")
                    .bold()
                Spacer()
                if loadingState == .loading {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Text(storageSize.size)
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderedProminent)
        .tint(selection == storageSize ? .blue : .gray)
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .controlSize(.large)
    }
    
    private func getSymbolName() -> String {
        switch storageSize.directory {
        case .coreSimulatorDevices:
            "apps.iphone"
        case .coreSimulatorCaches:
            "server.rack"
        case .xcodeDerivedData:
            "folder"
        }
    }
}
