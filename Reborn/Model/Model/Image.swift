//
//  UIImage.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit

struct Image: Codable {
    
    let image: UIImage
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let base64String = try container.decode(String.self)
        let components = base64String.split(separator: ",")
        if components.count != 2 {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Wrong data format")
        }
        
        let dataString = String(components[1])
        
        if let dataDecoded = Data(base64Encoded: dataString, options: .ignoreUnknownCharacters),
            let image = UIImage(data: dataDecoded) {
            self.image = image
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Can't initialize image from data string")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = image.jpegData(compressionQuality: 1)
        let prefix = "data:image/jpeg;base64,"
        guard let base64String = data?.base64EncodedString(options: .lineLength64Characters) else {
            throw EncodingError.invalidValue(image, EncodingError.Context(codingPath: [], debugDescription: "Can't encode image to base64 string."))
        }
        
        try container.encode(prefix + base64String)
    }
}
