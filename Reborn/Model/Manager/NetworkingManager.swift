//
//  ApiManager.swift
//  Reborn
//
//  Created by Christian Liu on 11/7/21.
//

import Foundation
class NetworkingManager {
    func test() {
        
    }
}

class ServerManager {
    public static let shared = ServerManager()
    private init() {
        
    }
    
    public func update() {
        let parameters: [String: String] = ["username": "CrazyCat2", "pwd": "6252"]

        //create the url with URL
        let url = URL(string: "http://f805a213a531.ngrok.io/test/login")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                print("WTF1")
                print(error)
                return
            }

            guard let data = data else {
                print("WTF2")
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("YES!!")
                    print(json)
                    // handle json...
                }

            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    private func fetch() {
        
    }
    
    private func delete() {
        
    }
    
}
