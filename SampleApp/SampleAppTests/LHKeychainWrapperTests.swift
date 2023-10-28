import XCTest
@testable import LHKeychainWrapper

final class LHKeychainWrapperTests: XCTestCase {
    // MARK: Properties
    private let sut = LHKeychainWrapper()
    private let testKey = "testKey"

    // MARK: Setup
    override func setUp() {
        super.setUp()
        sut.delete("testKey")
    }

    override func tearDown() {
        super.tearDown()
        sut.delete("testKey")
    }

    // MARK: Tests
    func testSetString() {
        // Given
        let value = "test_value"

        // When
        sut.setString(value, forkey: testKey)

        // Then
        XCTAssertEqual(sut.string(forkey: testKey), value)
    }

    func testSetInt() {
        // Given
        let value = 250

        // When
        sut.setInt(value, forkey: testKey)

        // Then
        XCTAssertEqual(sut.int(forkey: testKey), value)
    }

    func testSetBool() {
        // Given
        let value = true

        // When
        sut.setBool(value, forkey: testKey)

        // Then
        XCTAssertEqual(sut.bool(forkey: testKey), value)
    }

    func testSetObject() {
        // Given
        let value = FakeObject(id: 20, decription: "desc")

        // When
        sut.setObject(value, forKey: testKey)

        // Then
        XCTAssertEqual(sut.object(for: testKey), value)
    }

    func testAppendObjectWithInitialValue() {
        // Given
        let initialValue = ["val_1", "val_2", "val_3"]
        let expectedResult = ["val_1", "val_2", "val_3", "val_4", "val_5"]

        // When
        sut.setObject(initialValue, forKey: testKey)
        sut.appendObject("val_4", forKey: testKey)
        sut.appendObject("val_5", forKey: testKey)

        // Then
        XCTAssertEqual(sut.object(for: testKey), expectedResult)
    }

    func testAppendObjectWithNoInitialValue() {
        // When
        sut.appendObject("val_4", forKey: testKey)
        sut.appendObject("val_5", forKey: testKey)

        // Then
        XCTAssertEqual(sut.object(for: testKey), ["val_4", "val_5"])
    }

    func test_setObject_shouldSaveCollection() {
        // Given
        let value = ["val1", "val2", "val3"]

        // When
        sut.setObject(value, forKey: testKey)

        // Then
        XCTAssertEqual(sut.object(for: testKey), value)
    }

    func test_setObject_shouldReplaceNewValue() {
        // Given
        let initialValue = "test_value"
        let expectedValue = "test_value_2"

        // When
        sut.setString(initialValue, forkey: testKey)
        sut.setString(expectedValue, forkey: testKey)

        // Then
        XCTAssertEqual(sut.string(forkey: testKey), expectedValue)
    }

    func testDeleteObject() {
        // Given
        let value = FakeObject(id: 20, decription: "desc")

        // When
        sut.setObject(value, forKey: testKey)
        sut.delete(testKey)
        let fetchedValue: FakeObject? = sut.object(for: testKey)

        // Then
        XCTAssertNil(fetchedValue)
    }

    func test_bool_shouldReturnFalseForNilValue() {
        XCTAssertFalse(sut.bool(forkey: testKey))
    }
}

struct FakeObject: Codable, Equatable {
    let id: Int
    let decription: String
}
