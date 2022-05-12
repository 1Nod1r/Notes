//
//  MainTableViewCell.swift
//  Notes
//
//  Created by Nodirbek on 10/05/22.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let id = "MainTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set()
    }
    
    private func set(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(secondaryLabel)
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?, secondaryText: String?){
        self.titleLabel.text = title
        self.secondaryLabel.text = secondaryText
    }

}
