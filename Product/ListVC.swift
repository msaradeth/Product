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
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ListVC", bundle: nil)
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

}

extension ListVC: UpdateImageDelegate {
    func updateImage(index: Int, image: UIImage?) {
        viewModel.items[index].image = image
    }
}


extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.cellIdentifier, for: indexPath) as! ListCell
        cell.configure(item: viewModel.items[indexPath.row], index: indexPath.row, delegate: viewModel)
        
        return cell
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailVC(product: viewModel.items[indexPath.row], index: indexPath.row, delegate: self)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
