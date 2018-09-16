import XCTest
@testable import BySykkel

class BySykkelAPITests: XCTestCase {
    
    func testNetworkErrorInStations() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations").with(code: 401)

        let api = BySykkelAPI(token: "token", session: session)
        api.getStations { (result) in
            self.validate(result: result, expectedCode: 401)
            asyncExpectation.fulfill()
        }

        wait(for: [asyncExpectation], timeout: 5)
    }

    func testNetworkErrorInAvailability() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations/availability").with(code: 401)

        let api = BySykkelAPI(token: "token", session: session)
        api.getAvailability { (result) in
            self.validate(result: result, expectedCode: 401)
            asyncExpectation.fulfill()
        }

        wait(for: [asyncExpectation], timeout: 5)
    }

    func testStations() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations")
            .with(file: "Stations", type: "json")
            .with(code: 200)

        let api = BySykkelAPI(token: "token", session: session)
        api.getStations { (result) in
            if case .success(let stations) = result {
                let ids = Array(stations.keys)
                XCTAssertEqual(ids.count, 2)
                XCTAssertEqual(ids, [210, 191])
            } else {
                XCTFail("Expected results")
            }
            asyncExpectation.fulfill()
        }

        wait(for: [asyncExpectation], timeout: 5)
    }

    func testAvailability() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations/availability")
            .with(file: "Availability", type: "json")
            .with(code: 200)

        let api = BySykkelAPI(token: "token", session: session)
        api.getAvailability { (result) in
            if case .success(let availability) = result {
                XCTAssertEqual(availability.count, 2)
                XCTAssertEqual(availability.first?.id, 210)
                XCTAssertEqual(availability.last?.id, 191)
            } else {
                XCTFail("Expected results")
            }
            asyncExpectation.fulfill()
        }

        wait(for: [asyncExpectation], timeout: 5)
    }

    private func validate<T>(result: Result<T>, expectedCode: Int) {
        if case .failure(let error) = result {
            let bySykkelError = error as? BySykkelError
            if case .networkError(let status)? = bySykkelError {
                XCTAssertEqual(status, expectedCode)
            } else {
                XCTFail("Expected network error")
            }
        } else {
            XCTFail("Expected failure")
        }
    }
}
