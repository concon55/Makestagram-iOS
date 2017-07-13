//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Connie Guan on 7/12/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: PostActionCellDelegate?
    
    static let height: CGFloat = 46
    
    //MARK: - Subviews
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    //MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBActions
    
    //notify delegate when user taps like button
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }

}
