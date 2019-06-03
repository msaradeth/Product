//
//  ListVC.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

protocol UpdateImageDelegate {
    func updateImage(index: Int, image: UIImage?)
}

class ListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ListViewModel
    var segmentedControl: UISegmentedControl
    
    init(title: String, viewModel: ListViewModel) {
        self.viewModel = viewModel
        self.segmentedControl = UISegmentedControl(items:  ["All", "Favorites"])
        self.segmentedControl.selectedSegmentIndex = 0
        super.init(nibName: "ListVC", bundle: nil)
        
        //set title and navigationItem.titleView and add segmentedControl target
        self.segmentedControl.addTarget(self, action: #selector(selectedSegment(sender:)), for: .valueChanged)
        self.title = title
        self.navigationItem.titleView = segmentedControl
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        viewModel.loadData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    func setupVC() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: ListCell.cellIdentifier)
        tableView.rowHeight = 90
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func selectedSegment(sender: UISegmentedControl) {
        viewModel.selectedSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }

}

extension ListVC: UpdateImageDelegate {
    func updateImage(index: Int, image: UIImage?) {
        viewModel.items[index].image = image
    }
}


extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.cellIdentifier, for: indexPath) as! ListCell
        cell.configure(item: viewModel[indexPath.row], index: indexPath.row, delegate: viewModel)
        
        return cell
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
        let product = viewModel[indexPath.row]
        let detailViewModel = DetailViewModel(product: product, index: indexPath.row, delegate: self)
        detailViewModel.callbackWithImageClosure = { [weak self] (image) in
            self?.viewModel.items[indexPath.row].image = image
        }

        
        let detailVC = DetailVC(title: product.name, viewModel: detailViewModel)

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
