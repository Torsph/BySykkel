import XCTest
@testable import BySykkel

class BySykkelViewModelTests: XCTestCase {

    func testShouldCallDidFailOnError() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations").with(code: 401)
        session.mock(path: "/api/v1/stations/availability").with(code: 401)
        let api = BySykkelAPI(token: "token", session: session)

        let delegate = BySykkelSpyDelegate()
        delegate.asyncExpectation = asyncExpectation

        let vm = BySykkelViewModel(api: api)
        vm.delegate = delegate

        vm.viewDidLoad()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertNotNil(delegate.error)
        }
    }

    func testShouldCallDidFailOnErrorIfSecondCallFails() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations")
            .with(file: "Stations", type: "json")
            .with(code: 200)
        session.mock(path: "/api/v1/stations/availability").with(code: 401)
        let api = BySykkelAPI(token: "token", session: session)

        let delegate = BySykkelSpyDelegate()
        delegate.asyncExpectation = asyncExpectation

        let vm = BySykkelViewModel(api: api)
        vm.delegate = delegate

        vm.viewDidLoad()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertNotNil(delegate.error)
        }
    }

    func testShouldCallDidLoadOnSuccess() {
        let asyncExpectation = expectation(description: "testFailure")

        let session = MockSession()
        session.mock(path: "/api/v1/stations")
            .with(file: "Stations", type: "json")
            .with(code: 200)
        session.mock(path: "/api/v1/stations/availability")
            .with(file: "Availability", type: "json")
            .with(code: 200)
        let api = BySykkelAPI(token: "token", session: session)

        let delegate = BySykkelSpyDelegate()
        delegate.asyncExpectation = asyncExpectation

        let vm = BySykkelViewModel(api: api)
        vm.delegate = delegate

        vm.viewDidLoad()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertNil(delegate.error)
            let stations = vm.stations.precondition()
            XCTAssertEqual(stations.count, 2)

            let firstStations = stations.first.precondition()
            let secondStation = stations.last.precondition()
            XCTAssertEqual(firstStations.id, 191)
            XCTAssertEqual(secondStation.id, 210)
            XCTAssertNotNil(firstStations.availability)
            XCTAssertNotNil(secondStation.availability)
        }
    }
}

class BySykkelSpyDelegate: BySykkelViewModelDelegate {
    var asyncExpectation: XCTestExpectation?
    var error: Error?

    func didLoad() {
        guard let expectation = asyncExpectation else {
            XCTFail("SpyTracking was not setup correctly. Missing XCTExpectation reference")
            return
        }

        expectation.fulfill()
    }

    func didFail(with error: Error) {
        guard let expectation = asyncExpectation else {
            XCTFail("SpyTracking was not setup correctly. Missing XCTExpectation reference")
            return
        }

        self.error = error
        expectation.fulfill()
    }
}
