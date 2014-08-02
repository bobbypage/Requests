//
//  ViewController.swift
//  RequestsDemo
//
//  Created by David Porter on 8/2/14.
//  Copyright (c) 2014 David Porter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func getHttpbin(sender: AnyObject) {
        Requests.get("http://httpbin.org", completion: {(response, error, data) in
            println("StatusCode: \(response.statusCode), Data: \(data)")
            });
    }
    @IBAction func getHttpbinIp(sender: AnyObject) {
        Requests.get("http://httpbin.org/ip", params: ["lang":"swift", "name":"john doe"], completion: {(response, error, data) in
            println("StatusCode: \(response.statusCode), Data: \(data)")
            });
    }
    @IBAction func postHttpbin(sender: AnyObject) {
        Requests.post("http://httpbin.org/post", params: ["lang":"swift", "name":"john doe"], completion: {(response, error, data) in
            println("StatusCode: \(response.statusCode), Data: \(data)")
            });
        
    }
    @IBAction func putHttpbin(sender: AnyObject) {
        Requests.put("http://httpbin.org/put", params: ["lang":"swift", "name":"john doe"], completion: {(response, error, data) in
            println("StatusCode: \(response.statusCode), Data: \(data)")
            });
    }
    @IBAction func deleteHttpbin(sender: AnyObject) {
        Requests.delete("http://httpbin.org/delete", params: ["lang":"swift", "name":"john doe"], completion: {(response, error, data) in
            println("StatusCode: \(response.statusCode), Data: \(data)")
            });
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

