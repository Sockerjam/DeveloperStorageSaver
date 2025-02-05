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
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                        .padding(.leading, 6)
                }
                .buttonStyle(.link)
                .background(.clear.opacity(0))
                .controlSize(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
