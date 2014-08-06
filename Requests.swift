//
//  Requests.swift
//  RequestsDemo
//
//  Created by David Porter on 8/2/14.
//  Copyright (c) 2014 David Porter. All rights reserved.
//

import Foundation
import UIKit

private let _SingletonASharedInstance = Requests()

class Requests {
    typealias Data = AnyObject!

    enum ParamsEncoding {
        case JSON
        case FormURL
    }
    
    //================================================================================
    // MARK: Default SharedInstance Values
    //================================================================================
    var paramsEncoding = ParamsEncoding.JSON
    var basePath = ""
    var additionalHeaders = [String:String]()
    var cachePolicy: NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    
    
    class var sharedInstance : Requests {
        return _SingletonASharedInstance
    }
    
    
    //GET
    class func get(url: String, params:[String: String]?, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("GET", url: url, params: params, completion: completion)
    }
    class func get(url: String, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("GET", url: url, params: nil, completion: completion)
    }
    
    //POST
    class func post(url: String, params:[String: String]?, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("POST", url: url, params: params, completion: completion)
    }
    class func post(url: String, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("POST", url: url, params: nil, completion: completion)
    }
    
    //PUT
    class func put(url: String, params:[String: String]?, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("PUT", url: url, params: params, completion: completion)
    }
    class func put(url: String, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("PUT", url: url, params: nil, completion: completion)
    }
    
    //DELETE
    class func delete(url: String, params:[String: String]?, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("DELETE", url: url, params: params, completion: completion)
    }
    class func delete(url: String, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        _makeRequest("DELETE", url: url, params: nil, completion: completion)
    }
    
    
    //================================================================================
    // MARK: Internal Requests
    //================================================================================
    private class func _makeRequest(method: String, url: String, params:[String: String]?, completion:(response: NSHTTPURLResponse!, error: NSError!, data: Requests.Data) -> Void) {
        
        var queryString = ""
        
        if (method == "GET" && params != nil) {
            queryString += createParamsString(params!, isURLQueryString: true)
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: Requests.sharedInstance.basePath + url + queryString))
        request.HTTPMethod = method
        request.cachePolicy = Requests.sharedInstance.cachePolicy
        
        //add headers
        for (name, value) in Requests.sharedInstance.additionalHeaders {
            request.addValue(value, forHTTPHeaderField: name)
        }
        
        
        //if get add parms to url query
        //else if post,put,delete add params to body as json or form url
        
        
        if (params != nil) {
            if (method == "POST" || method == "PUT" || method == "DELETE") {
                if (Requests.sharedInstance.paramsEncoding == ParamsEncoding.JSON) {
                    var error: NSError?
                    let jsonData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(0),error: &error)
                    
                    request.HTTPBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                }
                else if (Requests.sharedInstance.paramsEncoding == ParamsEncoding.FormURL) {
                    let formParams = createParamsString(params!, isURLQueryString: false)
                    let formData = formParams.dataUsingEncoding(NSUTF8StringEncoding)
                    request.HTTPBody = formData
                    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
            }

        }
        
        
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            
            var completionResponseData: Data = NSData()
            var completionResponse = NSHTTPURLResponse()
            
            var httpResp = response as? NSHTTPURLResponse
            
            var dataResp: Data = data as NSData
            let headers = httpResp?.allHeaderFields
            
            if (httpResp != nil) {
                completionResponse = httpResp!
            }
            
            if (headers != nil) {
                if (self.isJSON(headers!)) {
                    var error: NSError?
                    var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                    
                    if (error == nil && dict != nil) {
                        dataResp = dict
                    }
                }
                else if (self.isText(headers!)) {
                    var dataString = NSString(data: data as NSData, encoding: NSUTF8StringEncoding)
                    dataResp = dataString
                }
                else if (self.isImage(headers!)) {
                    let image = UIImage(data: data as NSData)
                    if (image != nil) {
                        dataResp = image
                    }
                }

            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(response:completionResponse, error: error, data: dataResp)
                });
            });
        
        task.resume()
    }

    //================================================================================
    // MARK: Content Type Detection
    //================================================================================
    
    
    class func doesHeaderContainContentTypes(headers: NSDictionary, contentTypes: [String]) -> Bool {
        let headersDict = headers as Dictionary
        
        var containsContentType = false
        
        for contentType in contentTypes {
            if let responseContentType = headers["Content-Type"] as? String {
                if (responseContentType.rangeOfString(contentType) != nil) {
                    containsContentType = true
                    
                }
            }
        }

        return containsContentType
        
    }
    class func isJSON(headers: NSDictionary) -> Bool {
        return doesHeaderContainContentTypes(headers, contentTypes: ["application/json"]);
    }
    class func isText(headers: NSDictionary) -> Bool {
        return doesHeaderContainContentTypes(headers, contentTypes: ["text/html",
            "text/javascript",
            "application/javascript",
            "text/plain",
            "text/rtf",
            "text/xml"]);
    }
    class func isImage(headers: NSDictionary) -> Bool {
        return doesHeaderContainContentTypes(headers, contentTypes: ["image/gif",
            "image/jpeg",
            "image/png"]);
    }
    
    //================================================================================
    // MARK: URL Query String Builder Methods
    //================================================================================
    
    class func escapeString(someString: String) -> NSString {
        
        let unencodedString = someString as NSString
        
        let s: NSString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, unencodedString as CFString, nil, "!*'();:@&=+$,/?%#[]" as CFString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return s
    }
    //http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
    
    class func createParamsString(params:[String: String], isURLQueryString:Bool) -> String {
        var queryString = ""
        
        for (key, value) in params {
            
            let escapedKey = escapeString(key)
            let escapedValue = escapeString(value)
            
            if (isURLQueryString) {
                if (queryString.rangeOfString("?") == nil) {
                    queryString += "?\(escapedKey)=\(escapedValue)"
                }
                else {
                    queryString += "&\(escapedKey)=\(escapedValue)"
                }
            }
            else {
                if (queryString == "") {
                    queryString += "\(escapedKey)=\(escapedValue)"
                }
                else {
                    queryString += "&\(escapedKey)=\(escapedValue)"
                }
            }
        }
        return queryString
    }
    
}