//
//  ProfileView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI

public struct ProfileView: View {
    public init() {}
    public var image = UserDefaults.standard.string(forKey: "PROFILE_IMAGE") ?? ""
    public var name = UserDefaults.standard.string(forKey: "PROFILE_NAME") ?? ""
    public var job = UserDefaults.standard.string(forKey: "PROFILE_JOB") ?? ""
    public var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(Circle())

            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
        }
        .padding()
        .navigationTitle("Profile")
    }
}
