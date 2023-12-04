//
//  HelloWorldView.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI
import FCL
import Flow
import FlowComponents
import ecDAO

struct HelloWorldView: View {
    @Environment(FlowManager.self) private var flowManager
    
    @State var codeConfig: CodeViewConfig?
    @State var greetingDisplay = ""
    @State var showGreetingAlert = false
    @State var greetingText = ""
    
    var body: some View {
        VStack {
            AcademyHeader()
            
            getGreetingView
            
            changeGreetingView
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: .constant(codeConfig != nil), onDismiss: { codeConfig = nil }) {
            if let config = codeConfig {
                CodeSheet(config: .constant(config))
            }
        }
    }
    
    var getGreetingView: some View {
        GroupBox(label: Text("1. Read Your Greeting")) {
            VStack {
                Text("Run a script to read your greeting from the Flow Blockchain.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)

                
                Button(action: {
                    self.codeConfig = CodeViewConfig(title: "getGreeting Script", description: "This is the FCL code that runs a script to read your greeting from the Flow Blockchain.", swiftCode: SwiftCode.getGreeting, cadenceCode: Scripts.getGreeting)
                }, label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .font(.body)
                        Text("View Script")
                    }
                })
                .foregroundStyle(Color.eaPrimary)
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 3)
                
                ButtonView(title: "Get Greeting") {
                    Task {
                        await getGreeting()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .alert("Current Greeting", isPresented: $showGreetingAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(greetingDisplay)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    var changeGreetingView: some View {
        GroupBox(label: Text("2. Change Your Greeting")) {
            VStack {
                Text("Insert a new greeting in the TextField below, then execute the transaction to save your new message on the Flow Blockchain.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                TextField("Greeting Text", text: $greetingText)
                    .padding(3)
                    .border(Color.eaPrimary)
                    .padding(.bottom, 10)

                
                Button(action: {
                    self.codeConfig = CodeViewConfig(title: "changeGreeting Transaction", description: "This is the FCL code that runs a transaction to change your greeting on the Flow Blockchain.", swiftCode: SwiftCode.changeGreeting, cadenceCode: Transactions.changeGreeting)
                }, label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .font(.body)
                        Text("View Transaction")
                    }
                })
                .foregroundStyle(Color.eaPrimary)
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 3)
                
                ButtonView(title: "Change Greeting") {
                    Task {
                        await changeGreeting()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
        }
    }
    
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
            flowManager.txError = error.localizedDescription
        }
    }
    
    func changeGreeting() async {
        await flowManager.mutate(cadence: Transactions.changeGreeting.code, args: [.string(greetingText)])
        await MainActor.run {
            self.greetingText = ""
        }
    }
}
