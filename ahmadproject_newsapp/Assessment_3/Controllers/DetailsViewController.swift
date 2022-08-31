//
//  DetailsViewController.swift
//  Assessment_3
//
//  Created by Admin on 22/03/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak private var detailsImage: UIImageView!
    @IBOutlet weak private var detailsTitle: UILabel!
    @IBOutlet weak private var detailShortDescription: UILabel!
    @IBOutlet weak private var detailFullDescription: UILabel!
    @IBOutlet weak private var favButton: UIButton!
    
    // MARK: - internal Properties
    var tempImg : UIImage!
    var tempTitle = String()
    var tempShortTitle = String()
    var tempFullDescription = String()
    var index = Int()
   
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsImage.image = tempImg
        detailsTitle.text = tempTitle
        detailShortDescription.text = tempShortTitle
        detailFullDescription.text = tempFullDescription
        self.navigationItem.title = StringConstant.detailTitle.rawValue
        updateFavButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        view.reloadInputViews()
    }
    // MARK: - Actions
    @IBAction private func favButtonPressed(_ sender: UIButton) {
        if !DataModel.shared.allData[index].isFav{
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        } else{
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        }
        DataModel.shared.allData[index].isFav = !DataModel.shared.allData[index].isFav
        if !DataModel.shared.allData[index].isFav{
            favMapOfDateAndNews.removeValue(forKey: DataModel.shared.allData[index].date)
        }
    }
    
    //MARK: - custom methods
    private func updateFavButton(){
        if DataModel.shared.allData[index].isFav{
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        }else{
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.favBtnSize, weight: .medium))
            favButton.setImage(image, for: .normal)
            favButton.tintColor = .red
        }
    }
}
