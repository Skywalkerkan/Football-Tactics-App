//
//  ViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 26.12.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    
    private lazy var closeCharacterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
       // button.backgroundColor = .green
        button.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Details", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
       // button.backgroundColor = .green
        button.addTarget(self, action: #selector(detailClicked), for: .touchUpInside)
        return button
    }()
    
    @objc private func detailClicked(){
        
        let detailVC = CharacterDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    private let characterImage: UIImageView = {
        
        let image = UIImage(systemName: "person.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    private let characterName: UILabel = {
        let label = UILabel()
        label.text = "Erkan Coşar"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cizgiYatay: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.alpha = 0.3
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Cizgini Sol Tarafı
    
    private let hizlanmaLabel: UILabel = {
        let label = UILabel()
        label.text = "95 Hız"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sutLabel: UILabel = {
        let label = UILabel()
        label.text = "89 Şut"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pasLabel: UILabel = {
        let label = UILabel()
        label.text = "92 Pas"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let cizgiDikey: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.3
        return view
    }()
    
    //Cizgini Sağ Tarafı


    
    private let dripplingLabel: UILabel = {
        let label = UILabel()
        label.text = "89 Drip"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let defLabel: UILabel = {
        let label = UILabel()
        label.text = "65 Def"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phyLabel: UILabel = {
        let label = UILabel()
        label.text = "75 Phy"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        //stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      //  stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    @objc private func closeClicked(){
        
       // self.customAlertView.transform = .identity

        customAlertView.isHidden = true
    }
    
    private let customAlertView: UIView = {
        let alertView = UIView()
        alertView.layer.cornerRadius = 30
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.green.cgColor
        alertView.backgroundColor = .lightGray
        alertView.isHidden = true
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    
    private let backgroundImageView: UIImageView = {
        let image = UIImage(named: "football_pitch")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let numberOfImageViews = 10 // İhtiyacınıza göre sayıyı değiştirin
      var imageViews = [UIImageView]()
    
    var imageIDs = [String]() // Farklı ID'leri tutan dizi

    var chosenLine = "4 4 2"

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)

   
        dizilisOlustur()

        
        addSubviews()
        
       
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let aspectRatio = screenWidth / screenHeight
        
        print(aspectRatio)
        
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
    
    func dizilisOlustur(){
        
        
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for index in 0..<numberOfImageViews {
                 let imageView = UIImageView()
                imageView.layer.cornerRadius = 25
            
            
                 let randomColor = UIColor(
                     red: CGFloat.random(in: 0...1),
                     green: CGFloat.random(in: 0...1),
                     blue: CGFloat.random(in: 0...1),
                     alpha: 1.0
                 )
                 
                 imageView.backgroundColor = randomColor
                 imageView.frame.size = CGSize(width: 50, height: 50)
                 
                // let randomX = CGFloat.random(in: 0...(view.frame.width - imageView.frame.width))
               //  let randomY = CGFloat.random(in: 0...(view.frame.height - imageView.frame.height))
            
            
                // 4 4 2 düzeni
                
                var xPoints = frameWidth/4 - frameWidth/7 + x
                var yPoints = frameHeight - frameHeight/3 - y
                
            
            
                if chosenLine == "4 4 2"{
                    if index == 4 {
                        x = 0
                        y = frameHeight/10
                        xPoints = frameWidth/4 - frameWidth/7 + x
                      
                      //  yPoints = frameHeight - 200
                    }else if index == 8{
                        x = 0
                        y = 400
                        xPoints = frameWidth/2 + x + 20
                        yPoints = frameHeight - 250 - y
                    }
                    }
            
              
                
               
                 
                 imageView.frame.origin = CGPoint(x: xPoints, y: yPoints)
                 
                let imageID = generateUniqueID()
                imageIDs.append(imageID)
                imageView.tag = index

            
            
                x += 81
                // y += 100
            
                 // Gesture Recognizer ekle
                 let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 imageView.addGestureRecognizer(panGesture)
                 imageView.isUserInteractionEnabled = true
                 
            
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                
            imageView.addGestureRecognizer(tapGesture)
            
                 view.addSubview(imageView)
                 imageViews.append(imageView)
             }
    }
    
    func generateUniqueID() -> String {
          return UUID().uuidString
      }
      
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        guard let tappedImageView = gesture.view as? UIImageView else { return }
        let index = tappedImageView.tag
        let imageID = imageIDs[index]
        
        
        UIView.animate(withDuration: 0.25, animations: {
              self.customAlertView.isHidden = false
              self.customAlertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
          }) { _ in
              // Küçük ölçekleme animasyonu tamamlandığında
          
              // Daha sonra büyük ölçekleme animasyonu ile orijinal boyuta dönmek
              UIView.animate(withDuration: 0.25, animations: {
                  self.customAlertView.transform = .identity
              }) { _ in
                  // Animasyon tamamlandığında yapılacak işlemler (opsiyonel)
              }
          }
        
        customAlertView.isHidden = false
        
        // UUID'yi bastır
        print("Tıklanan Görüntü ID'si: \(imageID)")
     }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView else { return }

        let translation = gesture.translation(in: view)
        
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        
        gesture.setTranslation(.zero, in: view)
    }
    
    
    
    
    private func addSubviews(){
        
        
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width
        
        view.addSubview(customAlertView)
        
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        
        customAlertView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        customAlertView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        customAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customAlertView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/10).isActive = true

        
        // closeCharacterButton
        customAlertView.addSubview(closeCharacterButton)
        
        closeCharacterButton.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor, constant: -5).isActive = true
        closeCharacterButton.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 5).isActive = true
        closeCharacterButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        closeCharacterButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        // character details
        customAlertView.addSubview(detailButton)
        
        detailButton.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor, constant: 15).isActive = true
        detailButton.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 15).isActive = true
        detailButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // Character Button Image
        
        customAlertView.addSubview(characterImage)
        
        characterImage.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 15).isActive = true
        characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        characterImage.widthAnchor.constraint(equalToConstant: view.frame.width/3.4).isActive = true
        characterImage.heightAnchor.constraint(equalToConstant: view.frame.width/3.2).isActive = true

        
        customAlertView.addSubview(characterName)
        
        characterName.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 10).isActive = true
        characterName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        characterName.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor, constant: 10).isActive = true
        characterName.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor, constant: -10).isActive = true
        
        customAlertView.addSubview(cizgiYatay)
        
        cizgiYatay.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 5).isActive = true
        cizgiYatay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiYatay.heightAnchor.constraint(equalToConstant: 1).isActive = true
        cizgiYatay.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true

        
        customAlertView.addSubview(cizgiDikey)
        
        cizgiDikey.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant: 10).isActive = true
        cizgiDikey.bottomAnchor.constraint(equalTo: customAlertView.bottomAnchor, constant: -25).isActive = true
        cizgiDikey.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiDikey.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        customAlertView.addSubview(leftStackView)
        
        leftStackView.addArrangedSubview(hizlanmaLabel)
        leftStackView.addArrangedSubview(sutLabel)
        leftStackView.addArrangedSubview(pasLabel)

        
        leftStackView.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant: 0).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: cizgiDikey.bottomAnchor, constant: 0).isActive = true
        leftStackView.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor, constant: 10).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: cizgiDikey.leadingAnchor, constant: -10).isActive = true

        
        
        customAlertView.addSubview(rightStackView)
        
        rightStackView.addArrangedSubview(dripplingLabel)
        rightStackView.addArrangedSubview(defLabel)
        rightStackView.addArrangedSubview(phyLabel)
        
        rightStackView.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant:  0).isActive = true
        rightStackView.leadingAnchor.constraint(equalTo: cizgiDikey.trailingAnchor, constant: 10).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor, constant: -10).isActive = true
        rightStackView.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor).isActive = true
     

        
    }


}

