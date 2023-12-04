//
//  SwiftCode.swift
//  Hello World
//
//  Created by BoiseITGuru on 11/30/23.
//

import Foundation
import FlowComponents

enum SwiftCode: CadenceCode {
    case getGreeting
    case changeGreeting
    
    var fileName: String {
        switch self {
        case .getGreeting:
            return "getGreeting()"
        case .changeGreeting:
            return "changeGreeting"
        }
    }
    
    var code: String {
        switch self {
        case .getGreeting:
            return """
            func getGreeting() async {
                do {
                    let block = try await fcl.query {
                        cadence {
                            Scripts.getGreeting.code
                        }

                        gasLimit {
                            1000
                        }
                    }.decode(String.self)
                    await MainActor.run {
                        greetingDisplay = block
                        showGreetingAlert.toggle()
                    }
                } catch {
                    // TODO: Improve Error Handling
                    print(error)
                }
            }
            """
        case .changeGreeting:
            return """
            func changeGreeting() async {
                do {
                    let txId = try await fcl.mutate(cadence: Transactions.changeGreeting.code, args: [.string(greetingText)])
                    await MainActor.run {
                        self.greetingText = ""
                    }
                    flowManager.subscribeTransaction(txId: txId)
                } catch {
                    // TODO: Improve Error Handling
                    print(error)
                }
            }
            """
        }
    }
}
