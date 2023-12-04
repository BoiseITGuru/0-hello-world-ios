//
//  Transactions.swift
//  Hello World
//
//  Created by BoiseITGuru on 8/27/22.
//

import Foundation
import FlowComponents

enum Transactions: CadenceCode {
    case changeGreeting
    
    var fileName: String {
        return "change_greeting.cdc"
    }
    
    var code: String {
        return """
        import HelloWorld from 0xDeployer

        transaction(newGreeting: String) {
          prepare(signer: AuthAccount) {

          }

          execute {
            HelloWorld.changeGreeting(newGreeting: newGreeting)
          }
        }
        """
    }
}
