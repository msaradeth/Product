//
//  ProductService.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire

//"id": "e46567ab82044e528b810850bdeb9228",
//"name": "mango",
//"description": "Ripe mango with hints of tropical fruit.",
//"price": 299,
//"thumbnail_url": "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/images/mango_thumbnail.png",
//"image_url": "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/images/mango_hires.png"


class ProductService: NSObject {
    let urlString = "https://s3.us-east-2.amazonaws.com/juul-coding-challenge/products.json"
    
    struct PodsService: Codable {
        var products: [Product]
        
        enum CodingKeys: String, CodingKey {
            case products = "pods"
        }
    }
    
    func loadData(completion: @escaping ([Product]) -> Void) {
        loadDataWithURLSession(completion: completion)
    }
    
    
    
    func loadDataWithURLSession(completion: @escaping ([Product]) -> Void) {
        guard let url = URL(string: urlString) else { completion([]); return }
        
        //Get URLSession instance and query server with URL
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse else { completion([]); return }
            do {
                let decoder = JSONDecoder()
                let pods = try decoder.decode(PodsService.self, from: data)
                completion(pods.products)
            }catch let error {
                fatalError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    func loadDataWithAlamofire(completion: @escaping ([Product]) -> Void) {
        HttpHelp.request(urlString, method: .get, params: nil, success: { (dataResponse) in
            do {
                let decoder = JSONDecoder()
                let pods = try decoder.decode(PodsService.self, from: dataResponse.data!)
                completion(pods.products)
            }catch let error {
                fatalError(error.localizedDescription)
            }
            
        }) { (error) in
            fatalError(error.localizedDescription)
        }
    }
}
    
    
    
//    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
//        // 1
//        dataTask?.cancel()
//        // 2
//        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
//            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
//            // 3
//            guard let url = urlComponents.url else { return }
//            // 4
//            dataTask = defaultSession.dataTask(with: url) { data, response, error in
//                defer { self.dataTask = nil }
//                // 5
//                if let error = error {
//                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
//                } else if let data = data,
//                    let response = response as? HTTPURLResponse,
//                    response.statusCode == 200 {
//                    self.updateSearchResults(data)
//                    // 6
//                    DispatchQueue.main.async {
//                        completion(self.tracks, self.errorMessage)
//                    }
//                }
//            }
//            // 7
//            dataTask?.resume()
//        }
//    }




