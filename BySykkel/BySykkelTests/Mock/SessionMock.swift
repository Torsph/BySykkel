import Foundation

typealias MockResponse = (data: Data?, urlResponse: URLResponse?, error: Error?)
typealias MockResponseCompletionHandler = ((Data?, URLResponse?, Error?) -> Void)?

class MockSession: URLSession {
    var mockRequests: [String: MockRequest] = [:]

    func mock(path: String = "/") -> MockRequest {
        let mock = MockRequest(path: path)
        mockRequests[path] = mock

        return mock
    }

    override func uploadTask(with request: URLRequest, from _: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        let path = request.url!.relativePath
        let mockRequest = mockRequests[path] ?? MockRequest(path: path)
        return MockUploadTest(request: request, response: mockRequest, completionHandler: completionHandler)
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let path = request.url!.relativePath
        let mockRequest = mockRequests[path] ?? MockRequest(path: path)
        return MockTask(request: request, response: mockRequest, completionHandler: completionHandler)
    }

    override func finishTasksAndInvalidate() {
    }

    override func invalidateAndCancel() {
    }
}

class MockRequest {
    var response: MockResponse?
    var data: Data?
    var urlResponse: URLResponse
    var error: Error?
    var sleep: UInt32 = 0

    init(path: String) {
        let url = URL(string: path, relativeTo: URL(string: "http://mock.me"))!
        urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    @discardableResult
    func with(file: String, type: String) -> MockRequest {
        let bundle = Bundle(for: MockRequest.self)
        let path = bundle.path(forResource: file, ofType: type)!
        let url = URL(fileURLWithPath: path)
        data = try? Data(contentsOf: url)

        assert(data != nil, "Could not find file \(file)")

        return self
    }

    @discardableResult
    func with(sleep: UInt32) -> MockRequest {
        self.sleep = sleep
        return self
    }

    @discardableResult
    func with(urlResponse: URLResponse) -> MockRequest {
        self.urlResponse = urlResponse
        return self
    }

    @discardableResult
    func with(code: Int) -> MockRequest {
        urlResponse = HTTPURLResponse(url: urlResponse.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
        return self
    }

    @discardableResult
    func with(error: Error) -> MockRequest {
        self.error = error
        return self
    }

    @discardableResult
    func with(response: MockResponse) -> MockRequest {
        self.response = response
        return self
    }
}

class MockUploadTest: URLSessionUploadTask {
    let completionHandler: MockResponseCompletionHandler
    let mockRequest: MockRequest
    var request: URLRequest

    init(request: URLRequest, response: MockRequest, completionHandler: MockResponseCompletionHandler) {
        self.completionHandler = completionHandler
        mockRequest = response
        self.request = request
    }

    override var originalRequest: URLRequest? {
        return request
    }

    override func resume() {
        sleep(mockRequest.sleep)
        completionHandler!(mockRequest.data, mockRequest.urlResponse, mockRequest.error)
    }
}

class MockTask: URLSessionDataTask {
    let mockRequest: MockRequest
    var request: URLRequest
    let completionHandler: MockResponseCompletionHandler

    init(request: URLRequest, response: MockRequest, completionHandler: MockResponseCompletionHandler) {
        self.completionHandler = completionHandler
        self.request = request
        mockRequest = response
    }

    override var originalRequest: URLRequest? {
        return request
    }

    override func resume() {
        sleep(mockRequest.sleep)
        completionHandler!(mockRequest.data, mockRequest.urlResponse, mockRequest.error)
    }
}
