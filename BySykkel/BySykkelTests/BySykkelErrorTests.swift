import XCTest
@testable import BySykkel

class BySykkelErrorTests: XCTestCase {

    func test401ErrorDescription() {
        let error = BySykkelError.networkError(401)
        XCTAssertEqual(error.errorDescription, "Something wrong with your access token")
    }

    func testGeneric4xxDescription() {
        let error = BySykkelError.networkError(400)
        XCTAssertEqual(error.errorDescription, "Something wrong with our request")
    }

    func testGeneric5xxDescription() {
        let error = BySykkelError.networkError(500)
        XCTAssertEqual(error.errorDescription, "Something went wrong on BySykkle's backend")
    }

    func testGenericOtherCodesDescription() {
        let error = BySykkelError.networkError(123)
        XCTAssertEqual(error.errorDescription, "Something wrong with the network")
    }
}
