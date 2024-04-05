//
//  Post.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/4/24.
//

import Foundation

struct Post {
    let title: String
    let author: String
    let date: Date
    let thumbnailURL: URL?
    let numberOfComments: Int
    let subreddit: String
    let score: Int
}
