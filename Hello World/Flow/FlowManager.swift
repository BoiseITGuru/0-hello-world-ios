//
//  FlowManager.swift
//  Hello World
//
//  Created by BoiseITGuru on 7/4/23.
//

import FCL
import Flow
import Foundation
import UIKit

let testAccount = "YOUR TEST ACCOUNT"

class FlowManager: ObservableObject {
    static let shared = FlowManager()

    @Published var pendingTx: String? = nil
    
    @Published var errorTx: String? = nil
    
    func subscribeTransaction(txId: Flow.ID) {
        Task {
            do {
                DispatchQueue.main.async {
                    self.pendingTx = txId.hex
                }
                _ = try await txId.onceSealed()
                await UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.async {
                    self.pendingTx = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.pendingTx = nil
                    self.errorTx = txId.hex
                }
            }
        }
    }

    func subscribeTransaction(txId: String) {
        let id = Flow.ID(hex: txId)
        self.subscribeTransaction(txId: id)
    }

    func setup() {
        let defaultProvider: FCL.Provider = .lilico
        let defaultNetwork: Flow.ChainID = .testnet
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: "Hello World")
        let metadata = FCL.Metadata(appName: "Hello World",
                                    appDescription: "Hello Word Demo App for Emerald Academy",
                                    appIcon: URL(string: "https://academy.ecdao.org/ea-logo.png")!,
                                    location: URL(string: "https://academy.ecdao.org/")!,
                                    accountProof: accountProof)
        fcl.config(metadata: metadata,
                   env: defaultNetwork,
                   provider: defaultProvider)

        fcl.config
            .put("0xDeployer", value: testAccount)
    }
}
