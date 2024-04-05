//
//  RedditService.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/5/24.
//

import Foundation
import Alamofire

class RedditService {
    func fetchTopPosts(after postId: String? = nil, completion: @escaping ([Post]?, String?) -> Void) {
        var urlString = "https://www.reddit.com/top.json?limit=25"
        if let afterId = postId {
            urlString += "&after=\(afterId)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        AF.request(url).responseJSON { response in
            guard response.error == nil, let data = response.value as? [String: Any], let dataDict = data["data"] as? [String: Any], let children = dataDict["children"] as? [[String: Any]] else {
                completion(nil, nil)
                return
            }
            
            let posts: [Post] = children.compactMap { childDict in
                guard let postDict = childDict["data"] as? [String: Any],
                      let previewDict = postDict["preview"] as? [String: Any],
                      let imagesArray = previewDict["images"] as? [[String: Any]],
                      let sourceDict = imagesArray.first?["source"] as? [String: Any],
                      let urlString = sourceDict["url"] as? String,
                      let url = URL(string: urlString.replacingOccurrences(of: "&amp;", with: "&")) else {
                    return nil
                }
                
                let title = postDict["title"] as? String ?? "No Title"
                let author = postDict["author"] as? String ?? "Unknown"
                let commentCount = postDict["num_comments"] as? Int ?? 0
                let subreddit = postDict["subreddit_name_prefixed"] as? String ?? ""
                let score = postDict["score"] as? Int ?? 0
                
                let date = Date(timeIntervalSince1970: postDict["created_utc"] as? Double ?? 0)
                
                return Post(title: title, author: author, date: date, thumbnailURL: url, numberOfComments: commentCount, subreddit: subreddit, score: score)
            }
            
            let afterId = dataDict["after"] as? String
            completion(posts, afterId)
        }
    }
}
