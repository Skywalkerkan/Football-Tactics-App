//
//  CharacterDetailViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 27.12.2023.
//

import UIKit
import CoreData

class CharacterDetailViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    
  //  let character: [Person]? = nil
    
    
    private func addCharacter(){
        
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
        
        

    }
    
    
    
    func alertController(){
        
        let alertController = UIAlertController(title: "Error", message: "You entered imcomplete info", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(action)
        
        present(alertController, animated: true)
        
        
    }
    
    private func fetchCharacter(){
        
        do{
            
            let results = try context.fetch(Person.fetchRequest())
            
            if results.count > 0{
                
                for result in results as [NSManagedObject]{
    
                    print(result)
                    
                }
                
            }
            
        }catch{
            print("HATALANDIK")
            
        }
        
    }
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc private func saveButtonClicked(){
        addCharacter()
    }
    

    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.isHidden = false
  
        characterNameTextField.delegate = self

        view.backgroundColor = .white
        characterImageView.layer.cornerRadius = view.frame.width/6
        addSubviews()
        
        gestureRecognizer()
        
        
        


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false

    }
    

    
    
    private func addSubviews(){
        
        
        view.addSubview(saveButton)
        
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
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
        
        
        
    }
   

}




extension CharacterDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picker")
        if let pickedImage = info[.editedImage] as? UIImage{
            print("pciker imagegirildi")
            characterImageView.image = pickedImage
        
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
}
