//
//  RequestsDemoTests.swift
//  RequestsDemoTests
//
//  Created by David Porter on 8/2/14.
//  Copyright (c) 2014 David Porter. All rights reserved.
//

import UIKit
import XCTest

class RequestsDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        Requests.sharedInstance.basePath = ""
        Requests.sharedInstance.additionalHeaders = [String:String]()
        Requests.sharedInstance.paramsEncoding = Requests.ParamsEncoding.JSON
        
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testHTTPGetHTML() {
        Requests.get("http://httpbin.org", completion: {(response, error, data) in
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            })
    }
    
    func testHTTPGet() {
        
        Requests.sharedInstance.additionalHeaders = ["X-Test":"Testing"]
        
        Requests.get("http://httpbin.org/get", params: ["lang":"swift", "name":"john"], completion: {(response, error, data) in
            
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            
            let json = data as? Dictionary<String, AnyObject>
            let args = json!["args"]! as Dictionary<String, AnyObject>
            var lang: AnyObject = args["lang"]!
            XCTAssertEqual(lang as String, "swift", "lang should be swift")
            
            let headers = json!["headers"]! as? Dictionary<String, AnyObject>
            var testHeaderValue: AnyObject = headers!["X-Test"]!
            XCTAssertEqual(testHeaderValue as String, "Testing", "X-Test header should be Testing")
            
            })
    }
    
    func testHTTPPostJSON() {
        
        Requests.sharedInstance.additionalHeaders = ["X-Test":"Testing"]
        
        Requests.post("http://httpbin.org/post", params: ["lang":"swift", "name":"john"], completion: {(response, error, data) in
            
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            
            let json = data as? Dictionary<String, AnyObject>
            let args = json!["json"]! as Dictionary<String, AnyObject>
            var lang: AnyObject = args["lang"]!
            XCTAssertEqual(lang as String, "swift", "lang should be swift")
            
            let headers = json!["headers"]! as? Dictionary<String, AnyObject>
            var testHeaderValue: AnyObject = headers!["X-Test"]!
            XCTAssertEqual(testHeaderValue as String, "Testing", "X-Test header should be Testing")
            
            })
    }
    
    func testHTTPPostForm() {
        
        Requests.sharedInstance.additionalHeaders = ["X-Test":"Testing"]
        Requests.sharedInstance.paramsEncoding = Requests.ParamsEncoding.FormURL
        
        Requests.post("http://httpbin.org/post", params: ["lang":"swift", "name":"john"], completion: {(response, error, data) in
            
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            
            let json = data as? Dictionary<String, AnyObject>
            let args = json!["form"]! as Dictionary<String, AnyObject>
            var lang: AnyObject = args["lang"]!
            XCTAssertEqual(lang as String, "swift", "lang should be swift")
            
            let headers = json!["headers"]! as? Dictionary<String, AnyObject>
            var testHeaderValue: AnyObject = headers!["X-Test"]!
            XCTAssertEqual(testHeaderValue as String, "Testing", "X-Test header should be Testing")
            
            })
    }
    func testHTTPPut() {
        
        Requests.sharedInstance.additionalHeaders = ["X-Test":"Testing"]
        
        Requests.put("http://httpbin.org/put", params: ["lang":"swift", "name":"john"], completion: {(response, error, data) in
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            
            let json = data as? Dictionary<String, AnyObject>
            let args = json!["json"]! as Dictionary<String, AnyObject>
            var lang: AnyObject = args["lang"]!
            XCTAssertEqual(lang as String, "swift", "lang should be swift")
            
            let headers = json!["headers"]! as? Dictionary<String, AnyObject>
            var testHeaderValue: AnyObject = headers!["X-Test"]!
            XCTAssertEqual(testHeaderValue as String, "Testing", "X-Test header should be Testing")
            
            })
        
        
    }
    func testHTTPDelete() {
        Requests.sharedInstance.additionalHeaders = ["X-Test":"Testing"]
        
        Requests.delete("http://httpbin.org/delete", params: ["lang":"swift", "name":"john"], completion: {(response, error, data) in
            XCTAssertEqual(response.statusCode, 200, "Status Code should return 200")
            
            let json = data as? Dictionary<String, AnyObject>
            let args = json!["json"]! as Dictionary<String, AnyObject>
            var lang: AnyObject = args["lang"]!
            XCTAssertEqual(lang as String, "swift", "lang should be swift")
            
            let headers = json!["headers"]! as? Dictionary<String, AnyObject>
            var testHeaderValue: AnyObject = headers!["X-Test"]!
            XCTAssertEqual(testHeaderValue as String, "Testing", "X-Test header should be Testing")
            
            })
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}