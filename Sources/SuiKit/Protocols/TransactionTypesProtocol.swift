//
//  File.swift
//  
//
//  Created by Marcus Arnett on 5/13/23.
//

import Foundation

public protocol TransactionTypesProtocol {
    var kind: SuiTransactionKindName { get }
}
