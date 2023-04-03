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
                 please select your Library/Developer
                 Directory and Application/Xcode.app
                 location.
                 """)
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: false)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(directorySelected ? .green : .white)
                    Text("Select Developer Directory")
                }
            }
            .buttonStyle(.borderedProminent)

            .padding()
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: true)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(xcodeApplicationSelected ? .green : .white)
                    Text("Select Xcode Application")
                }
            }
            .buttonStyle(.borderedProminent)


        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Gradient(colors: [.purple, .pink]))
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
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
