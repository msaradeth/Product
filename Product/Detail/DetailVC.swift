//
//  DetailVC.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var viewModel: DetailViewModel
        
    init(title: String, viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailVC", bundle: nil)
        self.title = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder not implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.name.text = viewModel.product.name
        self.descriptionLabel.text = viewModel.product.description
        self.priceLabel.text = "$" + String(viewModel.product.price / 100.0)
        
        if let image = viewModel.product.image {
            imageView.image = image
        }else {
            viewModel.loadImage() { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    deinit {
        print("deinit:  DetailVC")
    }
}


