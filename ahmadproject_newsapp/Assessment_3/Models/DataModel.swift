//
//  DataModel.swift
//  Assessment_3
//
//  Created by Admin on 22/03/22.
//

import Foundation
import UIKit

struct NewsFields{
    var image : UIImage?
    var title : String
    var shortDescription : String
    var fullDescription : String
    var date : String
    var isFav = false
    let uuid: String = UUID().uuidString
}

class DataModel{
    static var shared = DataModel()
    var allData = [NewsFields]()
    
    func addNews(_ news : NewsFields ){
        //allData.insert(news, at: 0)
        allData.append(news)
    }
}

var recentNews:[NewsFields]{
    DataModel.shared.allData.sorted(by: {
        $0.date.compare($1.date) == .orderedDescending
    })
}

var favMapOfDateAndNews = [String : [NewsFields]]()
