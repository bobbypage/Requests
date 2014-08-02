#Requests.swift
> Requests is the easiest way to make HTTP requests from Swift.

![logo](http://i.imgur.com/EL2tktf.png)

```swift
Requests.get("http://example.com/json", completion: {(response, error, data) in
    //data is automatically detected & decoded as JSON and is ready to use
    let json = data as Dictionary<String, AnyObject>
    })
```

Requests is small and easy to get your head around at only ~250 LOC. Here's some of the things it can do:

- HTTP GET/POST/PUT/DELETE Requests
- Automatic decoding for common request formats including JSON, Images, and Text
- Easy POSTing with automatic headers & JSON/Form Serialization
- Base API Support
- Additional HTTP Headers Support
- Automatic URL Query Parameter builder


Here are some examples:

##GET
```swift
Requests.get("http://example.com", params: ["lang":"swift", "name": "john"], completion: {(response, error, data) in
    if (response.statusCode == 200 && !error) {
        
        //Requests.Swift automatically decodes JSON, Images, and Text depending on the Content-Type
    
        //if you requested json just cast data to a Dictionary
        let json = data as Dictionary<String, AnyObject>
        // or String if you requested some text like HTML
        let text = data as String
        // and images work too
        let image = data as UIImage
        
        // no manual decoding required, it's all handled for you!
        
        //note: if you requested something other than JSON, Text, or Images, you will be passed the raw NSData
    }
    })
```
##POST
```swift
//by default params passed to a POST, PUT, or DELETE will be serialized to JSON
//if you need to send a http url encoded form just set  Requests.sharedInstance.paramsEncoding = Requests.ParamsEncoding.FormURL

Requests.post("http://example.com", params:["name": "john"], completion: {(response, error, data) in
        println("POST Complete!")
    })
```
##PUT
```swift
//params are optional...
Requests.put("http://example.com", completion: {(response, error, data) in
        println("PUT Complete!")
    })
```

##DELETE
```swift
Requests.delete("http://example.com", completion: {(response, error, data) in
        println("DELETE Complete!")
    })
```

##Sending Parameters

Requests.swift easily allows you to send parameters as part of your requests.
HTTP GET requests params are automatically appended as part of the url, e.g. http://example.com?lang=swift&name=john
All other HTTP methods (POST, PUT, DELETE) send params as part of the body encoded in either JSON or Form Formats. JSON encoding is the default, however, the encoding can be switched by setting `Requests.sharedInstance.paramsEncoding` to either `Requests.ParamsEncoding.JSON` or `Requests.ParamsEncoding.FormURL`

If you are using Requests against a RESTful api some of the Requests.sharedInstance methods may come in handy.
```swift

//set a base path that will be used for all subsequent requests
Requests.sharedInstance.basePath = "http://api.myapp.com/"

//add a list of headers that will be added for all subsequent requests
Requests.sharedInstance.additionalHeaders = ["Authorization":"SecretAPIKey"]

//change the default parameter encoding for POST, PUT, and DELETE
//JSON
Requests.sharedInstance.paramsEncoding = Requests.ParamsEncoding.JSON
//or FormURL for application/x-www-form-urlencoded
Requests.sharedInstance.paramsEncoding = Requests.ParamsEncoding.FormURL
```

## Adding Requests.swift to your project

Incorporating Requests.swift is easy, just add the Requests.swift file to your project and you're done. Note: CocoaPods support will be added as soon as CocoaPods supports Swift.

##TODO
- add multipart form encoding support
- add file uploads, progress monitoring
- improve test coverage

##FAQ
###Why use Requests.swift opposed to X?

Requests is small and does a few things very well. It aims to be as simple and straightforward as the excellent [Python Requests Package]. If your requests are relatively simple Requests.swift is a great choice. However, if you need more control and advanced features, NSURLSession/NSURLConnection may be a better fit.

### Why doesn't Requests.swift build?
Swift is currently in beta and there are may be some issues as newer versions of Xcode are released. I'll be trying to keep this library up to date with any breaking changes.

### Requests.swift doesn't support Y...
That's not a question, but feel free to send a pull request or file an issue, and I'll be happy to look at it :-)

## Who are you?

Thanks for asking, I'm David or [@bobbypage] on twitter.

License
----

MIT

[Python Requests Package]:http://docs.python-requests.org/en/latest/
[@bobbypage]:http://twitter.com/bobbypage