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
                 To Use Developer Storage Saver please
                 select your User/Library/Developer
                 Directory and Application/Xcode.app
                 location.
                 """)
            if onboardingViewModel.directorySelectedIsWrong {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.vertical, 2)
                        .foregroundColor(.red)
                    Text("You Selected The Wrong Directory. Try Again")
                }
                .padding(.horizontal, 5)
                .background(.orange)
            }
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: false)
            } label: {
                HStack {

                    Image(systemName: directorySelected ? "checkmark.circle.fill" : "folder.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.vertical, 2)
                        .foregroundColor(directorySelected ? .green : .white)
                    Text("Select Your Developer Directory")
                        .foregroundColor(.white)

                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            if onboardingViewModel.xcodeApplicationSelectedIsWrong {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.vertical, 2)
                        .foregroundColor(.red)
                    Text("You Selected The Wrong Application. Try Again")
                }
                .padding(.horizontal, 5)
                .background(.orange)
            }
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: true)
            } label: {
                HStack {
                    Image(systemName: xcodeApplicationSelected ? "checkmark.circle.fill" : "folder.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.vertical, 2)
                        .foregroundColor(xcodeApplicationSelected ? .green : .white)
                    Text("Select Your Xcode Application")
                        .foregroundColor(.white)
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
