import XCTest
@testable import YSwiftTool

final class YSwiftToolTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(YSwiftTool().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}