//
//  Hello_WorldApp.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI

@main
struct Hello_WorldApp: App {
    
    init() {
        FlowManager.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView()
        }
    }
}
