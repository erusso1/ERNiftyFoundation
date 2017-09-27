//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import ERNiftyFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension ERAPIPathComponent {
    
    public static var info: ERAPIPathComponent { return "info" }
    
    public static var posts: ERAPIPathComponent { return "posts" }
}

func configureAPIManger() {
   
    guard let development = try? ERAPIEnvironment(apiURL: "https://afternoon-coast-37174.herokuapp.com", webSocketURL: "ws://afternoon-coast-37174.herokuapp.com/ws") else {return}
    
    ERAPIManager.configureFor(environment: development)
}

func testAPI() {
    
    let endpoint = ERAPIEndpoint(components: .info)
    
    ERAPIManager.request(on: endpoint) { (response: String?, error: Error?) in
        
        print(response ?? "No response :/")
    }
}

func getPosts() {
    
    let endpoint = ERAPIEndpoint(components: .posts)

    ERAPIManager.request(on: endpoint) { (posts: [JSONObject]?, error: Error?) in
        
        print(posts ?? "No response :/")
    }
}

configureAPIManger()
testAPI()
getPosts()






