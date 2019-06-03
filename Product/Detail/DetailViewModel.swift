//
//  DetailViewModel.swift
//  Product
//
//  Created by Mike Saradeth on 5/29/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel: NSObject, LoadImageService {
    var product: Product
    var index: Int
    var delegate: UpdateImageDelegate?
    var callbackWithImageClosure: ((UIImage?) -> Void)?
    @objc dynamic var image: UIImage = UIImage()
    
    init(product: Product, index: Int, delegate: UpdateImageDelegate?) {
        self.product = product
        self.index = index
        self.delegate = delegate
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.loadImage(urlString: self.product.imageUrlString) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                self.image = image
                self.delegate?.updateImage(index: self.index, image: image)
                self.callbackWithImageClosure?(image)
                completion(image)
            }
        }
    }
    
    deinit {
        print("deinit:  DetailViewModel")
    }
}


/* swift 5 KVO example
 @objc class Person: NSObject {
 @objc dynamic var name = "Taylor Swift"
 }
 
 let taylor = Person()
 
 taylor.observe(\Person.name, options: .new) { person, change in
 print("I'm now called \(person.name)")
 
 taylor.name = "Justin Bieber"
 }
*/
