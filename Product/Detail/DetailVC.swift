//
//  DetailVC.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, LoadImageService {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: Product
    var index: Int
    var delegate: UpdateImageDelegate?
    var callbackWithImageClosure: ((UIImage?) -> Void)?
    
    init(title: String, product: Product, index: Int, delegate: UpdateImageDelegate?) {
        self.product = product
        self.index = index
        self.delegate = delegate
        super.init(nibName: "DetailVC", bundle: nil)
        self.title = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder not implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.name.text = self.product.name
        self.descriptionLabel.text = product.description
        self.priceLabel.text = "$" + String(product.price / 100.0)
        
        if let image = product.image {
            imageView.image = image
        }else {
            DispatchQueue.global(qos: .userInteractive).async {
                self.loadImage(urlString: self.product.imageUrlString) { [weak self] (image) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.delegate?.updateImage(index: self.index, image: image)
                        self.callbackWithImageClosure?(image)
                    }
                }
            }
        }
    }
    
    deinit {
        print("deinit:  DetailVC")
    }
}


