//
//  File.swift
//  
//
//  Created by Marcus Arnett on 8/14/23.
//

import Foundation
import XCTest
@testable import SuiKit

final class DynamicFieldsTest: XCTestCase {
    var toolBox: TestToolbox?
    var packageId: String?
    var parentObjectId: String?

    override func setUp() async throws {
        self.toolBox = try await TestToolbox(true)
        self.packageId = try await self.fetchToolBox().publishPackage("dynamic-fields").packageId

        let ownedObjects = try await self.fetchToolBox()
            .client.getOwnedObjects(
                owner: try self.fetchToolBox().account.publicKey.toSuiAddress(),
                filter: SuiObjectDataFilter.StructType(
                    "\(try self.fetchPackageId())::dynamic_fields_test::Test"
                ),
                options: SuiObjectDataOptions(showType: true)
            )
        self.parentObjectId = ownedObjects.data[0].data!.objectId
    }

    private func fetchToolBox() throws -> TestToolbox {
        guard let toolBox = self.toolBox else {
            XCTFail("Failed to get Toolbox")
            throw NSError(domain: "Failed to get Toolbox", code: -1)
        }
        return toolBox
    }

    private func fetchPackageId() throws -> String {
        guard let packageId = self.packageId else {
            XCTFail("Failed to get Package ID")
            throw NSError(domain: "Failed to get Package ID", code: -1)
        }
        return packageId
    }

    private func fetchParentObjectId() throws -> String {
        guard let parentObjectId = self.parentObjectId else {
            XCTFail("Failed to get Parent Object ID")
            throw NSError(domain: "Failed to get Parent Object ID", code: -1)
        }
        return parentObjectId
    }

    func testThatMakesSureWeGetAllOfTheDynamicFields() async throws {
        let toolBox = try self.fetchToolBox()
        let dynamicFields = try await toolBox.client.getDynamicFields(parentId: try self.fetchParentObjectId())
        XCTAssertEqual(dynamicFields.data.count, 2)
    }

    func testThatLimitingResponseInPagesWorksAsIntended() async throws {
        let toolBox = try self.fetchToolBox()
        let dynamicFields = try await toolBox.client.getDynamicFields(parentId: try self.fetchParentObjectId(), filter: nil, options: nil, limit: 1)
        XCTAssertEqual(dynamicFields.data.count, 1)
        XCTAssertNotNil(dynamicFields.nextCursor)
    }

    func testThatGoingToTheNextCursorWorksAsIntended() async throws {
        let toolBox = try self.fetchToolBox()
        let dynamicFields = try await toolBox.client.getDynamicFields(parentId: try self.fetchParentObjectId(), filter: nil, options: nil, limit: 1)
        XCTAssertNotNil(dynamicFields.nextCursor)

        let dynamicFieldCursor = try await toolBox.client.getDynamicFields(
            parentId: try self.fetchParentObjectId(), filter: nil, options: nil, limit: nil, cursor: dynamicFields.nextCursor
        )
        XCTAssertGreaterThan(dynamicFieldCursor.data.count, 0)
    }

    func testThatGettingDynamicObjectFieldWorksAsIntended() async throws {
        let toolBox = try self.fetchToolBox()
        let dynamicFields = try await toolBox.client.getDynamicFields(parentId: try self.fetchParentObjectId())

        for field in dynamicFields.data {
            let objectName = field.name

            let object = try await toolBox.client.getDynamicFieldObject(parentId: try self.fetchParentObjectId(), name: objectName)
            XCTAssertEqual(object!.data!.objectId, field.objectId)
        }
    }
}