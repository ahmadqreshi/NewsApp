//
//  StringConstant.swift
//  Assessment_3
//
//  Created by Admin on 23/03/22.
//

import Foundation
enum StringConstant : String{
    case newsFeedTitle = "News"
    case recentSection = "Recents"
    case addNewsTitle = "Add News"
    case detailTitle = "Details"
    case favFeedTitle = "Favourites"
    case noFavourites = "No Favourites"
    case addAlertTitle = "Add Photo"
    case addAlertMsg = "Add Photos from Gallery"
    case photoLib = "Photo Library"
    case cancel = "Cancel"
    case confirm = "Confirm?"
    case confirmMsg = "Confirm or choose another image from gallery"
    case displayImageAlert = "Please Add the Image"
    case displayTitleAlert = "Please fill The Title of the news"
    case displayShortdescAlert = "Please Write the short Description"
    case displayFulldescAlert = "Please Write the Full Description"
    case displayMinimumWords = "Please Write minimum 40 Words in Full Description"
    case displayDateAlert = "Please Enter the date"
    case shortDescriptionPlaceholder = "Enter Short description (less than 80 words)"
    case fullDescriptionPlaceholder = "Enter Full description (more than 40 words)"
    case submitted = "Submitted"
    case newsAddedSucccesful = "News Added Successfully!"
    case warning = "Warning!"
    case ok = "Ok"
    case done = "Done"
    case removePhoto = "Remove Photo"
    case shortMinimumWordMsg = "Please Enter Minimum 3 words in Short Description"
    
    //MARK: - nib identifiers
    case RecentCollectionViewCell = "RecentCollectionViewCell"
    case RecentNewsTableViewCell = "RecentNewsTableViewCell"
    case NewsTableViewCell = "NewsTableViewCell"
    case main = "Main"
    case DetailsViewController = "DetailsViewController"
    case titleCharacterLimit = "Character Limit : 80"
}
