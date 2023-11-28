//
//  ContentView.swift
//  InAppPurchase
//
//  Created by MAC on 27/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var scale = 1.0
    
    var body: some View {
        Text("Animated Text")
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                  scale = 3
                }
         }
        

    }
}

#Preview {
    ContentView()
}
