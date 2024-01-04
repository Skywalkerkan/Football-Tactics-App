//
//  PitchCollectionViewCell.swift
//  Football Tactics App
//
//  Created by Erkan on 4.01.2024.
//

import UIKit

class PitchCollectionViewCell: UICollectionViewCell {
    
    let pitchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "football_pitch")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
        

    let pitchNameLabel: UILabel = {
        let label = UILabel()
        label.text = "4 4 2"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpUI(){
        contentView.addSubview(pitchImageView)
        pitchImageView.addSubview(pitchNameLabel)

       //Image
        NSLayoutConstraint.activate([
            pitchImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pitchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pitchImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pitchImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
              
        //Label
        NSLayoutConstraint.activate([
            pitchNameLabel.topAnchor.constraint(equalTo: pitchImageView.topAnchor, constant: 8),
            pitchNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pitchNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pitchNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    
    
}
