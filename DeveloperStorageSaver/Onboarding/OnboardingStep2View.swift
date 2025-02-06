//
//  OnboardingStep2View.swift
//  DiskDevPro
//
//  Created by Niclas Jeppsson on 13/10/2024.
//

import SwiftUI

struct OnboardingStep2View: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    let xcodeApplicationSelected: Bool
    
    var body: some View {
        VStack {
            if onboardingViewModel.xcodeApplicationSelectedIsWrong {
                warningLabel
                    .padding(.bottom, 6)
            }
            HStack(alignment: .center) {
                Text("Perfect 🚀")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .shadow(radius: 3)
            }
            VStack(alignment: .leading) {
                Text("Next Step:")
                    .font(.title2)
                    .padding(.bottom, 2)
                Text("Please select your Xcode.app")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 4)
                Button {
                    onboardingViewModel.setupNSOpenPanel(xcode: true)
                } label: {
                    HStack {
                        Image(systemName: xcodeApplicationSelected ? "checkmark.circle.fill" : "hammer.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(xcodeApplicationSelected ? .green : .white)
                        Text("Select Your Xcode Application")
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 12)
            }
        }
    }
    
    private var warningLabel: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.vertical, 2)
                
            Text("""
                 You Selected The Wrong Application.
                 Try Again.
                 """)
            .font(.callout)
        }
        .foregroundColor(.red)
        .background(.white)
    }
}

