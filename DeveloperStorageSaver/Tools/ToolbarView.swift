//
//  ToolbarView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 10/04/2023.
//

import SwiftUI

protocol ToolbarDelegate: AnyObject {
    func terminateApplication()
    func setAppLaunchSetting(open: Bool)
}

struct ToolbarView: View {

    @StateObject var toolbarViewModel = ToolbarViewModel()

    @State private var launchAtLogin = true

    var body: some View {
        HStack {
            Toggle("Launch at Login", isOn: $toolbarViewModel.launchAtLogin)
                .foregroundColor(.white)
                .controlSize(.large)
                .padding(.leading, 5)
            Spacer()
            Button {
                toolbarViewModel.terminateApplication()
            } label: {
                Text("Quit")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
            .padding(.trailing, 5)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink)
    }
}

struct ToolbarView_Preview: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
