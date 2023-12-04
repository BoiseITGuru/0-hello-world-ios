//
//  Scripts.swift
//  Hello World
//
//  Created by BoiseITGuru on 8/27/22.
//

import Foundation
import FlowComponents

enum Scripts: CadenceCode {
    case getGreeting
    
    var fileName: String {
        return "get_greeting.cdc"
    }
    
    var code: String {
        return """
        import HelloWorld from 0xDeployer

        pub fun main(): String {
          return HelloWorld.greeting
        }
        """
    }
}
