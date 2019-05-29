//
//  ListCell.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    static let cellIdentifier = "Cell"
    let favorite = UIImage(named: "favorite")
    let notFavorite = UIImage(named: "notFavorite")

    @IBOutlet weak var tumbnailImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteContainerView: UIView!
    
    var delegate: ListViewModelDelegate?
    var index: Int!

    func configure(item: Product, index: Int, delegate: ListViewModelDelegate?) {
        self.index = index
        self.delegate = delegate
        
        productName.text = item.name
        priceLabel.text = "$" + String(item.price / 100.0)
        
        //add toggle tapgesture to favorite image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteContainerView.addGestureRecognizer(tapGesture)
        
        //set favorite image
        if let isFavorite = item.isFavorite {
            favoriteImage.image = isFavorite ? favorite : notFavorite
        }else {
            let isFavorite = delegate?.loadFavorite(index: index) ?? false
            favoriteImage.image = isFavorite ? favorite : notFavorite
        }
        
        
        //set tumbnail image
        if let image = item.tumbnailImage {
            self.tumbnailImage.image = image
        }else {
            delegate?.loadTumbnailImage(index: index, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.tumbnailImage.image = image
                }
            })
        }
    }
    
    @objc func toggleFavorite() {
        if let toggleImage = delegate?.toggleFavorite(index: index) {
            favoriteImage.image = toggleImage ? favorite : notFavorite
        }        
    }
}
