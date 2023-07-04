//
//  WaitingView.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI

struct WaitingView: View {
    var label: String
    
    var body: some View {
        VStack(spacing: 5) {
            ProgressView()
            Text(label)
                .font(.title2)
                .foregroundStyle(Color.defaultTextColor)
        }
        .frame(width: 100, height: 100)
        .background(Color.defualtBackgroundColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.defualtAccentColor, lineWidth: 3)
        )
    }
}
