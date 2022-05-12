//
//  MainTableViewCell.swift
//  Notes
//
//  Created by Nodirbek on 10/05/22.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let id = "MainTableViewCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    
    func configure(title: String?, secondaryText: String?){
        self.titleLabel.text = title
        self.secondaryLabel.text = secondaryText
    }

}
