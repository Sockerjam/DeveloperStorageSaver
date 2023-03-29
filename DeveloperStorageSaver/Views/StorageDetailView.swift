//
//  StorageDetailView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 28/03/2023.
//

import SwiftUI

struct StorageDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var selection: StorageSize?
    @Binding var buttonDisabled: Bool
    
    @State private var loadingPercentage: Double = 0.0
    
    var body: some View {
        ForEach(viewModel.storageSizes, id: \.self) { storageSize in
            if storageSize.directory == viewModel.directoryToDelete {
                LoadingBarView(loadingPercentage: loadingPercentage)
                    .padding(.horizontal, 5)
                    .frame(height: 35)
            } else {
                ButtonView(selection: $selection, buttonDisabled: $buttonDisabled, storageSize: storageSize)
                    .frame(height: 35)
            }
            Rectangle()
                .frame(height: 1)
        }
        .onReceive(viewModel.$loadingTime) { loadingTime in
            withAnimation(.easeIn(duration: 2)) {
                loadingPercentage = loadingTime
            }
        }
    }
}
