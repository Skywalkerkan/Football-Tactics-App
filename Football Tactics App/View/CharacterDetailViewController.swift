//
//  CharacterDetailViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 27.12.2023.
//

import UIKit
import CoreData



class CharacterDetailViewController: UIViewController, UITextFieldDelegate {
    
    
    var tacticUUIDString: String? = nil
    var characterIndex: Int? = nil

    var player: Player? = nil
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    
    
    
  //  let character: [Person]? = nil
    
    
    /*private func addCharacter(){
        
        guard let nameText = characterNameTextField.text, !nameText.isEmpty else{
            alertController()
            return
        }
       
        let newPerson = Person(context: self.context)
        newPerson.name = nameText
        newPerson.pace = "\(Int(customSliderHizlanma.value))"
        newPerson.shooting = "\(Int(customSliderSut.value))"
        newPerson.passing = "\(Int(customSliderPas.value))"
        newPerson.dribbling = "\(Int(customSliderDrib.value))"
        newPerson.defending = "\(Int(customSliderDef.value))"
        newPerson.physical = "\(Int(customSliderPhy.value))"
        
        if let imageData = characterImageView.image?.pngData() {
            newPerson.image = imageData
        }
        
        do{
            
            try self.context.save()
            print("Başarıyla kaydedildi")
            
            fetchCharacter()
            
        }catch{
            print("error")
        }
        
        

    }*/
    
    
    
    func alertController(){
        
        let alertController = UIAlertController(title: "Error", message: "You entered imcomplete info", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(action)
        
        present(alertController, animated: true)
        
        
    }
    
   
 
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Save Character", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc private func saveButtonClicked(){
    //    addCharacter()
        
        guard let characterIndex = characterIndex else{return}
        guard let tacticUUIDString = tacticUUIDString else{return}
        
        
        
        saveCharacter(tacticUUID: tacticUUIDString, characterIndex: characterIndex)
    }
    
    
    
    
    
