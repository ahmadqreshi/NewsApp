//
//  RecentCollectionViewCell.swift
//  Assessment_3
//
//  Created by Admin on 21/03/22.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var recentImageView: UIImageView!
    @IBOutlet weak var recentTitle: UILabel!
    @IBOutlet weak var recentDescription: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    //MARK: - Internal Properties
    var favPressed : (()->())?
    var favCheck : Bool = false
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Custom Methods
    func displayNewsFeed(newsFeedData: NewsFields){
        let image: UIImage?
        if newsFeedData.isFav {
            image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
        } else{
            image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
        }
        favButton.setImage(image, for: .normal)
        favButton.tintColor = .red
    }
    
    //MARK: - Actions on Button
    @IBAction func favButtonPressed(_ sender: UIButton) {
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
    
}
