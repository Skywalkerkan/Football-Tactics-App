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
        imageView.image = UIImage(named: "pitch")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
        

    let pitchNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    let tacticNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    
    let deleteTacticButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.isHidden = true
        return button
        
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
        contentView.addSubview(tacticNameLabel)
        contentView.addSubview(pitchNameLabel)
        contentView.addSubview(deleteTacticButton)
        
        
     

       //Image
        NSLayoutConstraint.activate([
            pitchImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pitchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pitchImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pitchImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            tacticNameLabel.topAnchor.constraint(equalTo: pitchImageView.topAnchor, constant: 8),
            tacticNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            tacticNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            tacticNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
              
        //Label
        NSLayoutConstraint.activate([
            pitchNameLabel.topAnchor.constraint(equalTo: tacticNameLabel.bottomAnchor, constant: 8),
            pitchNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pitchNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pitchNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            deleteTacticButton.topAnchor.constraint(equalTo: pitchImageView.topAnchor, constant: 4),
            //deleteTacticButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            deleteTacticButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteTacticButton.heightAnchor.constraint(equalToConstant: 20),
            deleteTacticButton.widthAnchor.constraint(equalToConstant: 20)

        ])
        
        
    }

    
    
}
