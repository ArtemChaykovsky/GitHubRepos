//
//  RepoDetailsVC.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class RepoDetailsVC: UIViewController {
    
    var viewModel: RepoDetailsVM!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var starsNumberLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var numberOfForksLbl: UILabel!
    @IBOutlet weak var creationDateLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var urlButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.roundCorners()
        usernameLbl.text = viewModel.repoItem.owner?.login
        repoNameLbl.text = viewModel.repoItem.name
        descriptionLbl.text = viewModel.repoItem.descriptionText()
        starsNumberLbl.text = viewModel.repoItem.numberOfStarsText()
        iconImage.load(from: viewModel.repoItem.owner?.avatarUrl, defaultImage: UIImage(named: "ic_NoAvatar"))
        languageLbl.text = "Language: \(viewModel.repoItem.language ?? "n/a")"
        numberOfForksLbl.text = "Number of forks: \(viewModel.repoItem.forks ?? 0)"
        creationDateLbl.text = "Creation date: \(viewModel.repoItem.createdAt ?? "n/a")"
        urlButton.setTitle(viewModel.repoItem.htmlUrl, for: .normal)
    }
    
    @IBAction func linkBtnTapped() {
        if let urlString = viewModel.repoItem.htmlUrl, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
