//
//  ButtonView.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title2)
                .foregroundColor(.defaultTextColor)
        }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.defualtAccentColor)
            .cornerRadius(15)
            .buttonStyle(PlainButtonStyle())
    }
}
