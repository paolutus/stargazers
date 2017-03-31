//
//  StargazerCell.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 30/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit

class StargazerCell: UITableViewCell, AvatarDelegate {
	var stargazer : Stargazer? {
		didSet {
			guard stargazer != nil else {
				return
			}
			self.nameLabel.text = stargazer!.login
			stargazer!.loadAvatar(delegate: self)
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		stargazer?.avatarDelegate = nil
		self.nameLabel.text = ""
		self.avatarImageView.image = nil
	}

	@IBOutlet weak var avatarImageView: UIImageView!
	
	@IBOutlet weak var nameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	// MARK: - AvatarDelegate
	
	func avatarReady(image: UIImage) {
		self.avatarImageView.image = image
	}
	
	func avatarUnavailable() {
		
	}
	
}
