//
//  RouterView.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI
import FCL

struct RouterView: View {
    @State var loggedIn: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                if !loggedIn {
                    SignInView()
                } else {
                    HelloWorldView()
                }
            }
            .padding(.horizontal, 20)
            
            if (FlowManager.shared.pendingTx != nil) {
                WaitingView(label: "Processing Transaction")
            }
        }
        .onReceive(fcl.$currentUser) { user in
            self.loggedIn = (user != nil)
        }
    }
}