    //Oyuncu Kart Önizlemesi
    private let customCardView: UIView = {
        let alertView = UIView()
        alertView.layer.cornerRadius = 30
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.green.cgColor
        alertView.backgroundColor = .lightGray
        alertView.isHidden = true
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    
    private lazy var closeCharacterButtonCard: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
       // button.backgroundColor = .green
        button.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailButtonCard: UIButton = {
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
    
    //Burası karakter kart ekranı 57 - 197
    private let characterImageCard: UIImageView = {
        let image = UIImage(systemName: "person.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private let characterNameCard: UILabel = {
        let label = UILabel()
        label.text = "Erkan Coşar"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cizgiYatayCard: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.alpha = 0.3
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Cizgini Sol Tarafı
    
    private let hizlanmaLabelCard: UILabel = {
        let label = UILabel()
        label.text = "95 Hız"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sutLabelCard: UILabel = {
        let label = UILabel()
        label.text = "89 Şut"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pasLabelCard: UILabel = {
        let label = UILabel()
        label.text = "92 Pas"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let cizgiDikeyCard: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.3
        return view
    }()
    
    //Cizgini Sağ Tarafı


    
    private let dripplingLabelCard: UILabel = {
        let label = UILabel()
        label.text = "89 Drip"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let defLabelCard: UILabel = {
        let label = UILabel()
        label.text = "65 Def"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phyLabelCard: UILabel = {
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

        customCardView.isHidden = true
    }
    
    
    
    
    
    //Buraya kadar kart tasarımı
    
    

    
    private lazy var customSliderHizlanma: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChangedHizlanma(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    @objc func sliderValueChangedHizlanma(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
          print("\(Int(sender.value))")
        
            hizlanmaLabelSayi.text = "\(Int(sender.value))"
        
       }
    
    private lazy var customSliderSut: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChangedSut(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    
    @objc func sliderValueChangedSut(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
          print("\(Int(sender.value))")
        sutLabelSayi.text = "\(Int(sender.value))"

       }
    
    private lazy var customSliderPas: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChangedPas(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    
    @objc func sliderValueChangedPas(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
          print("\(Int(sender.value))")
          pasLabelSayi.text = "\(Int(sender.value))"

       }
    private lazy var customSliderDrib: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChangedDrib(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    
    @objc func sliderValueChangedDrib(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
          print("\(Int(sender.value))")
          dripLabelSayi.text = "\(Int(sender.value))"

       }
    private lazy var customSliderDef: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChangedDef(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    
    @objc func sliderValueChangedDef(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
        print("\(Int(sender.value))")
        defLabelSayi.text = "\(Int(sender.value))"
        
       }
    
    private lazy var customSliderPhy: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.addTarget(self, action: #selector(sliderValueChangedPhy(_:)), for: .valueChanged)
        return slider
    }()
    
    
    @objc func sliderValueChangedPhy(_ sender: Slider) {
           // Slider'ın değerini label'a yazdır
          print("\(Int(sender.value))")
          phyLabelSayi.text = "\(Int(sender.value))"
 
       }
    
  

    private let characterImageView: UIImageView = {
        let image = UIImage(systemName: "person.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let characterNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
       // textField.layer.borderWidth = 1
        textField.placeholder = "  Character Name"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let hizlanmaLabel: UILabel = {
        let label = UILabel()
        label.text = "Pace (Pac)"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let hizlanmaLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let sutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        label.text = "Shooting (SHO)"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let sutLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    private let pasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        label.text = "Passing (PAS)"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let pasLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    private let dripLabel: UILabel = {
        let label = UILabel()
        label.text = "Dribbling (DRI)"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let dripLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let defLabel: UILabel = {
        let label = UILabel()
        label.text = "Defending (DEF)"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let defLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    private let phyLabel: UILabel = {
        let label = UILabel()
        label.text = "Physical (PHY)"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private let phyLabelSayi: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
   
    
    
    private func gestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoClicked))
        characterImageView.addGestureRecognizer(gestureRecognizer)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
             view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func photoClicked(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
     }
    
    lazy var characterCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Preview Card", for: .normal)
        button.addTarget(self, action: #selector(previewCharacter), for: .touchUpInside)
        return button
    }()

    @objc private func previewCharacter() {
        
        
        if let characterName = characterNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), characterName.isEmpty {
            let alert = Alerts.shared.alertFunction(title: "Eksik Girdi", message: "Karakter ismi boş olamaz")
            present(alert, animated: true, completion: nil)
        } else{
            characterNameCard.text = characterNameTextField.text
            hizlanmaLabelCard.text = "\(Int(customSliderHizlanma.value)) " + "Pac"
            sutLabelCard.text = "\(Int(customSliderSut.value)) " + "Sht"
            pasLabelCard.text = "\(Int(customSliderPas.value)) " + "Pas"
            dripplingLabelCard.text = "\(Int(customSliderDrib.value)) " + "Drp"
            defLabelCard.text = "\(Int(customSliderDef.value)) " + "Def"
            phyLabelCard.text = "\(Int(customSliderPhy.value)) " + "Phy"
            
            
            UIView.animate(withDuration: 0.25, animations: {
                  self.customCardView.isHidden = false
                  self.customCardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
              }) { _ in
                  // Küçük ölçekleme animasyonu tamamlandığında
              
                  // Daha sonra büyük ölçekleme animasyonu ile orijinal boyuta dönmek
                  UIView.animate(withDuration: 0.25, animations: {
                      self.customCardView.transform = .identity
                  }) { _ in
                      // Animasyon tamamlandığında yapılacak işlemler (opsiyonel)
                  }
              }
            
            
        }
            
        
        
        
   

        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.isHidden = false
  
        characterNameTextField.delegate = self

        view.backgroundColor = .white
        characterImageView.layer.cornerRadius = view.frame.width/6
        addSubviews()
        addCardSubviews()
        gestureRecognizer()
        
        
        


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        
        
        fetchCharacter(tacticUUID: tacticUUIDString, characterIndex: characterIndex)
        
        
       // print(player)
        
        customSliderSetup()
       

    }
    
    private func customSliderSetup(){
        guard let player = player else{return}

        customSliderHizlanma.value = Float(player.hizlanma)
        customSliderSut.value = Float(player.sut)
        customSliderPas.value = Float(player.pas)
        customSliderDrib.value = Float(player.dribbling)
        customSliderDef.value = Float(player.defending)
        customSliderPhy.value = Float(player.physical)
        

        customSliderHizlanma.absoulouteX = Float(player.hizlanma)
        customSliderSut.absoulouteX = Float(player.sut)
        customSliderPas.absoulouteX = Float(player.pas)
        customSliderDrib.absoulouteX = Float(player.dribbling)
        customSliderDef.absoulouteX = Float(player.defending)
        customSliderPhy.absoulouteX = Float(player.physical)
        
        
        hizlanmaLabelSayi.text = "\(player.hizlanma)"
        sutLabelSayi.text = "\(player.sut)"
        pasLabelSayi.text = "\(player.pas)"
        dripLabelSayi.text = "\(player.dribbling)"
        defLabelSayi.text = "\(player.defending)"
        phyLabelSayi.text = "\(player.physical)"
    }
    
    
    private func fetchCharacter(tacticUUID: String?, characterIndex: Int?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

        guard let tacticUUIDString = tacticUUID else{return}
        guard let tacticUUID = UUID(uuidString: tacticUUIDString) else{return}
        guard let characterIndex = characterIndex else {return}
        
        let predicate = NSPredicate(format: "id == %@ AND index == %d", tacticUUID as CVarArg, characterIndex)
        fetchRequest.predicate = predicate
        
        
        do {
            guard let result = try context.fetch(fetchRequest).first as? NSManagedObject else{return}
            
        
            guard let imageData = result.value(forKey: "image") as? Data,
                  let characterName = result.value(forKey: "name") as? String,
                  let pace = result.value(forKey: "pace") as? Int16,
                  let passing = result.value(forKey: "passing") as? Int16,
                  let physical = result.value(forKey: "physical") as? Int16,
                  let shooting = result.value(forKey: "shooting") as? Int16,
                  let dribbling = result.value(forKey: "dribbling") as? Int16,
                  let defending = result.value(forKey: "defending") as? Int16
            else{
                return
            }

            player = Player(name: characterName, image: imageData, hizlanma: pace, sut: shooting, pas: passing, dribbling: dribbling, defending: defending, physical: physical)
            
            guard let player = player else{return}
            characterNameTextField.text = player.name
            characterImageView.image = UIImage(data: player.image)
            characterImageCard.image = UIImage(data: player.image)
          //  print(player)

          
        } catch {
            print("Fetch error: \(error)")
        }
        
    }
    
    
    private func saveCharacter(tacticUUID: String, characterIndex: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

        
        let predicate = NSPredicate(format: "id == %@ AND index == %d", tacticUUID as CVarArg, characterIndex)
        fetchRequest.predicate = predicate
        
        
       // guard let player = player else{return}
        
        do{
            let entities = try context.fetch(fetchRequest)
             
            if let characterToUpdate = entities.first as? NSManagedObject{
                
                guard let nameText = characterNameTextField.text, !nameText.isEmpty else{
                    alertController()
                    return
                }
                
                guard let imageData = characterImageView.image?.pngData() else {return}
                
                player = Player(name: nameText, image: imageData, hizlanma: Int16(customSliderHizlanma.value), sut: Int16(customSliderSut.value), pas: Int16(customSliderPas.value), dribbling: Int16(customSliderDrib.value), defending: Int16(customSliderDef.value), physical: Int16(customSliderPhy.value))
                
                guard let player = player else{return}
                
                
                characterToUpdate.setValue(nameText, forKey: "name")
                characterToUpdate.setValue(player.image, forKey: "image")
                characterToUpdate.setValue(player.hizlanma, forKey: "pace")
                characterToUpdate.setValue(player.sut, forKey: "shooting")
                characterToUpdate.setValue(player.pas, forKey: "passing")
                characterToUpdate.setValue(player.dribbling, forKey: "dribbling")
                characterToUpdate.setValue(player.defending, forKey: "defending")
                characterToUpdate.setValue(player.physical, forKey: "physical")
                
                
               // fetchCharacter(tacticUUID: tacticUUID, characterIndex: characterIndex)
                
                
                navigationController?.popViewController(animated: true)
                
                do {
                    try context.save()
                } catch {
                    print("Error saving changes: \(error)")
                }
                
                
            }
            
            
        }catch{
            
        }
        
        
        
      
        
        
        
        
       /* character.pace = player.hizlanma
        character.shooting = player.sut
        character.passing = player.pas
        character.dribbling = player.dribbling
        character.defending = player.defending
        character.physical = player.physical
        character.image = player.image
        character.name = player.name*/
        
       /* do{
            
            try self.context.save()
            print("Başarıyla kaydedildi")
            
            fetchCharacter(tacticUUID: tacticUUIDString, characterIndex: characterIndex)
            
        }catch{
            print("error")
        }*/
        
        
        
    }

    
    
    private func addSubviews(){
        
        
        view.addSubview(characterCardButton)
        
        
        characterCardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        characterCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
        view.addSubview(characterImageView)
        
        
        characterImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2.4).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2.4).isActive = true
        characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(characterNameTextField)
        
        characterNameTextField.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,constant: 10).isActive = true
        characterNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        characterNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        characterNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        //İlk 3

        view.addSubview(hizlanmaLabel)
        
        hizlanmaLabel.topAnchor.constraint(equalTo: characterNameTextField.bottomAnchor, constant: 10).isActive = true
        hizlanmaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        

        

        view.addSubview(hizlanmaLabelSayi)

        hizlanmaLabelSayi.topAnchor.constraint(equalTo: hizlanmaLabel.bottomAnchor, constant: 7).isActive = true
        hizlanmaLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        view.addSubview(customSliderHizlanma)
        
        customSliderHizlanma.topAnchor.constraint(equalTo: hizlanmaLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderHizlanma.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderHizlanma.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderHizlanma.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        view.addSubview(sutLabel)

        sutLabel.topAnchor.constraint(equalTo: hizlanmaLabelSayi.bottomAnchor, constant: 10).isActive = true
        sutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        view.addSubview(sutLabelSayi)

        sutLabelSayi.topAnchor.constraint(equalTo: sutLabel.bottomAnchor, constant: 7).isActive = true
        sutLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        
        view.addSubview(customSliderSut)
        
        customSliderSut.topAnchor.constraint(equalTo: sutLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderSut.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderSut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderSut.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        view.addSubview(pasLabel)
        
        pasLabel.topAnchor.constraint(equalTo: sutLabelSayi.bottomAnchor, constant: 10).isActive = true
        pasLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true

        
        view.addSubview(pasLabelSayi)
        
        pasLabelSayi.topAnchor.constraint(equalTo: pasLabel.bottomAnchor, constant: 7).isActive = true
        pasLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        
        view.addSubview(customSliderPas)
        
        customSliderPas.topAnchor.constraint(equalTo: pasLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderPas.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderPas.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderPas.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        
        //Son 3
        
        
        view.addSubview(dripLabel)
        
        dripLabel.topAnchor.constraint(equalTo: pasLabelSayi.bottomAnchor, constant: 10).isActive = true
        dripLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        


        view.addSubview(dripLabelSayi)

        dripLabelSayi.topAnchor.constraint(equalTo: dripLabel.bottomAnchor, constant: 7).isActive = true
        dripLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        view.addSubview(customSliderDrib)
        
        customSliderDrib.topAnchor.constraint(equalTo: dripLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderDrib.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderDrib.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderDrib.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        view.addSubview(defLabel)

        defLabel.topAnchor.constraint(equalTo: dripLabelSayi.bottomAnchor, constant: 10).isActive = true
        defLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        view.addSubview(defLabelSayi)

        defLabelSayi.topAnchor.constraint(equalTo: defLabel.bottomAnchor, constant: 7).isActive = true
        defLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        
        view.addSubview(customSliderDef)
        
        customSliderDef.topAnchor.constraint(equalTo: defLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderDef.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderDef.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderDef.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        view.addSubview(phyLabel)
        
        phyLabel.topAnchor.constraint(equalTo: defLabelSayi.bottomAnchor, constant: 10).isActive = true
        phyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true

        
        view.addSubview(phyLabelSayi)
        
        phyLabelSayi.topAnchor.constraint(equalTo: phyLabel.bottomAnchor, constant: 7).isActive = true
        phyLabelSayi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        
        
        view.addSubview(customSliderPhy)
        
        customSliderPhy.topAnchor.constraint(equalTo: phyLabelSayi.topAnchor,constant: -8).isActive = true
        customSliderPhy.leadingAnchor.constraint(equalTo: hizlanmaLabel.trailingAnchor, constant: 10).isActive = true
        customSliderPhy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        customSliderPhy.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        
        view.addSubview(saveButton)
        
        saveButton.topAnchor.constraint(equalTo: customSliderPhy.bottomAnchor, constant: 15).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    
    
    
    private func addCardSubviews(){
        
        
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width
        
        view.addSubview(customCardView)
        
        
        
       /* backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true*/

        
        customCardView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        customCardView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        customCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/10).isActive = true

        
        // closeCharacterButton
        customCardView.addSubview(closeCharacterButtonCard)
        
        closeCharacterButtonCard.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -5).isActive = true
        closeCharacterButtonCard.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 5).isActive = true
        closeCharacterButtonCard.widthAnchor.constraint(equalToConstant: 35).isActive = true
        closeCharacterButtonCard.heightAnchor.constraint(equalToConstant: 35).isActive = true

        // character details
        customCardView.addSubview(detailButtonCard)
        
        detailButtonCard.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 15).isActive = true
        detailButtonCard.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 15).isActive = true
        detailButtonCard.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // Character Button Image
        
        customCardView.addSubview(characterImageCard)
        
        characterImageCard.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 15).isActive = true
        characterImageCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        characterImageCard.widthAnchor.constraint(equalToConstant: view.frame.width/3.4).isActive = true
        characterImageCard.heightAnchor.constraint(equalToConstant: view.frame.width/3.2).isActive = true

        
        customCardView.addSubview(characterNameCard)
        
        characterNameCard.topAnchor.constraint(equalTo: characterImageCard.bottomAnchor, constant: 10).isActive = true
        characterNameCard.heightAnchor.constraint(equalToConstant: 35).isActive = true
        characterNameCard.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 10).isActive = true
        characterNameCard.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -10).isActive = true
        
        customCardView.addSubview(cizgiYatayCard)
        
        cizgiYatayCard.topAnchor.constraint(equalTo: characterNameCard.bottomAnchor, constant: 5).isActive = true
        cizgiYatayCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiYatayCard.heightAnchor.constraint(equalToConstant: 1).isActive = true
        cizgiYatayCard.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true

        
        customCardView.addSubview(cizgiDikeyCard)
        
        cizgiDikeyCard.topAnchor.constraint(equalTo: cizgiYatayCard.bottomAnchor, constant: 10).isActive = true
        cizgiDikeyCard.bottomAnchor.constraint(equalTo: customCardView.bottomAnchor, constant: -25).isActive = true
        cizgiDikeyCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiDikeyCard.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        customCardView.addSubview(leftStackView)
        
        leftStackView.addArrangedSubview(hizlanmaLabelCard)
        leftStackView.addArrangedSubview(sutLabelCard)
        leftStackView.addArrangedSubview(pasLabelCard)

        
        leftStackView.topAnchor.constraint(equalTo: cizgiYatayCard.bottomAnchor, constant: 0).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: cizgiDikeyCard.bottomAnchor, constant: 0).isActive = true
        leftStackView.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 10).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: cizgiDikeyCard.leadingAnchor, constant: -10).isActive = true

        
         
        customCardView.addSubview(rightStackView)
        
        rightStackView.addArrangedSubview(dripplingLabelCard)
        rightStackView.addArrangedSubview(defLabelCard)
        rightStackView.addArrangedSubview(phyLabelCard)
        
        rightStackView.topAnchor.constraint(equalTo: cizgiYatayCard.bottomAnchor, constant:  0).isActive = true
        rightStackView.leadingAnchor.constraint(equalTo: cizgiDikeyCard.trailingAnchor, constant: 10).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -10).isActive = true
        rightStackView.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor).isActive = true
     

        
    }
    
    
    
    
   

}




extension CharacterDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picker")
        if let pickedImage = info[.editedImage] as? UIImage{
            print("pciker imagegirildi")
            characterImageView.image = pickedImage
            characterImageCard.image = pickedImage
        
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
}
