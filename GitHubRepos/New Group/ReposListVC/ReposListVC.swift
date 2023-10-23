//
//  ReposListVC.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 18.10.2023.
//

import UIKit

final class ReposListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ReposListVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(cellType: RepoInfoCell.self)
        fetchRepos()
    }
    
    private func fetchRepos() {
        AKActivity.add(to: view)
        viewModel.fetchRepos { [weak self] error in
            AKActivity.remove()
            if let error {
                self?.showAlert(message: error)
                return
            }
            self?.tableView.reloadData()
        }
    }
    
    //Actions
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if let period = TimePeriod(rawValue: sender.selectedSegmentIndex) {
            viewModel.selectedPeriod = period
            tableView.reloadData()
            if viewModel.isDataEmpty() {
                fetchRepos()
            }
            tableView.setContentOffset(CGPoint(x: 0, y: viewModel.contentOffset()), animated: false)
        }
    }
}

extension ReposListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.needFetchNextItems(currentIndexPath: indexPath) {
            fetchRepos()
        }
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.saveContentOffset(scrollView.contentOffset.y)
    }
}
