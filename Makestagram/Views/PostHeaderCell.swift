//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Connie Guan on 7/12/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        print("options button tapped")
    }
    
    
}
