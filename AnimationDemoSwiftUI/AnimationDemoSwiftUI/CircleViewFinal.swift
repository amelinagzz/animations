//
//  CircleViewFinal.swift
//  AnimationDemoSwiftUI
//
//  Created by Adriana González Martínez on 3/15/21.
//  From https://betterprogramming.pub/2-must-know-protocols-for-swiftui-animation-cd50bf38895e

import SwiftUI

struct AnimatableCircle2: Shape {
    var progress: CGFloat
    func path(in rect: CGRect) -> Path {
        let centerX: CGFloat = rect.width / 2
        let centerY: CGFloat = rect.height / 2
        var path = Path()
        path.addArc(center: CGPoint(x: centerX, y: centerY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 360 * Double(progress)),
                    clockwise: false)
        return path.strokedPath(.init(lineWidth: 6, lineCap: .round, lineJoin: .round))
    }
}

struct PercentageAnimatableCircle: AnimatableModifier {
    var progress: CGFloat = 0

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBackground))
            .overlay(AnimatableCircle2(progress: progress).foregroundColor(Color(.systemIndigo)))
    }
}

struct CircleViewFinal: View {
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .frame(width: 100, height: 100)
                .foregroundColor(Color(.systemGray6))
            
            Circle()
                .frame(width: 100, height: 10)
                .modifier(PercentageAnimatableCircle(progress:progress))
                .animation(Animation.easeInOut.speed(0.25))
                .onAppear() {
                    self.progress = 1
                }
        }
    }
}

struct CircleViewFinal_Previews: PreviewProvider {
    static var previews: some View {
        CircleViewFinal()
    }
}
