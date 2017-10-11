# FlatNetworkClient

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/FlatNetworkClient.svg?style=flat-square)](https://cocoapods.org/pods/FlatNetworkClient) 
[![Platform support](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat-square)](https://github.com/flatCircle/FlatNetworkClient/LICENSE.md) 
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/flatCircle/FlatNetworkClient/LICENSE.md)
[![Github Releases](https://img.shields.io/github/downloads/FlatNetworkClient/FlatNetworkClient/latest/total.svg)](https://github.com/flatCircle/FlatNetworkClient/LICENSE.md) 


The FlatNetworkClient provides an easy to use, testable wrapper around URLSession

# Getting started

The FlatNetworkClient is designed to force good modular code design by creating a clear separation of concerns between the different components that make up network calls.

* Separate Endoint definition for each of the HTTP Verbs
* Central JSON initialization poin for each network model
* Extensible network interface to allow for Facade pattern wrappers


# Installation

## CocoaPods

You can install FlatNetworkClient via CocoaPods by adding it to your `Podfile`:
```
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'FlatNetworkClient'
```

And run `pod install`.

## Step 1

After installing the pod, the first step is to create a model object for your network call. This model must conform to the ***JsonCreatable*** protocol. This protocol provides you with a method that supplies JSON from the network call to allow for custom mapping if needed. 

```swift

struct Person : JsonCreatable {
    let id: String
    let name: String
    
    static func create(_ json: [String: AnyObject]?) -> Person? {
        guard let json = json, let id = json["id"] as? String, let name = json["name"] as? String else {
            return nil
        }
        
        return Person(id: id, name: name)
    }
}

```

## Step 2
Create an endpoints enum for one or all of the HTTP Verbs. The enum should implement the ***EndPointCreator*** protocol

This protocol provides optional properties for:

* URLString
* requestBody
* headerFields

### Example implementations for each of the HTTP Verbs

### GetEndPoint

```swift
enum PersonGetEndpoint: EndpointCreator {
    
    case getName(id: String)
    case getPerson(id: String)
    
    var HTTPMethod: String {
        return HTTPVerb.get.rawValue
    }
    
    
    var URLString: String {
        switch self {
        case .getName(id: let id):
            return "www.somebaseurl.com/getName?=\(id)"
        case .getPerson(id: let id):
            return "www.somebaseurl.com/getPerson?=\(id)"
        }
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var headerFields: [String : String]? {
        return [
            "X-API-KEY-TOKEN": "SOME-API-TOKEN",
            "X-AUTH-TOKEN": "SOME-AUTH-TOKEN",
        ]
    }
}
```

### PostEndPoint

```swift
enum PersonPostEndpoint: EndpointCreator {
    case updateName(id: String, name: String)
    
    var HTTPMethod: String {
        return HTTPVerb.post.rawValue
    }
    
    
    var URLString: String {
        switch self {
        case .updateName(id: let id, name: let name):
            return "www.somebaseurl.com/updateName?=\(id)-\(name)"
        }
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var headerFields: [String : String]? {
        return [
            "X-API-KEY-TOKEN": "SOME-API-TOKEN",
            "X-AUTH-TOKEN": "SOME-AUTH-TOKEN",
        ]
    }
}
```
### PutEndPoint

```swift
enum PersonPutEndpoint: EndpointCreator {
    case createPerson(id: String, name: String)
    
    var HTTPMethod: String {
        return HTTPVerb.put.rawValue
    }
    
    
    var URLString: String {
        switch self {
        case .createPerson(id: let id, name: let name):
            return "www.somebaseurl.com/createPerson?=\(id)-\(name)"
        }
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var headerFields: [String : String]? {
        return [
            "X-API-KEY-TOKEN": "SOME-API-TOKEN",
            "X-AUTH-TOKEN": "SOME-AUTH-TOKEN",
        ]
    }
}

```

### DeleteEndPoint

```swift
enum PersonDeleteEndpoint: EndpointCreator {
    case deletePerson(id: String)
    
    var HTTPMethod: String {
        return HTTPVerb.put.rawValue
    }
    
    var URLString: String {
        switch self {
        case .deletePerson(id: let id):
            return "www.somebaseurl.com/deletePerson?=\(id)"
        }
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var headerFields: [String : String]? {
        return [
            "X-API-KEY-TOKEN": "SOME-API-TOKEN",
            "X-AUTH-TOKEN": "SOME-AUTH-TOKEN",
        ]
    }
}
```

## Step 3
Subclass ***NetworkClient*** 

```swift
class PersonNetworkClient: NetworkClient {}
```

## Step 4
Implement methods for the required API Calls.

eg. GET

```swift
// GET
extension PersonNetworkClient {
    func getPerson(by id: String, completion: @escaping (Person?) -> Void) {
        get(PersonGetEndpoint.getPerson(id: id), type: Person.self) { person, _ in
            completion(person)
        }
    }
}
```


# Contributing

There's still a lot of work to do here! We would love to see you involved! 

# Get in touch

If you have any questions, you can find the core team on twitter:

- [@rohan_jansen](https://twitter.com/rohan_jansen)
- [@pantsula](https://twitter.com/pantsula)
