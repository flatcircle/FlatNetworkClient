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

    
    func testExpiredJWT_RequestsNew() {
        var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtleWlkIjoiUkVRME1VUTVOME5DUlRKRU16azNNMFUxUmtORFEwVTBRME0xUkVGQlJqaERNamRFTlVGQlFnIn0.eyJpc3MiOiJodHRwczovL2ZpZG0uZ2lneWEuY29tL2p3dC8zX0s0WXBJQUVDcTNjRjFCTFppcnJ2ZVJOLTgzNWVnNXMzY3pMb1F0ZDRiMElyZmxjZ0FzREplaG8yOTZGdFRpaTgvIiwiYXBpS2V5IjoiM19LNFlwSUFFQ3EzY0YxQkxaaXJydmVSTi04MzVlZzVzM2N6TG9RdGQ0YjBJcmZsY2dBc0RKZWhvMjk2RnRUaWk4IiwiaWF0IjoxNTI1NDMzMzQyLCJleHAiOjE1NTY5OTA5NDIsInN1YiI6ImFhYTczNGE5M2EzYTRlMDU5NWU0OGVmYjRjNjdjMzAxIiwiZW1haWwiOiJBbmRyZWFzK2dpZzEyMzQ1NjdAZmxhdGNpcmNsZS5pbyJ9.K8yv-e1fbpsuBzXgrnFr0b2XYLzDucIiCsFNTUguV4vbZL9RuZ1EQXA2Y38Xu14xmqWkJcPSQjxyfO9V3DX-Oyg0K5tTvHU--3DTML42Q3gkztavqC_nyE9Smq7Y1hECT5k4WrRMRBXiF9sIwBB0UKpjOBSzDarvp8rVWB-HmUjxlQRiQ-imUEF7zARMnh1lCsmMev_O5-LGny4_wL3URa3LA8yfysXeLMUaClSczarnHdSEggmcBBUB6M2bY9SL1opwnc19KfhnJKrnBv2Cwe16DvNUBVXJAy-fJQRaJnN9UfTjHXjUk8uBVXxoH7050g6niykk4kyiFOw1ZTKfEg"
        let sut = NetworkClient(session: TestableURLSession())
        let exp = expectation(description: "Getting new JWT")
        
        sut.getJWT = {
            return token
        }
        
        sut.refreshJWT = { completion in
            token = "newToken"
            completion()
        }
        
        let req = NSMutableURLRequest(url: URL(string: "http://test")!)
        let endPoint = TestEndPoint(URLString: "", requestBody: nil, HTTPMethod: "GET", headerFields: nil, urlRequest: req, jwtRequired: true)
        
        sut.get(endPoint, type: TestType.self) { type, _ in
            XCTAssertEqual(token, "newToken")
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
