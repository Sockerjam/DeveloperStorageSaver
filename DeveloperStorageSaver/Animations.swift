//
//  Animations.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 28/03/2023.
//

import SwiftUI

struct LoadingBarAnimatable: ViewModifier, Animatable {

    var width: Double
    var loadingPercentage: Double = 0.0
    var targetValue: Double
    var animationComplete: () -> Void
    
    var animatableData: Double {
        didSet {
            didAnimationFinish()
        }
    }
    
    init(width: Double, loadingPercentage: Double, animationComplete: @escaping () -> Void) {
        self.width = width
        self.loadingPercentage = loadingPercentage
        self.targetValue = loadingPercentage
        self.animationComplete = animationComplete
        self.animatableData = loadingPercentage
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: width * CGFloat(loadingPercentage))
    }
        
    private func didAnimationFinish() {
        guard animatableData == targetValue else { return }
        
        DispatchQueue.main.async {
            animationComplete()
        }
    }
}

struct TextAnimatable: ViewModifier, Animatable {
    
    var loadingPercentage: Double = 0.0
    
    var animatableData: Double {
        get { loadingPercentage }
        set { loadingPercentage = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(textBody)
    }
    
    var textBody: some View {
        Text("\(Int(loadingPercentage * 100))%")
            .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 5)
            .font(.subheadline).bold()
            .foregroundColor(.white)
    }
}

extension View {

    func loadingAnimation(width: Double, loadingPercentage: Double, animationComplete: @escaping () -> Void) -> some View {
        modifier(LoadingBarAnimatable(width: width, loadingPercentage: loadingPercentage, animationComplete: animationComplete))
    }
    
    func loadingTextAnimation(loadingPercentage: Double) -> some View {
        modifier(TextAnimatable(loadingPercentage: loadingPercentage))
    }
}
