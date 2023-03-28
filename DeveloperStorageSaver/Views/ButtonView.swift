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

    var storageSize: StorageSize

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
                Image(systemName: "hammer.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                    .overlay {
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                    }
                    .padding(.horizontal, 2)
                Text(storageSize.directory.rawValue + ": ")
                    .bold()
                Spacer()
                Text(storageSize.size)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selection == storageSize ? .red : .white)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderedProminent)
        .tint(.purple)
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .controlSize(.large)
    }
}
