//
//  Hello_WorldApp.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import SwiftUI
import FCL
import Flow
import ecDAO

@main
struct Hello_WorldApp: App {
    let testAccount = "YOUR_TESTNET_ACCOUNT"
    let walletConnectID = "YOUR_WALLETCONNECT_PROJECT_ID"
    @State private var title = "Hello World"
    @State private var description = "Read and write from the Flow Blockchain for the first time!"
    
    init() {
        let defaultProvider: FCL.Provider = .devWallet
        let defaultNetwork: Flow.ChainID = .emulator
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: "Hello World")
        let walletConnect = FCL.Metadata.WalletConnectConfig(urlScheme: "helloWorld://", projectID: walletConnectID)
        let metadata = FCL.Metadata(appName: "Hello World",
                                    appDescription: "Hello Word Demo App for Emerald Academy",
                                    appIcon: URL(string: "https://academy.ecdao.org/ea-logo.png")!,
                                    location: URL(string: "https://academy.ecdao.org/")!,
                                    accountProof: accountProof, 
                                    walletConnectConfig: walletConnect)
        fcl.config(metadata: metadata,
                   env: defaultNetwork,
                   provider: defaultProvider)

        fcl.config
            .put("0xDeployer", value: fcl.currentEnv == .emulator ? "0xf8d6e0586b0a20c7" : testAccount)
        
        ecDAOinit()
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView(title: $title, desc: $description) {
                HelloWorldView()
            }
        }
    }
}
