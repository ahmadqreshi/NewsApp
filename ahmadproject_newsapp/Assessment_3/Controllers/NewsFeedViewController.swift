//
//  NewsFeedViewController.swift
//  Assessment_3
//
//  Created by Admin on 21/03/22.
//

import UIKit

class NewsFeedViewController: UIViewController{
    
    // MARK: - IBOutlets
    @IBOutlet weak private var newsFeedTableView: UITableView!
    
    //MARK: - private properties
    private var mapOfDateAndNews = [String : [NewsFields]]()
    private var arrayOfFeeds = [NewsFields]()
    private var dates = [String]()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        self.navigationItem.title = StringConstant.newsFeedTitle.rawValue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        arrayOfFeeds = DataModel.shared.allData.sorted(by: {$0.date>$1.date})
        dates = Array(Set(DataModel.shared.allData.compactMap({$0.date})))
        dates.sort { (lhs: String, rhs: String) -> Bool in
            return lhs > rhs
        }
        dates.forEach({
            mapOfDateAndNews[$0] = [NewsFields]()
        })
        arrayOfFeeds.forEach({
            mapOfDateAndNews[$0.date]?.append($0)
        })
        
        newsFeedTableView.reloadData()
    }
    private func setUpTableViewCell(){
        let nib = UINib(nibName: StringConstant.RecentNewsTableViewCell.rawValue, bundle: nil)
        self.newsFeedTableView.register(nib, forCellReuseIdentifier: StringConstant.RecentNewsTableViewCell.rawValue)
        
        let nib2 = UINib(nibName: StringConstant.NewsTableViewCell.rawValue, bundle: nil)
        self.newsFeedTableView.register(nib2, forCellReuseIdentifier: StringConstant.NewsTableViewCell.rawValue)
    }
    
}
// MARK: - delegate methods
extension NewsFeedViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : mapOfDateAndNews[dates[section - 1]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: StringConstant.RecentNewsTableViewCell.rawValue, for: indexPath) as! RecentNewsTableViewCell
            cell.tapOnSelect = {(index) in
                let storyboard = UIStoryboard(name: StringConstant.main.rawValue, bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: StringConstant.DetailsViewController.rawValue) as! DetailsViewController
                vc.tempImg = recentNews[index].image
                vc.tempTitle = recentNews[index].title
                vc.tempShortTitle = recentNews[index].shortDescription
                vc.tempFullDescription = recentNews[index].fullDescription
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.refereshFavBtn = {
                self.newsFeedTableView.reloadData()
            }
            return cell
        default:
            let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: StringConstant.NewsTableViewCell.rawValue, for: indexPath) as! NewsTableViewCell
            cell.newsImageView.image = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].image
            cell.newsTitle.text = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].title
            cell.newsDescription.text = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].shortDescription
            if let index = DataModel.shared.allData.firstIndex(where: {$0.uuid == mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].uuid}){
                cell.displayNewsFeed(newsFeedData: DataModel.shared.allData[index])
                cell.favPressed = {
                    DataModel.shared.allData[index].isFav = !DataModel.shared.allData[index].isFav
                    if !DataModel.shared.allData[index].isFav{
                        favMapOfDateAndNews.removeValue(forKey: DataModel.shared.allData[index].date)
                    }
                    self.newsFeedTableView.reloadData()
                }
            }
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? Constants.heightForRecentCell : Constants.heightForNewsCell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? StringConstant.recentSection.rawValue : dates[section-1]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StringConstant.main.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: StringConstant.DetailsViewController.rawValue) as! DetailsViewController
        vc.tempImg = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].image
        vc.tempTitle = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].title ?? ""
        vc.tempShortTitle = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].shortDescription ?? ""
        vc.tempFullDescription = mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].fullDescription ?? ""
        if let index = DataModel.shared.allData.firstIndex(where: {$0.uuid == mapOfDateAndNews[dates[indexPath.section - 1]]?[indexPath.row].uuid}){
            vc.index = index
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
