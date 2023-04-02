//
//  LoadingBarView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 28/03/2023.
//

import SwiftUI

struct LoadingBarView: View {
    
    @EnvironmentObject var viewModel: StorageViewModel

    var loadingPercentage: Double
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }.loadingAnimation(width: proxy.size.width, loadingPercentage: loadingPercentage) {
                    withAnimation(.easeIn(duration: 0.6)) {
                        viewModel.reloadScreen()
                    }
                }
                .loadingTextAnimation(loadingPercentage: loadingPercentage)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
