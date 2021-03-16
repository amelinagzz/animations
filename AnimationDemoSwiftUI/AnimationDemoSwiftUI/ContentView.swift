//
//  ContentView.swift
//  AnimationDemoSwiftUI
//
//  Created by Adriana González Martínez on 3/15/21.
//

import SwiftUI

struct ContentView: View {
    @State var hidden = false
    var body: some View {
        Button("Do NOT Tap"){
            self.hidden = true
        }
        .opacity(hidden ? 0 : 1)
        .animation(.easeIn(duration: 0.8))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
