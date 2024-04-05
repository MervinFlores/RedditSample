//
//  PostListViewModel.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/4/24.
//

import Foundation

class PostListViewModel {
    var posts: [Post] = []
    private var afterId: String?
    var isLoading = false
    
    func fetchPosts(completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        RedditService().fetchTopPosts(after: afterId) { [weak self] newPosts, afterId in
            DispatchQueue.main.async {
                guard let newPosts = newPosts else {
                    self?.isLoading = false
                    completion()
                    return
                }
                
                self?.posts.append(contentsOf: newPosts)
                self?.afterId = afterId
                self?.isLoading = false
                completion()
            }
        }
    }
}

