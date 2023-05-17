//
//  ContentView.swift
//  XPCInterpose
//
//  Created by Spotlight Deveaux on 2023-05-15.
//

import Frida
import SwiftUI

struct ContentView: View {
    let manager = FridaManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                try await manager.testing()
            } catch let e {
                print("Encountered error: \(e)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
