//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Connie Guan on 7/11/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController{
   
    //date formatter: convert Date into a formatted string
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    //MARK: - Properties
    
    var posts = [Post]()
    
    //MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- VC Lifecycle
    
    //fetch posts from Firebase
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource

//retrieve data from Post array
extension HomeViewController: UITableViewDataSource {
    
    //return 3 rows for each section (header, image, action cells)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
    }
}

// MARK: - UITableViewDelegate

//return height that each cell should be given an index path
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
            
        case 2:
            return PostActionCell.height
            
        default:
            fatalError()
        }
    }
}

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        // 1: make sure an index path exists for given cell
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // 2: set to false so user doesn't accidentally send multiple requests by tapping too quickly
        likeButton.isUserInteractionEnabled = false
        
        // 3: reference the correct post corresponding with the PostActionCell that the user tapped
        let post = posts[indexPath.section]
        
        // 4: use LikeService to like/unlike
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // 5: use defer to set to true when closure returns
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // 6: basic error handling
            guard success else { return }
            
            // 7: change likeCount and isLiked properties if network request was successful
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // 8: get reference to current cell
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            // 9: update the UI of the cell on main thread
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
