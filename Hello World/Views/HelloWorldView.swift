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
    @State var showCodeSheet: Bool = false
    @StateObject var codeConfig: CodeViewConfig = CodeViewConfig(title: "Title", description: "Description", swiftCode: Scripts.getGreeting, cadenceCode: Transactions.changeGreeting)
    @State var greetingDisplay = ""
    @State var showGreetingAlert = false
    @State var greetingText = ""
    
    var body: some View {
        VStack {
            AcademyHeader()
            
            getGreetingView
            
            changeGreetingView
            
            Spacer()
        }
        .sheet(isPresented: $showCodeSheet, onDismiss: { codeConfig.codeType = .swift }) {
            CodeSheet(codeType: $codeConfig.codeType, title: $codeConfig.title, description: $codeConfig.description, swiftCode: $codeConfig.swiftCode, cadenceCode: $codeConfig.cadenceCode)
        }
    }
    
    var getGreetingView: some View {
        GroupBox(label: Text("1. Read Your Greeting")) {
            VStack {
                Text("Run a script to read your greeting from the Flow Blockchain.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)

                
                Button(action: {
                    updateCodeConfig(title: "getGreeting Script", description: "This is the FCL code that runs a script to read your greeting from the Flow Blockchain.", swiftCode: SwiftCode.getGreeting, cadenceCode: Scripts.getGreeting)
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
                    updateCodeConfig(title: "changeGreeting Transaction", description: "This is the FCL code that runs a transaction to change your greeting on the Flow Blockchain.", swiftCode: SwiftCode.changeGreeting, cadenceCode: Transactions.changeGreeting)
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
            // TODO: Improve Error Handling
            print(error)
        }
    }
    
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
    
    private func updateCodeConfig(title: String, description: String, swiftCode: CadenceCode, cadenceCode: CadenceCode) {
        codeConfig.title = title
        codeConfig.description = description
        codeConfig.swiftCode = swiftCode
        codeConfig.cadenceCode = cadenceCode
            
        self.showCodeSheet = true
    }
}
