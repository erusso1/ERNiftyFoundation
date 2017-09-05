# ERNiftyFoundation

[![CI Status](http://img.shields.io/travis/erusso1/ERNiftyFoundation.svg?style=flat)](https://travis-ci.org/erusso1/ERNiftyFoundation)
[![Version](https://img.shields.io/cocoapods/v/ERNiftyFoundation.svg?style=flat)](http://cocoapods.org/pods/ERNiftyFoundation)
[![License](https://img.shields.io/cocoapods/l/ERNiftyFoundation.svg?style=flat)](http://cocoapods.org/pods/ERNiftyFoundation)
[![Platform](https://img.shields.io/cocoapods/p/ERNiftyFoundation.svg?style=flat)](http://cocoapods.org/pods/ERNiftyFoundation)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ERNiftyFoundation is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ERNiftyFoundation"
```

## About

After developing a few apps, you tend to notice recurring themes in each project. We try our best to copy and share foundational code between projects and sometimes find ourselves re-integrating our favorite pods. ERNiftyFoundation aims to be the single pod you'll need to start off with everything you need to build a beatiful modern iOS app. 

## Dependencies Added

- [x] [Alamofire](https://github.com/Alamofire/Alamofire) - Best HTTP networking there is
- [x] [ERNiftyExtensions](https://github.com/erusso1/ERNiftyExtensions) - Plenty of extensions on Foundation classes to make life easier
- [x] [Kingfisher](https://github.com/onevcat/Kingfisher) - Amazing async image downloader and extensions for UIImageView
- [x] [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) - Goregeous and customizable activity indicators
- [x] [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) - Elegant and simple toolkit to handle phone numbers 
- [x] [Starscream](https://github.com/daltoniam/Starscream) - Web socket client 
- [x] [Unbox](https://github.com/JohnSundell/Unbox) - My favorite JSON to model object decoder; try/catch + generics = awesome!
- [x] [Wrap](https://github.com/JohnSundell/Wrap) - An amazing automatic model to JSON encoder without key/value mapping

## Features

- [x] Adds the most easy to use pods out of the box
- [x] Super easy to use RESTful API manager wrapped around Alamofire
- [x] Token authentication
- [x] Websocket connectivity and customization API using Starscream
- [x] Apple Push Notification setup and handlers.
- [x] Tons of handy Foundation extensions

## Usage

### Getting Started

In your AppDelegate, let's setup the networking layer. First we create some ERAPIEnvironment objects to represent our development and production environment. Then we configure the ERAPIManager with the environments. For DEBUG builds (iOS simulator and devices running via Xcode), ERAPIManager will use the development environment URLs for networks requests. For RELEASE builds (Test Flight, App Store) ERAPIManager will use the production environement.


```swift
import ERNiftyFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      // Create a dev environment.
      let development = ERAPIEnvironment(
        type: .development,
        apiURL: "https://dev.myapi.mydomain.com/v1/",
        webSocketURL: "ws://dev.myapi.mydomain.com/ws"
      )
      
      // Create a prod environment.
      let production = ERAPIEnvironment(
        type: .development,
        apiURL: "https://prod.myapi.mydomain.com/v1/",
        webSocketURL: "ws://prod.myapi.mydomain.com/ws"
      )
      
      // Configure the manager.
      ERAPIManager.configureFor(development: development, production: production)
      
      return true
    }
}
```


If you wish to use `localhost:8080` while in the development environment, you can use the optional boolean parameter:



```swift
ERAPIManager.configureFor(development: development, production: production, usesLocalHost: true)
```

### Models

Great. Now lets make a model, such as `User.swift`. Simply conform to the `ERModelType` protocol, and implement the following requirements:

1. Must have a String id property.
2. Must be a class.
3. Must implement `init(unboxer: Unboxer)`

```swift
import ERNiftyFoundation
import Unbox
import Wrap

public final class User: ERModelType {
  
  public let id: String

  public let fullName: String
  
  init(id: String, fullName: String) {
    self.id = id
    self.fullName = fullName
  }
  
  public convenience init(unboxer: Unboxer) throws {
    
    let id: String = try unboxer.unbox(key: "id")
    
    let fullName: String = try unboxer.unbox(key: "full_name")
    
    self.init(id: id, fullName: fullName)
  }
}
```


Encoding and decoding has never been easier thanks to `ERModalType`: 


```Swift
let user = try? User(JSON: someJSON)

let someJSON = user.JSON
```


Under the hood, `ERModelType` conforms to `class`, `Equatable`, `Unboxable`, and `WrapCustomizable`. This means our models are always classes, equatable, and JSON encodable/decodable.

Here's a handly variable `wrapKeyStyle` we can override thanks to `WrapCustomizable` to make the JSON encoder use camel case for all properties : 

```Swift
extension User {
  public var wrapKeyStyle: WrapKeyStyle { return .convertToSnakeCase }
}
```


### Endpoints

ERNiftyFoundation supplies a convenient way of building your API endpoints. First, lets make a simple endpoint object using `ERAPIManager.endpoint(components: String...)`:

```Swift
let endpoint = ERAPIManager.endpoint(components: "users", "23foh34gfoiherglkjsneflibweg")
```

Effectively, this object represents the endpoint `http://<base>/users/23foh34gfoiherglkjsneflibweg` where the base components is derrived from the APIManager's current environment's `apiURL` property.

You can pass strings as components, or use the handy `ERAPIPathComponent` struct. This makes constructing endpoints even easier, especially when using the `.id(String)` static variable. Either way is ok since it conforms to `ExpressibleByStringLiteral` protocol:

```Swift
extension ERAPIPathComponent {
  public static var users: ERAPIPathComponent { return "users" }
}
```

```Swift
let endpoint = ERAPIManager.endpoint(components: .users, .id("23foh34gfoiherglkjsneflibweg"))
```


### Requests


Now its time to make a request:

```Swift
func getUser(withId idValue: String) {
    
    let endpoint = ERAPIManager.endpoint(components: .users, .id(idValue))
    
    ERAPIManager.request(on: endpoint) { (user: User?, error) in
      
      guard let user = user else { print(error); return }
      
      print("Here is the user - ID: \(user.id)  Full name: \(user.fullName)")
    }
  }
```


Requests have the same look and feel as Alamofire requests, but use the power of Generics and `ERModalType` to automatically decode response JSON into your models.

```Swift
func getAllUsers() {
    
    let endpoint = ERAPIManager.endpoint(components: .users)
    
    ERAPIManager.request(on: endpoint) { (users: [User]?, error) in
      
      guard let users = users else { print(error); return }

      for user in users {
        print("Here is a user - ID: \(user.id)  Full name: \(user.fullName)")
      }
    }
  }
```


You can even use the `JSONObject` typealias for `[String:Any]` provided by ERNiftyFoundation:


```Swift
func getAllUsers() {
    
    let endpoint = ERAPIManager.endpoint(components: .users)
    
    ERAPIManager.request(on: endpoint) { (users: [JSONObject]?, error) in
      
      guard let users = users else { print(error); return }

      for user in users {
        print("Here is a user JSON: \(user) ")
      }
    }
  }
```


### Web Sockets

ERNiftyFoundation provides not only an APIManager, but also a SocketManager, so you dont have to worry about maintaining connection, threadding, and timers. It will even handle Application lifetime events such as entering background/foreground to connect and reconnect. It's a simple as using the following two lines whenever you wish:

```Swift
ERSocketManager.shared.connect()
```

```Swift
ERSocketManager.shared.disconnect()
```

The connection URL will be taken from the ERAPIManager's current environemnt's webSocketURL. 



### Push Notifications


Every great app informs its users why they should return or ever better, what they're missing out on. ERNiftyFoundation supplies a manager to do just that. When your user has successfully authenticated with your API, it's a good place to setup the APN manager:



```Swift
ERAPNManager.shared.setup(options: [.badge, .alert, .sound]) { error in
        print("Something went wrong: \(error)")       
}
```


This simple yet effective function requests an APN token from the device, and if it obtains one call the completion handler without error. If not, the APNManager will automatically display a popup informing the user that Push Notifications are disabled and they must allow this in the Settings Application.

### Misc


ERNiftyFoundation also provides handy items such as `ERDevice` to know exactly what device you're running on, `ERTargetMode` to know if you're running on iOS simulator, real device, DEBUG, or RELEASE.


## Author

erusso1, ephraim.s.russo@gmail.com

## License

ERNiftyFoundation is available under the MIT license. See the LICENSE file for more info.
