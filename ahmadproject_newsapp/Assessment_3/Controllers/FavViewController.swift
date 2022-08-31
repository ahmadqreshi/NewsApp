//
//  FavViewController.swift
//  Assessment_3
//
//  Created by Admin on 22/03/22.
//

import UIKit

class FavViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak private var favTableView: UITableView!
    
    // MARK: - Private  Properties
    private var editOff : Bool = false
    private var arrayOfFeeds = [NewsFields]()
    private var dates = [String]()
    
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        favTableView.dataSource = self
        favTableView.delegate = self
        self.navigationItem.title = StringConstant.favFeedTitle.rawValue
    }
    override func viewWillAppear(_ animated: Bool) {
        updateFavDictionary()
        favTableView.reloadData()
    }
    
    private func updateFavDictionary(){
        arrayOfFeeds = DataModel.shared.allData.filter({$0.isFav}).sorted(by: {$0.date>$1.date})
        dates = Array(Set(DataModel.shared.allData.filter({$0.isFav}).compactMap({$0.date})))
        dates.sort { (lhs: String, rhs: String) -> Bool in
            return lhs > rhs
        }
        dates.forEach({
            favMapOfDateAndNews[$0] = [NewsFields]()
        })
        arrayOfFeeds.forEach({
            favMapOfDateAndNews[$0.date]?.append($0)
        })
    }
    private func setUpTableViewCell(){
        let nib = UINib(nibName: StringConstant.NewsTableViewCell.rawValue, bundle: nil)
        self.favTableView.register(nib, forCellReuseIdentifier: StringConstant.NewsTableViewCell.rawValue)
    }
    @IBAction func editBtnPressed(_ sender: Any) {
        editOff = !editOff
        favTableView.setEditing(editOff, animated: false)
    }
}

extension FavViewController : UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMapOfDateAndNews[dates[section]]?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if favMapOfDateAndNews.keys.count > 0
        {
            self.favTableView.backgroundView = nil
            numOfSection = favMapOfDateAndNews.keys.count
            
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.favTableView.bounds.size.width, height: self.favTableView.bounds.size.height))
            noDataLabel.text = StringConstant.noFavourites.rawValue
            noDataLabel.textColor = .black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.favTableView.backgroundView = noDataLabel
        }
        
        return numOfSection
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favTableView.dequeueReusableCell(withIdentifier: StringConstant.NewsTableViewCell.rawValue, for: indexPath) as! NewsTableViewCell
        cell.favButton.isHidden = true
        cell.newsTitle.text = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].title
        cell.newsImageView.image = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].image
        cell.newsDescription.text = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].shortDescription
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForFavCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StringConstant.main.rawValue , bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: StringConstant.DetailsViewController.rawValue) as! DetailsViewController
        
        
        if let index = DataModel.shared.allData.firstIndex(where: {
            $0.uuid == favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].uuid
        }){
            vc.index = index
        }
        vc.tempImg = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].image
        vc.tempTitle = (favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].title) ?? ""
        vc.tempShortTitle = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].shortDescription ?? ""
        vc.tempFullDescription = favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].fullDescription ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favMapOfDateAndNews[dates[section]]?[0].date ?? StringConstant.noFavourites.rawValue
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let index = DataModel.shared.allData.firstIndex(where: {$0.uuid == favMapOfDateAndNews[dates[indexPath.section]]?[indexPath.row].uuid}){
                DataModel.shared.allData[index].isFav = !DataModel.shared.allData[index].isFav
                favMapOfDateAndNews.removeValue(forKey: DataModel.shared.allData[index].date)
                if let first = dates.firstIndex(where: {$0 == DataModel.shared.allData[index].date}){
                dates.remove(at: first)
                }
                updateFavDictionary()
            }
            favTableView.reloadData()
        }
    }
}
