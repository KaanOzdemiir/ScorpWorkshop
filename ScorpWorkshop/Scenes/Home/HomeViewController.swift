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
    
    
    // MARK: ViewModel
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableView()
        
        viewModel.fetchPeople()
    }
}

// MARK: - TableView Functions
extension HomeViewController {
    func configureTableView() {
        tableView.register(UINib(nibName: PersonTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        
        viewModel.isLoading = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.startLoading() : self.stopLoading()
            
            if !isLoading {
                self.viewModel.people.isEmpty ? self.tableView.setEmptyMessage("No one here :)") : self.tableView.restore()
            }
        }
        
        viewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.presentError = { [weak self] error in
            guard let self = self else { return }
            #if DEBUG
            print("Error Presenting: \(error.errorDescription)")
            #endif
            self.presentAlert(
                title: "Error!",
                message: error.errorDescription,
                actions: [
                    UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        self.viewModel.fetchPeople()
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
            ])
        }
        
        viewModel.refreshTableView = { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.viewModel.people.isEmpty ? self.viewModel.fetchPeople() : self.tableView.reloadData()
        }
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc
    func refreshTableView() {
        viewModel.refreshTableView()
    }
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.cellIdentifier, for: indexPath) as! PersonTableViewCell
        
        let person = viewModel.getPersonBy(indexPath)
        cell.label.text = "\(person.fullName) (\(person.id))"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.fetchNextSetOfPeopleIfNeeded(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
