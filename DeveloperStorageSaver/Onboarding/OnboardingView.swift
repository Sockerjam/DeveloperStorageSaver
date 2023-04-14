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
            VStack(alignment: .leading) {
                Text("Please Select Your:")
                    .font(.headline)
                Text("Users/user_name/Library/Developer Directory")
                    .font(.callout)
                Text("And")
                    .font(.headline)
                Text("Application/Xcode.app Application")
                    .font(.callout)
                if onboardingViewModel.directorySelectedIsWrong {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.vertical, 2)
                            .foregroundColor(.red)
                        Text("""
                             You Selected The Wrong Directory.
                             Try Again.
                             """)
                    }
                    .background(.orange)
                }
                Button {
                    onboardingViewModel.setupNSOpenPanel(xcode: false)
                } label: {
                    HStack {
                        Image(systemName: directorySelected ? "checkmark.circle.fill" : "folder.fill")
                            .resizable()
                            .frame(width: directorySelected ? 20 : 15, height: directorySelected ? 20 : 15)
                            .padding(.vertical, 2)
                            .foregroundColor(directorySelected ? .green : .white)
                        Text("Select Your Developer Directory")
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 15)
                if onboardingViewModel.xcodeApplicationSelectedIsWrong {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.vertical, 2)
                            .foregroundColor(.red)
                        Text("""
                             You Selected The Wrong Application.
                             Try Again.
                             """)
                    }
                    .background(.orange)
                }
                Button {
                    onboardingViewModel.setupNSOpenPanel(xcode: true)
                } label: {
                    HStack {
                        Image(systemName: xcodeApplicationSelected ? "checkmark.circle.fill" : "folder.fill")
                            .resizable()
                            .frame(width: xcodeApplicationSelected ? 20 : 15, height: xcodeApplicationSelected ? 20 : 15)
                            .padding(.vertical, 2)
                            .foregroundColor(xcodeApplicationSelected ? .green : .white)
                        Text("Select Your Xcode Application")
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
