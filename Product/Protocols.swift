//
//  Protocols.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

//MARK: Load image service and its default implementaion
protocol LoadImageService {
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void)
}
extension LoadImageService {
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: urlString)
                else { completion(nil); return }
            
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                completion(image)
            }catch let error {
                fatalError(error.localizedDescription)
            }
        }
    }
}




struct FavoriteStruct: Codable {
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case isFavorite
    }
}

protocol FavoriteService {
    func saveFavorite(id: String, isFavorite: Bool)
    func loadFavorite(id: String) -> Bool
    func getFileURLWithPath(id: String) throws -> URL
}

extension FavoriteService {
    func getFileURLWithPath(id: String) throws -> URL {
        //get working directory URL, create "Product" directory if not exist
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Product", isDirectory: true)
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        
        //Get fileURLWithPath relative to directoryURL
        let fileURLWithPath = URL(fileURLWithPath: id, relativeTo: directoryURL)
            .appendingPathExtension("json")
        return fileURLWithPath
    }
    
    func saveFavorite(id: String, isFavorite: Bool) {
        do {
            let fileURLWithPath = try getFileURLWithPath(id: id)
            let favorite = FavoriteStruct(isFavorite: isFavorite)
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorite)
            try data.write(to: fileURLWithPath, options: .atomic)
            
        }catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadFavorite(id: String) -> Bool {
        do {
            let fileURLWithPath = try getFileURLWithPath(id: id)
            if FileManager.default.fileExists(atPath: fileURLWithPath.path) {
                let data = try Data(contentsOf: fileURLWithPath)
                let decoder = JSONDecoder()
                let favorite = try decoder.decode(FavoriteStruct.self, from: data)
                return favorite.isFavorite
                
            }else {
                return false
            }

        }catch {
            fatalError(error.localizedDescription)
        }
    }
}


