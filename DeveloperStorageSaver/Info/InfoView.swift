//
//  InfoView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 29/03/2023.
//

import SwiftUI

protocol InfoDelegate {
    func showInfoWindow()
    func terminateApplication()
}

struct InfoView: View {
    
    @State private var launchAtLogin = false
    
    var delegate: InfoDelegate?
    
    var body: some View {
            HStack {
                Button {
                    delegate?.showInfoWindow()
                } label: {
                    Text("Read Before Use")
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.leading, 5)
                }
                .buttonStyle(.plain)
                .controlSize(.large)
                
                Spacer()
                Button {
                    delegate?.terminateApplication()
                } label: {
                    Text("Quit")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.trailing, 5)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .controlSize(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.pink)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
