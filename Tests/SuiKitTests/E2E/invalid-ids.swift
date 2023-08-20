//
//  File.swift
//  
//
//  Created by Marcus Arnett on 8/17/23.
//

import Foundation
import XCTest
@testable import SuiKit

final class InvalidIdsTest: XCTestCase {
    var toolBox: TestToolbox?

    override func setUp() async throws {
        self.toolBox = try await TestToolbox(true)
    }

    private func fetchToolBox() throws -> TestToolbox {
        guard let toolBox = self.toolBox else {
            XCTFail("Failed to get Toolbox")
            throw NSError(domain: "Failed to get Toolbox", code: -1)
        }
        return toolBox
    }

    func testThatVerifiesGetOwnedObjectsThrowsWithAnInvalidSuiAddress() async throws {
        do {
            let toolBox = try self.fetchToolBox()
            let _ = try await toolBox.client.getOwnedObjects(owner: "")
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }
    }

    func testThatVariousFunctionsWillThrowWithVariousWrongAddresses() async throws {
        // Empty ID
        do {
            let toolBox = try self.fetchToolBox()
            let _ = try await toolBox.client.getObject(objectId: "")
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }

        // More than 20 Bytes
        do {
            let toolBox = try self.fetchToolBox()
            let _ = try await toolBox.client.getDynamicFields(parentId: "0x0000000000000000000000004ce52ee7b659b610d59a1ced129291b3d0d4216322")
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }

        // Wrong Batch Request (0xWRONG)
        do {
            let toolBox = try self.fetchToolBox()
            let objectIds = ["0xBABE", "0xCAFE", "0xWRONG", "0xFACE"]
            let _ = try await toolBox.client.getMultiObjects(ids: objectIds)
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }
    }

    func testThatInvalidDigestsForClientFunctionsThrowWithInvalidDigests() async throws {
        // Empty Digest
        do {
            let toolBox = try self.fetchToolBox()
            let _ = try await toolBox.client.getTransactionBlock(digest: "")
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }

        // Wrong Batch Request
        do {
            let toolBox = try self.fetchToolBox()
            let digests = ["AQ7FA8JTGs368CvMkXj2iFz2WUWwzP6AAWgsLpPLxUmr", "wrong"]
            let _ = try await toolBox.client.multiGetTransactionBlocks(digests: digests)
            XCTFail("Function did not throw")
        } catch {
            XCTAssertEqual(0, 0)
        }
    }
}
