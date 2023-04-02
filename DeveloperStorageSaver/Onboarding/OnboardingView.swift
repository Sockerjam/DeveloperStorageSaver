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

    var body: some View {
        VStack {
            Text("""
                 To Use Developer Storage Saver
                 please select your Developer
                 Directory and Xcode Application
                 location.
                 """)
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: false)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(directorySelected ? .green : .gray)
                    Text("Select Developer Directory")

                }
            }
            .padding()
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: true)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(xcodeApplicationSelected ? .green : .gray)
                    Text("Select Xcode Application")

                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onReceive(onboardingViewModel.$directorySelected) { directorySelected in
            withAnimation(.easeIn(duration: 1)) {
                self.directorySelected = directorySelected
            }

        }
        .onReceive(onboardingViewModel.$xcodeApplicationSelected) { xcodeApplicationSelected in
            withAnimation(.easeIn(duration: 1)) {
                self.xcodeApplicationSelected = xcodeApplicationSelected
            }

        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
