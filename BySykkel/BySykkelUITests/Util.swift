import XCTest

extension XCTestCase {
    func waitFor(element: XCUIElement, exists: Bool = true) {
        let exists = NSPredicate(format: "exists == \(exists)")
        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
