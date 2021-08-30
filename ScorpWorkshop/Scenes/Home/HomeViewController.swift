//
//  ViewController.swift
//  ScorpWorkshop
//
//  Created by Kaan Ozdemir on 30.08.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableView()
    }


}

// MARK: - TableView Functions
extension HomeViewController {
    func configureTableView() {
        tableView.register(UINib(nibName: PersonTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc
    func refreshTableView() {
        refreshControl.endRefreshing()
    }
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.cellIdentifier, for: indexPath) as! PersonTableViewCell
        
        cell.label.backgroundColor = .red
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
}
