//
//  HelloWorldView.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI
import FCL
import Flow

struct HelloWorldView: View {
    @State var greetingDisplay = ""
    @State var greetingText = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                Image("ea-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                Text("Emerald Academy")
                    .font(.title)
                    .foregroundStyle(Color.defualtAccentColor)
            }
            
            ButtonView(title: "Get Greeting", action: { Task { await getGreeting() } })
                .padding(.bottom, 4)
            
            Text(greetingDisplay)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .foregroundStyle(Color.white)
                .background(Color.secondaryAccentColor)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.defualtAccentColor, lineWidth: 3)
                )
                .padding(.bottom, 20)
            
            TextField("Change Greeting", text: $greetingText)
                .submitLabel(.send)
                .foregroundStyle(Color.white)
                .onSubmit {
                    guard greetingText.isEmpty == false else { return }
                    Task { await changeGreeting() }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.secondaryAccentColor)
                .cornerRadius(15)
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.defualtAccentColor, lineWidth: 3)
                )
                .padding(.bottom, 4)
                .onReceive(FlowManager.shared.$errorTx) { txId in
                    if (txId != nil) {
                        greetingDisplay = "Error with Tx: \(txId)"
                    }
                }
            
            ButtonView(title: "Change Greeting") {
                guard greetingText.isEmpty == false else { return }
                Task { await changeGreeting() }
            }
            
            Spacer()
            
            ButtonView(title: "Sign Out", action: { Task { try? await fcl.unauthenticate() } })
        }
    }
    
    func getGreeting() async {
        await MainActor.run {
            greetingDisplay = ""
        }
        do {
            let block = try await fcl.query {
                cadence {
                    Scripts.getGreeting.rawValue
                }

                gasLimit {
                    1000
                }
            }.decode(String.self)
            await MainActor.run {
                greetingDisplay = block 
            }
        } catch {
            // TODO: Improve Error Handling
            await MainActor.run {
                greetingDisplay = error.localizedDescription
            }
        }
    }
    
    func changeGreeting() async {
        do {
            let txId = try await fcl.mutate(cadence: Transactions.changeGreeting.rawValue, args: [.string(greetingText)])
            await MainActor.run {
                self.greetingText = ""
            }
            FlowManager.shared.subscribeTransaction(txId: txId)
        } catch {
            // TODO: Improve Error Handling
            await MainActor.run {
                greetingDisplay = error.localizedDescription
            }
        }
    }
}
