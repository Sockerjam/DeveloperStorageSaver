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

    var body: some View {
        HStack {
            Toggle("Launch at Login", isOn: $toolbarViewModel.launchAtStartup)
                .foregroundColor(.white)
                .controlSize(.large)
            Spacer()
            Button {
                toolbarViewModel.terminateApplication()
            } label: {
                Text("Quit")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 6)
    }
}

struct ToolbarView_Preview: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
