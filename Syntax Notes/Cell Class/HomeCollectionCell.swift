//
//  HomeCollectionCell.swift
//  Syntax Notes
//
//  Created by Sunny on 08/12/18.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categroyNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tickBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
