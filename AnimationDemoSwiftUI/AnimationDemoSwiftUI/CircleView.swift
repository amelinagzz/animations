//
//  CircleView.swift
//  AnimationDemoSwiftUI
//
//  Created by Adriana González Martínez on 3/15/21.
//  From https://betterprogramming.pub/2-must-know-protocols-for-swiftui-animation-cd50bf38895e

import UIKit
import SwiftUI

//Struct that conforms to Shape. All shapes in SwiftUI conform to the animatable protocol.
struct AnimatableCircle: Shape {
    var progress: CGFloat
    // The data that will animate
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    //The path that describes how the shape will be drawn
    func path(in rect: CGRect) -> Path {
        let centerX: CGFloat = rect.width / 2
        let centerY: CGFloat = rect.height / 2
        var path = Path()
        path.addArc(center: CGPoint(x: centerX, y: centerY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360 * Double(progress)),
                    clockwise: false)
        return path
    }
}

struct CircleView: View {
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .frame(width: 90, height: 90)
                .foregroundColor(Color(.systemGray6))
            
            AnimatableCircle(progress: progress)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .frame(width: 90, height: 90)
                .foregroundColor(Color(.systemIndigo))
                .animation(Animation.easeInOut.speed(0.25))
                .onAppear() {
                    self.progress = 1
                }
        }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
