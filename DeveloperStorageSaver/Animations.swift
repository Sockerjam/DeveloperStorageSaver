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

    var animatableData: Double {
        get { loadingPercentage }
        set { loadingPercentage = newValue }
    }

    func body(content: Content) -> some View {
        content
            .frame(width: width * CGFloat(loadingPercentage))
    }
}

struct TextAnimatable: ViewModifier, Animatable {

    var loadingPercentage: Double

    var animatableData: Double {
        get { loadingPercentage }
        set { print(newValue); loadingPercentage = newValue }
    }

    func body(content: Content) -> some View {
        content
            .animation(.linear(duration: 0.1), value: loadingPercentage)
    }
}

extension View {

    func loadingAnimation(width: Double, loadingPercentage: Double) -> some View {
        modifier(LoadingBarAnimatable(width: width, loadingPercentage: loadingPercentage))
    }

    func textAnimation(loadingPercentage: Double) -> some View {
        modifier(TextAnimatable(loadingPercentage: loadingPercentage))
    }
}
