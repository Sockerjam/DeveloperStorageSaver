//
//  OnboardingStep1View.swift
//  DiskDevPro
//
//  Created by Niclas Jeppsson on 13/10/2024.
//

import SwiftUI

struct OnboardingStep1View: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if onboardingViewModel.directorySelectedIsWrong {
                warningLabel
                    .padding(.bottom, 6)
            }
            Text("Select Your Developer Directory")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 2)
            Text("Path: Library/Developer")
                .font(.body)
                .padding(.bottom, 4)
            Text("""
                (Library can sometimes be hidden in Finder. 
                Use Shift + Command + . to show hidden files)
                """)
                .font(.footnote)
                .padding(.bottom, 4)
            Button {
                onboardingViewModel.setupNSOpenPanel(xcode: false)
            } label: {
                HStack {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                    Text("Browse for Developer Directory")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 12)
        }
    }
    
    private var warningLabel: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.vertical, 2)
                
            Text("""
                 You Selected The Wrong Directory.
                 Try Again.
                 """)
            .font(.callout)
        }
        .foregroundColor(.red)
        .padding(4)
        .background(.white)
        .cornerRadius(8)
    }
}
