//
//  Utility.swift
//  Syntax Notes
//
//  Created by Sunny on 11/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation
import UIKit

class UtilityClass {
    static let sharedUtils = UtilityClass()
    private init(){}
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func convertDateTimeString(dateTimeString:String) -> String{
        let dateTimeArray = dateTimeString.components(separatedBy: .whitespaces)
        let datetimeStr = "\(dateTimeArray[0]) \(dateTimeArray[1]) \(dateTimeArray[2]), \(dateTimeArray[3]) \(dateTimeArray[4])"
        return datetimeStr
    }
}

class Helper {    
    // MARK: - Get index of table view
    class func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {
        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
    }
    
    // MARK: - Get index of collection view
    class func getIndexPathFor(view: UIView, collectionView: UICollectionView) -> IndexPath? {
        let point = collectionView.convert(view.bounds.origin, from: view)
        let indexPath = collectionView.indexPathForItem(at: point)
        return indexPath
    }
}
