//
//  Product.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit


struct Product: Codable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var thumbnailUrlString: String
    var imageUrlString: String
    
    var tumbnailImage: UIImage?
    var image: UIImage?
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case thumbnailUrlString = "thumbnail_url"
        case imageUrlString = "image_url"
    }
}


extension Product: FavoriteService {
    func saveFavorite() {
        saveFavorite(id: id, isFavorite: (isFavorite ?? false))
    }

    func loadFavorite() -> Bool {
        return loadFavorite(id: id)
    }
}

