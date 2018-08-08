//
//  CustomTableViewCell.swift
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 08/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicAlternateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
