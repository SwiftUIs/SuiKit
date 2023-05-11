//
//  File.swift
//  
//
//  Created by Marcus Arnett on 5/3/23.
//

import Foundation

public struct Checkpoint {
    public let epoch: String
    public let sequenceNumber: String
    public let digest: CheckpointDigest
    public let networkTotalTransactions: String
    public let previousDigest: CheckpointDigest?
    public let epochRollingGasCostSummary: GasCostSummary
    public let timestampMs: String
    public let validatorSignature: ValidatorSignature?
    public let transactions: [TransactionDigest]
    public let checkpointComitments: [CheckpointComitment]
}

public typealias CheckpointDigest = String
public typealias ValidatorSignature = String
public typealias TransactionDigest = String