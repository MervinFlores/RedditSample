//
//  PostListViewController.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/4/24.
//

import Foundation
import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PostListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PostListViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
        viewModel.fetchPosts {
            self.tableView.reloadData()
        }
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44)
        loadingIndicator.startAnimating()
        self.tableView.tableFooterView = loadingIndicator
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.selectedBackgroundView = UIView()
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post)
        
        cell.onImageLoaded = { [weak tableView, weak cell] in
            guard let indexPathForCell = tableView?.indexPath(for: cell!) else { return }
            
            
            if indexPathForCell == indexPath {
                tableView?.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        return cell
    }
}

extension PostListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let tableViewContentSizeHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (tableViewContentSizeHeight - 100 - scrollViewHeight) {
            guard !viewModel.isLoading else { return }
            
            self.tableView.tableFooterView?.isHidden = false
            
            viewModel.fetchPosts {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
}

