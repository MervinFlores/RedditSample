//
//  PostTableViewCell.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/4/24.
//

import Foundation
import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var onImageLoaded: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.layer.cornerRadius = 12.0
        self.containerView.configureCornerRadiusAndShadow()
    }
    
    func configureDateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        dateLabel.text = "\(dateString)"
    }
    
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        authorLabel.text = "\(post.author) • \(timeAgoSinceDate(post.date)) • \(post.subreddit)"
        commentsCountLabel.text = "\(post.numberOfComments)"
        scoreLabel.text = "\(post.score)"
        
        self.configureDateLabel(with: post.date)
        
        if let thumbnailURL = post.thumbnailURL{
            thumbnailImageView.sd_setImage(with: thumbnailURL, placeholderImage: UIImage()) { [weak thumbnailImageView] (image, error, cacheType, imageURL) in
                guard let strongImageView = thumbnailImageView, let image = image else { return }
                
                let aspectRatio = image.size.width / image.size.height
                if let existingConstraint = (strongImageView.constraints.filter{$0.identifier == "aspectRatio"}.first) {
                    strongImageView.removeConstraint(existingConstraint)
                }
                
                let newConstraint = NSLayoutConstraint(item: strongImageView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: strongImageView,
                                                       attribute: .height,
                                                       multiplier: aspectRatio,
                                                       constant: 0)
                newConstraint.identifier = "aspectRatio"
                newConstraint.priority = UILayoutPriority(999)
                
                strongImageView.addConstraint(newConstraint)
                strongImageView.superview?.layoutSubviews()
                strongImageView.superview?.layoutIfNeeded()
                
                self.onImageLoaded?()
                
            }
        } else {
            thumbnailImageView.image = nil
        }
    }
    
    private func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)
        
        if let year = components.year, year >= 1 {
            return "\(year)y"
        } else if let month = components.month, month >= 1 {
            return "\(month)M"
        } else if let week = components.weekOfYear, week >= 1 {
            return "\(week)w"
        } else if let day = components.day, day >= 1 {
            return "\(day)d"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)h"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)m"
        } else if let second = components.second, second >= 3 {
            return "\(second)s"
        } else {
            return "Just now"
        }
    }
}


