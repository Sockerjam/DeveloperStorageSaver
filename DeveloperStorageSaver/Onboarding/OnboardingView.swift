//
//  OnboardingView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 02/04/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var onboardingViewModel = OnboardingViewModel()
    
    @State var directorySelected: Bool = false
    @State var xcodeApplicationSelected: Bool = false
    @Binding var userState: UserState
    
    var body: some View {
        Group {
            switch onboardingViewModel.onboardingStep {
            case .step1:
                OnboardingStep1View(directorySelected: $directorySelected)
            case .step2:
                OnboardingStep2View(xcodeApplicationSelected: $xcodeApplicationSelected)
            }
        }
        .environmentObject(onboardingViewModel)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onReceive(onboardingViewModel.$directorySelected) { directorySelected in
            withAnimation(.easeIn(duration: 0.6)) {
                self.directorySelected = directorySelected
            }
            
        }
        .onReceive(onboardingViewModel.$xcodeApplicationSelected) { xcodeApplicationSelected in
            withAnimation(.easeIn(duration: 0.6)) {
                self.xcodeApplicationSelected = xcodeApplicationSelected
            }
        }
        .onReceive(onboardingViewModel.$userState) { userState in
            self.userState = userState
        }
    }
}



