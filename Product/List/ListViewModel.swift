//
//  ListViewModel.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit


protocol ListViewModelDelegate: LoadImageService {
    func loadTumbnailImage(index: Int, completion: @escaping (UIImage?) -> Void)
    func loadFavorite(index: Int) -> Bool
    func toggleFavorite(index: Int) -> Bool
}


class ListViewModel: NSObject {
    var items: [Product]
    var favoriteItems: [Product] {
        return items.filter{ ($0.isFavorite ?? false) == true }
    }
    var count: Int {
        return selectedSegmentIndex == 0 ? items.count : favoriteItems.count
    }
    var productService: ProductService
    var selectedSegmentIndex: Int = 0
    
    init(items: [Product], productService: ProductService) {
        self.items = items
        self.productService = productService
    }
    

    subscript(index: Int) -> Product {
        return selectedSegmentIndex == 0 ? items[index] : favoriteItems[index]
    }
    
    func loadData(completion: @escaping() -> Void) {
        productService.loadData { [weak self] (items) in
            self?.items = items
            completion()
        }
    }

}

extension ListViewModel: ListViewModelDelegate {

    func loadTumbnailImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        loadImage(urlString: items[index].thumbnailUrlString) { [weak self] (image) in
            self?.items[index].tumbnailImage = image
            completion(image)
        }
    }
    
    func loadFavorite(index: Int) -> Bool {
        let isFavorite = items[index].loadFavorite()
        items[index].isFavorite = isFavorite
        return isFavorite
    }
    
    func toggleFavorite(index: Int) -> Bool {
        let toggleFavorite = !(items[index].isFavorite ?? false)
        items[index].isFavorite = toggleFavorite
        items[index].saveFavorite()
        return toggleFavorite
    }
}
