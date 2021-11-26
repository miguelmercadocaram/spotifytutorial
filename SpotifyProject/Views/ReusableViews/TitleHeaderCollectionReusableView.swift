//
//  TitleHeaderCollectionReusableView.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/18/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
        static let identifier = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: width-20, height: 44)
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
