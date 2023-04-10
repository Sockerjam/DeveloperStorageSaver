//
//  InfoView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 29/03/2023.
//

import SwiftUI

protocol InfoDelegate: AnyObject {
    func showInfoWindow()
}

struct InfoView: View {
    
    weak var delegate: InfoDelegate?
    
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.pink)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
