import XCTest
@testable import FlatNetworkClient

class FlatNetworkClientTests: XCTestCase {

    func testNoJWTNeeded() {
        
        let sut = NetworkClient(session: TestableURLSession())
        let exp = expectation(description: "Getting new JWT")
        
        let req = NSMutableURLRequest(url: URL(string: "http://test")!)
        let endPoint = TestEndPoint(URLString: "", requestBody: nil, HTTPMethod: "GET", headerFields: nil, urlRequest: req, jwtRequired: false)
        
        sut.get(endPoint, type: TestType.self) { type, _ in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
}

struct TestEndPoint: EndpointCreator {
    var URLString: String
    var requestBody: Data?
    var HTTPMethod: String
    var headerFields: [String : String]?
    var urlRequest: NSMutableURLRequest?
    var jwtRequired: Bool
}

struct TestType: JsonCreatable {

    static func createFromJSON(_ json: [AnyObject]?) -> TestType? {
            return TestType()
    }
    
    public static func decrypt(_ data: Data?) -> Data? {
        return data
    }
    
}

class TestableURLSession: URLSession {
    
    var testTask = TestableTask()
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        testTask.completion = completionHandler
        return testTask
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        testTask.completion = completionHandler
        return testTask
    }
}

class TestableTask: URLSessionDataTask {
    var completion: ((Data?, URLResponse?, Error?) -> Void)?
    var testData: Data?
    var testResponse: URLResponse?
    var testError: Error?
    
    override func resume() {
        completion?(testData, testResponse, testError)
    }
}
