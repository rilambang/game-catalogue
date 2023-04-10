//
//  ContentView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var diContainer = Injection()
    var body: some View {
        ZStack {
            NavigationView {
                HomeView(homeVM: diContainer.provideHome())
            }
            .environmentObject(diContainer)
            .navigationViewStyle(.stack)
        }
        .onAppear {
            UserDefaults.standard.set("my-profile-photo", forKey: "PROFILE_IMAGE")
            UserDefaults.standard.set("Muhammad Ilham Rilambang", forKey: "PROFILE_NAME")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
