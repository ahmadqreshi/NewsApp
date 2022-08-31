//
//  RecentNewsTableViewCell.swift
//  Assessment_3
//
//  Created by Admin on 21/03/22.
//

import UIKit


class RecentNewsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var recentCollectionView: UICollectionView!
    
    
    //MARK: - Internal prperties
    var tapOnSelect : ((Int)->())?
    var refereshFavBtn : (() -> ())?
    
    
    //MARK: - Private properties
    private let minimumCells = 3
    
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionViewCell()
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        recentCollectionView.reloadData()
    }
    private func setUpCollectionViewCell(){
        let nib = UINib(nibName: StringConstant.RecentCollectionViewCell.rawValue, bundle: nil)
        self.recentCollectionView.register(nib, forCellWithReuseIdentifier: StringConstant.RecentCollectionViewCell.rawValue)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapOnSelect!(indexPath.row)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

//MARK: - Delegates Method
extension RecentNewsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentNews.count > minimumCells ? minimumCells : recentNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: StringConstant.RecentCollectionViewCell.rawValue, for: indexPath) as! RecentCollectionViewCell
        cell.recentImageView.image = recentNews[indexPath.row].image
        cell.recentTitle.text = recentNews[indexPath.row].title
        cell.recentDescription.text = recentNews[indexPath.row].shortDescription
        cell.displayNewsFeed(newsFeedData: recentNews[indexPath.row])
        cell.favPressed = {
            if let index = DataModel.shared.allData.firstIndex(where: {$0.uuid == recentNews[indexPath.row].uuid}){
                DataModel.shared.allData[index].isFav = !DataModel.shared.allData[index].isFav
                if !DataModel.shared.allData[index].isFav{
                    favMapOfDateAndNews.removeValue(forKey: DataModel.shared.allData[index].date)
                }
            }
            self.refereshFavBtn?()
        }
        return cell
    }
}
extension RecentNewsTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.widthForRecentCollectionCell, height: Constants.heightForRecentCollectionCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInterSpacing
    }
}
