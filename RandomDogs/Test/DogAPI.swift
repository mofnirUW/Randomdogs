//
//  DogAPI.swift
//  Test
//
//  Created by U.N Owen on 2019-04-12.
//  Copyright © 2019 mofnir. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        
        case randomImageAllCollection
        case randomImageForBreed(String)
        case breedsList
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageAllCollection:
                return "https://dog.ceo/api/breeds/image/random"
            
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
             
            case .breedsList:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoint.breedsList.url) {
            (data, reponse, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
    }
   
    class func requestImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task =
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }
                let downloadedImage = UIImage(data: data)
                completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImg = DogAPI.Endpoint.randomImageForBreed(breed).url
        print(randomImg)
        let task = URLSession.shared.dataTask(with: randomImg) {
            (data, reponse, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try!
                decoder.decode(DogImage.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
            
        }
        task.resume()
    }
}
