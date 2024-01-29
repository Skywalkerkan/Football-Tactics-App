//
//  LanguagesTableViewCell.swift
//  Football Tactics App
//
//  Created by Erkan on 28.01.2024.
//

import UIKit

class LanguagesTableViewCell: UITableViewCell {

    
    let countryImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "alman")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let countryName: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TÜRKİYE"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          
          // Örnek bir resim ataması yapabilirsiniz (bu kısmı ihtiyacınıza göre düzenleyin)
          
          // UIImageView'i hücreye ekleme
          addSubviews()
        
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    
    private func addSubviews(){
        
        
        addSubview(countryImage)
        addSubview(countryName)

        
        countryImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        countryImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        countryImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        countryImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true

        
        
        countryName.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        countryName.leadingAnchor.constraint(equalTo: countryImage.trailingAnchor, constant: 10).isActive = true
        countryName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        countryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        countryName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
      //  countryName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        
        
        
        
    }

}
