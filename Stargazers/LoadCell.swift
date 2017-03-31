//
//  LoadCell.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 31/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit

class LoadCell: UITableViewCell {

	weak var delegate : StargazersTableViewController?
	
	@IBAction func loadButtonPressed(_ sender: Any) {
		delegate?.loadNextPage(nil)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
