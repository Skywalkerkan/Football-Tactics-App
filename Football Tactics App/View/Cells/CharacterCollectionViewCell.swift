//
//  CharacterCollectionViewCell.swift
//  Football Tactics App
//
//  Created by Erkan on 25.01.2024.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
       // imageView.image = UIImage(named: "pitch")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    
    let characterNumberView: UIView = {
        let imageView = UIView()
        imageView.contentMode = .scaleToFill
       // imageView.image = UIImage(named: "pitch")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    
    let characterNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "99"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let characterNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Erkan Coşar"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    
    lazy var deleteCharacterButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return button
        
    }()
    
    @objc func deleteClicked(){
        
        print("aaa")
        

        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpUI(){
        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(deleteCharacterButton)
        contentView.addSubview(characterNumberView)
        characterNumberView.addSubview(characterNumberLabel)
        
        
        contentView.clipsToBounds = true
        
        clipsToBounds = true
     

        
        
       //Image
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.frame.size.height / 6)
        ])
        
        
      
              
        //Label
        NSLayoutConstraint.activate([
            characterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            deleteCharacterButton.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 4),
            //deleteTacticButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            deleteCharacterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteCharacterButton.heightAnchor.constraint(equalToConstant: 20),
            deleteCharacterButton.widthAnchor.constraint(equalToConstant: 20)

        ])
        
        
        NSLayoutConstraint.activate([
            characterNumberView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 4),
            //deleteTacticButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            characterNumberView.heightAnchor.constraint(equalToConstant: 30),
            characterNumberView.widthAnchor.constraint(equalToConstant: 30)

        ])
        
        NSLayoutConstraint.activate([
            characterNumberLabel.topAnchor.constraint(equalTo: characterNumberView.topAnchor, constant: 2),
            characterNumberLabel.bottomAnchor.constraint(equalTo: characterNumberView.bottomAnchor),
            characterNumberLabel.centerXAnchor.constraint(equalTo: characterNumberView.centerXAnchor)


        ])
        
        
        
    }
    
}
