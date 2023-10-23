//
//  RepoInfoCellTableViewCell.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

final class RepoInfoCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var starsNumberLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var item: RepoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.roundCorners()
    }
    
    override func prepareForReuse() {
        iconImage.image = nil
    }
    
    func setup(with item: RepoItem?) {
        guard let item else {
            return
        }
        usernameLbl.text = item.owner?.login
        repoNameLbl.text = item.name
        descriptionLbl.text = item.descriptionText()
        starsNumberLbl.text = item.numberOfStarsText()
        iconImage.load(from: item.owner?.avatarUrl, defaultImage: UIImage(named: "ic_NoAvatar"))
        if item.isSaved() {
            saveButton.setImage(UIImage(named: "ic_addedToFavourites"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "ic_addToFavourites"), for: .normal)
        }
        self.item = item
    }
    
    @IBAction func saveBtnTapped() {
        guard let item else {
            return
        }
        if item.isSaved() {
            StorageService.shared.delete(item: item)
            saveButton.setImage(UIImage(named: "ic_addToFavourites"), for: .normal)
        } else {
            StorageService.shared.save(item: item)
            saveButton.setImage(UIImage(named: "ic_addedToFavourites"), for: .normal)
        }
    }
}
