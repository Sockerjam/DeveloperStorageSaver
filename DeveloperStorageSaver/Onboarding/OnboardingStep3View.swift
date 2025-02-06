//
//  OnboardingStep3View.swift
//  DiskDevPro
//
//  Created by Niclas Jeppsson on 06/02/2025.
//

import SwiftUI

struct OnboardingStep3View: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Perfect 🚀")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .shadow(radius: 3)
            }
            VStack(alignment: .leading) {
                Text("Last Step:")
                    .font(.title2)
                    .padding(.bottom, 2)
                Text("Launch DiskDevPro at startup?")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 4)
                Text("""
                (This will keep DiskDevPro running in your toolbar)
                """)
                .font(.footnote)
                .padding(.bottom, 8)
            }
            HStack(alignment: .center) {
                Toggle("On/Off", isOn: $onboardingViewModel.launchAtStartup)
            }
            HStack {
                Button {
                    onboardingViewModel.finishOnboarding()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text("Finish")
                            .foregroundColor(.white)
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 12)
            }
        }
    }
}
