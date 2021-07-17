//
//  ApiManager.swift
//  Reborn
//
//  Created by Christian Liu on 11/7/21.
//

import Foundation

class APIManager {
    public static let shared = APIManager()
    private init() {
        
    }
    
    private func prepareDataForPosting() -> [String: Any?] {
        var userData = AppEngine.shared.getUserJsonDic()!
        let region: String = InAppPurchaseManager.shared.getUserAppleIDRegion() ?? "nil"
        let setting: UserSetting = AppEngine.shared.userSetting
        let deviceInfomation: DeviceInfomation = DeviceInfomation(deviceModel: DeviceManager.getDeviceModel(), systemVersion: DeviceManager.getSystemVersion())
        var notificationTimeDicArray: [[String: Any?]] = []
        for notificationTime in setting.notificationTime {
            if let dic = encodeObjectToJSONDic(notificationTime) {
                notificationTimeDicArray.append(dic)
            }
        }
        userData.removeValue(forKey: "avatar")
        userData["setting-themeColor"] = setting.themeColor.name
        userData["setting-appAppearanceMode"] = setting.appAppearanceMode.rawValue
        userData["setting-encourageText"] = setting.encourageText
        userData["setting-notificationTime"] = notificationTimeDicArray
        userData["info-region"] = region
        userData["info-deviceModel"] = deviceInfomation.deviceModel
        userData["info-systemVersion"] = deviceInfomation.systemVersion
        return userData
    }
    
    public func postUserDataToServer() {
        
        let userData = self.prepareDataForPosting()
        let url = "http://cfdfad490c0f.ngrok.io/test/userdata"
        print("Posting user data to \(url)")
        guard let url = URL(string: url)
        else {
            print("APIManager creating URL \(url) failed")
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            print("Response from \(url): \(response)")
            guard error == nil else {
                print("APIManager creating data task failed for API \(url)")
                print(error!)
                return
            }

            guard let data = data else {
                print("APIManager created nil data for API \(url)")
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("JSON created scuccessfully")
                    print(json)
                    // handle json...
                }

            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    private func encodeObjectToString<T: Encodable>(_ object: T) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)

    }
    
    private func encodeObjectToJSONDic<T: Encodable>(_ object: T) -> [String: Any]? {
        let encoder = JSONEncoder()//PropertyListEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(object)
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    return json
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        } catch {
            print("Error encoding item array, \(error)")
            
        }
        return nil
    }
    
    private func encodeObjectToData<T: Encodable>(_ object: T) -> Data? {
        let encoder = JSONEncoder()//PropertyListEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(object)
            return data
            
        } catch {
            print("Error encoding item array, \(error)")
            
        }
        return nil
    }
    
    
}
