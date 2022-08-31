//
//  NewsTableViewCell.swift
//  Assessment_3
//
//  Created by Admin on 22/03/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    //MARK: - Internal Properties
    var favPressed : (()->())?
    var favCheck : Bool = false
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    //MARK: - Custom Methods
    @IBAction private func favButtonPressed(_ sender: UIButton) {
        favCheck = !favCheck
        if favCheck {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        } else{
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        }
        self.favPressed?()
    }
    func displayNewsFeed(newsFeedData: NewsFields){
        let image: UIImage?

        if newsFeedData.isFav {
            image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
        } else{
            image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
        }

        favButton.setImage(image, for: .normal)
    }
    
}
