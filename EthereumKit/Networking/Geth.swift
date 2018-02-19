//
//  Geth.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Result

public final class Geth {
    
    private let etherClient: JSONRPCClient
    private let etherscanClient: EtherscanClient
    
    public init(network: Network) {
        etherClient = JSONRPCClient(network: network)
        etherscanClient = EtherscanClient(network: network)
    }
    
    // MARK: - JSONRPC APIs
    
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Balance, RPCError>) -> Void) {
        etherClient.send(RPC.GetBalance(address: address, blockParameter: blockParameter), handler: handler)
    }
    
    public func getAccount(address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Account, RPCError>) -> Void) {
        getBalance(of: address) { result in
            switch result {
            case .success(let balance):
                handler(.success(Account(address: address, balance: balance)))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    // MARK: - Etherscan APIs
    
    public func getTransactions(address: String, handler: @escaping (Result<Any, RPCError>) -> Void) {
        etherscanClient.send(Etherscan.GetTransactions(address: address), handler: handler)
    }
}
