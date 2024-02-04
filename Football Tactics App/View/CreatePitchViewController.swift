//
//  CreatePitchViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 4.01.2024.
//

import UIKit





class CreatePitchViewController: UIViewController, UITextFieldDelegate {
    
    let screenWidth =  UIScreen.main.bounds.size.width
    let screenHeigth =  UIScreen.main.bounds.size.height
    let isCellIdentify = false
    var tacticSize: Int = 11
    var tacticFormation: String = "4-4-2"
    var chosenPitchImage: UIImage?
    
    var selectedIndexPath: IndexPath?

    var localizedString = "en"

    
    
    var playerSize: [Int] = [5,6,7,8,9,10,11]
    var pitchTactic: [String] = ["4-4-2", "4-3-3", "4-3-2-1","3-4-3","3-5-2","5-4-1" ]
    
    var itemWidth: CGFloat{
        return screenWidth * 0.33
    }
    
    var itemHeigth: CGFloat{
        return itemWidth*1.15
    }
    
    
    var pitchImages: [UIImage] = []
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           // Klavyeyi kapat
           textField.resignFirstResponder()
           return true
       }

       func textFieldDidEndEditing(_ textField: UITextField) {
           // Başka bir yere tıklandığında klavyeyi kapat
           textField.resignFirstResponder()

               //   view.endEditing(true)
              
       }
    
    
    lazy var deleteTeamSize: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.isHidden = false
        button.addTarget(self, action: #selector(deleteClickedTeamSize), for: .touchUpInside)
        return button
        
    }()
    
    @objc func deleteClickedTeamSize(){
        
        sayiButtonClicked()
        
        
    }
    
    
    lazy var deleteFormation: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.isHidden = false
        button.addTarget(self, action: #selector(deleteClickedFormation), for: .touchUpInside)
        return button
        
    }()
    
    @objc func deleteClickedFormation(){
        
        taktikDizilisClicked()
        
        
    }
    
    
    private let tacticsView: UIView = {
        let tacticView = UIView()
        tacticView.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 30
        //tacticView.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
      //  tacticView.layer.cornerRadius = 40
        tacticView.clipsToBounds = true
        return tacticView
    }()
    
    private lazy var tacticTextField: UITextField = {
       let text = UITextField()
        text.placeholder = "Tactic Name".localizedString(str: localizedString)
        text.textAlignment = .center
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 2
        text.layer.cornerRadius = 10
        text.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        text.font = UIFont(name: "HoeflerText-Black", size: 35)
        text.translatesAutoresizingMaskIntoConstraints = false
      //  text.backgroundColor = UIColor(red: 185/255, green: 255/255, blue: 238/255, alpha: 1)
        text.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        return text
    }()
    
    private let oyuncuSayisiTableView: UITableView = {
        let tableview = UITableView()
        tableview.alpha = 1
        tableview.bounces = false
        tableview.isHidden = false
        tableview.showsVerticalScrollIndicator = false
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    lazy var oyuncuSayiLabel: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("11", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
       /* button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5*/
        
        button.addTarget(self, action: #selector(sayiButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let dizilisTableView: UITableView = {
        let tableview = UITableView()
        tableview.alpha = 1
        tableview.isHidden = false
        tableview.bounces = false
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    lazy var dizilisLabelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("4-4-2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
       /* button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5*/

        button.addTarget(self, action: #selector(taktikDizilisClicked), for: .touchUpInside)
        return button
    }()
    
    
    let oyuncuSayiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.alpha = 0
        return view
    }()
    
    
    
    let taktikDizilisView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.alpha = 0.0
        return view
    }()
    
    
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
 
      //  view.isHidden = true
        return view
    }()
    
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 172/255, green: 215/255, blue: 236/255, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(" Save Tactic ".localizedString(str: localizedString), for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func saveButtonClicked(){
        let VC = MainViewController()
      
        
      
        
        if tacticTextField.text == ""{
            let alertController = UIAlertController(title: "Alert".localizedString(str: localizedString), message: "Tactic name can not be empty.".localizedString(str: localizedString), preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            
            alertController.addAction(action)
            
            present(alertController, animated: true)
            
            
        }else if tacticTextField.text!.count > 20{
            let alertController = UIAlertController(title: "Alert", message: "Tactic Name Can Not Exceed 20 Letters".localizedString(str: localizedString), preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok".localizedString(str: localizedString), style: .cancel)
            
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        else{
            let id = UUID()
            let uuidString = id.uuidString
            VC.chosenTacticSize = tacticSize
            VC.ChosenTacticFormation = tacticFormation
            VC.uuidString = uuidString
            
            
            
            
        
            
            addTactic(uuid: id, tacticSize: tacticSize, tacticFormation: tacticFormation)
            
            
            
           //   navigationController?.popViewController(animated: true)
      //      navigationController?.pushViewController(VC, animated: true)
            
            navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    
    
    
    private func addTactic(uuid: UUID, tacticSize: Int, tacticFormation: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let newTactic = FootballTactics(context: context)
        newTactic.size = Int16(tacticSize)
        newTactic.id = uuid
        newTactic.name = tacticTextField.text
        newTactic.formation = tacticFormation
        newTactic.creationDate = Date()
        
        guard let data = self.chosenPitchImage?.pngData() as? Data else{
            return
        }
        
        newTactic.image = data
        
        
        print("id \(uuid)")
        do{
            
            try context.save()
            print("Kaydedildi")
        }catch{
            
        }
        
        
    }
    
    
    lazy var oyuncuSayiButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Team Size".localizedString(str: localizedString), for: .normal)
        button.titleLabel?.font = UIFont(name: "HoeflerText-Black", size: 21)

        
        
        
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        button.addTarget(self, action: #selector(sayiButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    @objc func sayiButtonClicked(){
        if oyuncuSayiView.isHidden{
        
           // oyuncuSayiView.isHidden = false
            blackView.isHidden = false
            
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.oyuncuSayiView.isHidden = false
                self.oyuncuSayiView.alpha = 1.0
              //  self.dizilisTableView.alpha = 0
               // self.dizilisTableView.isHidden = true
                self.blackView.alpha = 0.3
            }
            
        }else{
            print("2")

            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.oyuncuSayiView.alpha = 0.0
                self.blackView.alpha = 0.0
            } completion: { _ in
                self.oyuncuSayiView.isHidden = true
                self.blackView.isHidden = true
            }

        }
       
        
    }
    
    
    lazy var taktikDizilisButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Formation".localizedString(str: localizedString), for: .normal)
        button.titleLabel?.font = UIFont(name: "HoeflerText-Black", size: 21)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        button.addTarget(self, action: #selector(taktikDizilisClicked), for: .touchUpInside)
        return button
    }()
    
    
    @objc func taktikDizilisClicked(){
        if taktikDizilisView.isHidden{
            blackView.isHidden = false
            taktikDizilisView.isHidden = false
          //  self.blackView.alpha = 0.3
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.taktikDizilisView.alpha = 1.0
                self.blackView.alpha = 0.3

            }
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.taktikDizilisView.alpha = 0.0
                self.blackView.alpha = 0.0

            } completion: { _ in
                self.taktikDizilisView.isHidden = true
                self.blackView.isHidden = true

            }

        }
       
        
    }
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    let blackView: UIView = {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.0
        blackView.isHidden = true
        blackView.translatesAutoresizingMaskIntoConstraints = false
        return blackView
    }()
    
    var screenRatio: CGFloat = 0.0
   
    var backButtonHides = false
    

    override func viewWillAppear(_ animated: Bool) {
        
    
        
    
        
        
            
        print(backButtonHides)
        
        //Geri gitmeyi engelliyor
       /* if let kaydedilmisBoolValue = UserDefaults.standard.value(forKey: "boolAnahtar") as? Bool {
            print("Kaydedilmiş Boolean Değer: \(kaydedilmisBoolValue)")
            
            
            if kaydedilmisBoolValue{
                navigationItem.hidesBackButton = true
                UserDefaults.standard.set(false, forKey: "boolAnahtar")
            }else{
                navigationItem.hidesBackButton = false

            }
            
            
        }*/
        
        
      
    
        
        
    }
    
    
    
    func languageChanged() {
        // Dil değiştiğinde yapılacak işlemleri burada gerçekleştir
        //updateTextsForCurrentLanguage()
        print("Değişti")
        view.setNeedsLayout()
        

        guard let languageString = UserDefaults.standard.string(forKey: "language") else{return}
        
        
        
        
 
        
        
     /*   tacticTextField.placeholder = "Tactic Name".localizedString(str: languageString)
        oyuncuSayiButton.setTitle("Team Size".localizedString(str: languageString), for: .normal)
        saveButton.setTitle(" Save Tactic ".localizedString(str: languageString), for: .normal)
        labelSayiView.text = "Team Size".localizedString(str: languageString)
        labelTaktikView.text = "Tactic Formation".localizedString(str: languageString)*/
        

        

    }
    
    
    func hideKeyboardWhenTappedAround() {
           let tapGesture = UITapGestureRecognizer(target: self,
                            action: #selector(hideKeyboard))
           view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false

       }

    @objc func hideKeyboard() {
        
        
    
        view.endEditing(true)
        
        
    }
    
    @objc func hideTableViews() {
        
        
        
        if oyuncuSayiView.isHidden == false{
            sayiButtonClicked()

        }else if taktikDizilisView.isHidden == false{
            taktikDizilisClicked()
        }
    
        
       // taktikDizilisClicked()
        
        
    }
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        hideKeyboardWhenTappedAround()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                         action: #selector(hideTableViews))
        
        blackView.addGestureRecognizer(gestureRecognizer)
        
        
   
        overrideUserInterfaceStyle = .light

        tacticTextField.delegate = self
        
        
        chosenPitchImage = UIImage(named: "2")

        localizedString = UserDefaults.standard.string(forKey: "language")!
        
        tacticTextField.placeholder = "Tactic Name".localizedString(str: localizedString)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back".localizedString(str: localizedString)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        /*  UIColor(red: 186/255, green: 193/255, blue: 184/255, alpha: 1)
        UIColor(red: 88/255, green: 164/255, blue: 176/255, alpha: 1)
         UIColor(red: 181/255, green: 210/255, blue: 203/255, alpha: 1)
         UIColor(red: 168/255, green: 174/255, blue: 193/255, alpha: 1)
         */
        
        screenRatio = view.frame.size.width/view.frame.size.height
        
        if let pitch2 = UIImage(named: "2"),
           let pitch3 = UIImage(named: "3"),
           let pitch4 = UIImage(named: "4"),
           let pitch5 = UIImage(named: "5"),
           let pitch6 = UIImage(named: "6"),
           let pitch7 = UIImage(named: "7"),
           let pitch8 = UIImage(named: "8"),
           let pitch9 = UIImage(named: "9"){
            pitchImages = [pitch2, pitch3, pitch4, pitch5, pitch6, pitch7, pitch8, pitch9]
        }else{
            return
        }
        
        
        
     //   view.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        view.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
      
        
        viewSetup()
        
        
        view.addSubview(tacticsView)
       // tacticsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        tacticsView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        tacticsView.topAnchor.constraint(equalTo: oyuncuSayiLabel.bottomAnchor, constant: 25).isActive = true
      //  tacticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tacticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tacticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: tacticsView.bottomAnchor, constant: 15).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
       // saveButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
        
     
        
        
        

        
       
        
        view.addSubview(blackView)
        
        blackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
        sayiVeDizilisViewSetup()
        oyuncuSayiTableViewSetup()
        taktikDizilisTableViewSetup()
        
        collectionViewSetUp()

        languageChanged()


    }
    
    
    func sayiVeDizilisViewSetup(){
        view.addSubview(oyuncuSayiView)
        view.addSubview(taktikDizilisView)
        
        
        oyuncuSayiView.heightAnchor.constraint(equalToConstant: view.frame.size.height/2).isActive = true
        oyuncuSayiView.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        oyuncuSayiView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        oyuncuSayiView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        
        taktikDizilisView.heightAnchor.constraint(equalToConstant: view.frame.size.height/2).isActive = true
        taktikDizilisView.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        taktikDizilisView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        taktikDizilisView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    let labelSayiView = UILabel()
    
    func oyuncuSayiTableViewSetup(){
        
        //SayiButton
       // view.addSubview(oyuncuSayiButton)
       /* oyuncuSayiButton.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiButton.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/

        //OyuncuSayiTableView
        
        
        
        
    
        labelSayiView.translatesAutoresizingMaskIntoConstraints = false
        labelSayiView.text = "Team Size".localizedString(str: localizedString)
        labelSayiView.textAlignment = .center
        labelSayiView.backgroundColor = .lightGray
        
        oyuncuSayiView.addSubview(labelSayiView)
        
        oyuncuSayiView.addSubview(deleteTeamSize)
        
        
        oyuncuSayiView.addSubview(oyuncuSayisiTableView)
        oyuncuSayiView.backgroundColor = .clear
        
        
        
        oyuncuSayisiTableView.delegate = self
        oyuncuSayisiTableView.dataSource = self
        oyuncuSayisiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "oyuncuSayiCell")
        oyuncuSayiView.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
        
        //DeleteMark
        deleteTeamSize.topAnchor.constraint(equalTo: oyuncuSayiView.topAnchor).isActive = true
        deleteTeamSize.trailingAnchor.constraint(equalTo: oyuncuSayiView.trailingAnchor).isActive = true
        deleteTeamSize.heightAnchor.constraint(equalToConstant: 35).isActive = true
        deleteTeamSize.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        labelSayiView.leadingAnchor.constraint(equalTo: oyuncuSayiView.leadingAnchor, constant: 0).isActive = true
        labelSayiView.trailingAnchor.constraint(equalTo: oyuncuSayiView.trailingAnchor, constant: 0).isActive = true
        labelSayiView.topAnchor.constraint(equalTo: deleteTeamSize.topAnchor, constant: 0).isActive = true
        labelSayiView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    

        
        oyuncuSayisiTableView.topAnchor.constraint(equalTo: labelSayiView.bottomAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.leadingAnchor.constraint(equalTo: oyuncuSayiView.leadingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.trailingAnchor.constraint(equalTo: oyuncuSayiView.trailingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.bottomAnchor.constraint(equalTo: oyuncuSayiView.bottomAnchor, constant: 0).isActive = true
        
        
        

    }
    
    
    let labelTaktikView = UILabel()

    
    func taktikDizilisTableViewSetup(){
        
        //SayiButton
       // view.addSubview(oyuncuSayiButton)
       /* oyuncuSayiButton.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiButton.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/

        //OyuncuSayiTableView
        taktikDizilisView.addSubview(dizilisTableView)
        dizilisTableView.backgroundColor = .clear
        labelTaktikView.backgroundColor = .lightGray
        labelTaktikView.textAlignment = .center
        labelTaktikView.translatesAutoresizingMaskIntoConstraints = false
        labelTaktikView.text = "Tactic Formation".localizedString(str: localizedString)
        
        
        dizilisTableView.delegate = self
        dizilisTableView.dataSource = self
        dizilisTableView.register(UITableViewCell.self, forCellReuseIdentifier: "taktikDizilisCell")
        
        
        taktikDizilisView.addSubview(labelTaktikView)
        taktikDizilisView.addSubview(deleteFormation)
        
        
        deleteFormation.topAnchor.constraint(equalTo: taktikDizilisView.topAnchor, constant: -3).isActive = true
        deleteFormation.trailingAnchor.constraint(equalTo: taktikDizilisView.trailingAnchor, constant: 3).isActive = true
        deleteFormation.heightAnchor.constraint(equalToConstant: 35).isActive = true
        deleteFormation.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        labelTaktikView.leadingAnchor.constraint(equalTo: taktikDizilisView.leadingAnchor, constant: 0).isActive = true
        labelTaktikView.trailingAnchor.constraint(equalTo: taktikDizilisView.trailingAnchor, constant: 0).isActive = true
        labelTaktikView.topAnchor.constraint(equalTo: taktikDizilisView.topAnchor, constant: 0).isActive = true
        labelTaktikView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        
        
        taktikDizilisView.addSubview(dizilisTableView)
        dizilisTableView.topAnchor.constraint(equalTo: labelTaktikView.bottomAnchor, constant: 0).isActive = true
        dizilisTableView.leadingAnchor.constraint(equalTo: taktikDizilisView.leadingAnchor, constant: 0).isActive = true
        dizilisTableView.trailingAnchor.constraint(equalTo: taktikDizilisView.trailingAnchor, constant: 0).isActive = true
        dizilisTableView.bottomAnchor.constraint(equalTo: taktikDizilisView.bottomAnchor, constant: 0).isActive = true

        
      
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func viewSetup(){
        
        //TacticField
        view.addSubview(tacticTextField)
        tacticTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tacticTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tacticTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tacticTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        //oyuncuSayisiTableView.separatorStyle = .none
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(oyuncuSayiButton)
        buttonsStackView.addArrangedSubview(taktikDizilisButton)
        
        buttonsStackView.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 20).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 0).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 0).isActive = true
        
        
        view.addSubview(oyuncuSayiLabel)
        oyuncuSayiLabel.topAnchor.constraint(equalTo: oyuncuSayiButton.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiLabel.leadingAnchor.constraint(equalTo: oyuncuSayiButton.leadingAnchor, constant: 20).isActive = true
        oyuncuSayiLabel.trailingAnchor.constraint(equalTo: oyuncuSayiButton.trailingAnchor, constant: -20).isActive = true
        oyuncuSayiLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(dizilisLabelButton)
        
        dizilisLabelButton.topAnchor.constraint(equalTo: taktikDizilisButton.bottomAnchor, constant: 10).isActive = true
        dizilisLabelButton.leadingAnchor.constraint(equalTo: taktikDizilisButton.leadingAnchor, constant: 20).isActive = true
        dizilisLabelButton.trailingAnchor.constraint(equalTo: taktikDizilisButton.trailingAnchor, constant: -20).isActive = true
        dizilisLabelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        
        
    }
    
    let layout = CustomLayout()

    
    func collectionViewSetUp(){
        collectionView.dragInteractionEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .normal
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        collectionView.register(PitchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        tacticsView.addSubview(collectionView)
        
       /* collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.itemSize.width = itemWidth*/
        collectionView.clipsToBounds = true
        collectionView.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: 0).isActive = true
       // collectionView.centerYAnchor.constraint(equalTo: tacticsView.centerYAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        collectionView.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionView.backgroundColor = .clear
        //tacticsView.backgroundColor = .red
       /* let tacticalFieldsLabel = UILabel()
        tacticalFieldsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tacticalFieldsLabel)
        tacticalFieldsLabel.text = "Tactical Fields"
        tacticalFieldsLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        tacticalFieldsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tacticalFieldsLabel.bottomAnchor.constraint(equalTo: tacticsView.topAnchor, constant: view.frame.size.width / 35).isActive = true*/
        
        
    }
    

  

}


extension CreatePitchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pitchImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PitchCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.pitchImageView.image = pitchImages[indexPath.row]
        cell.contentView.backgroundColor = .gray
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.clipsToBounds = true
        cell.clipsToBounds = true
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if screenRatio > 0.5{
            
            return CGSize(width: itemWidth - 15, height: itemWidth)
            
        }else{
            return CGSize(width: itemWidth, height: itemHeigth)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == layout.currentPage{
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
            self.chosenPitchImage = pitchImages[indexPath.row]
        }else{
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
            
            self.chosenPitchImage = pitchImages[indexPath.row]
            print(chosenPitchImage)
        }
        
        
            selectedIndexPath = indexPath

           // Tüm hücreleri döngü ile kontrol et
        for i in 0..<collectionView.numberOfItems(inSection: selectedIndexPath!.section) {
               // Her hücreyi al
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: selectedIndexPath!.section)) as? PitchCollectionViewCell {
                   // Seçilen hücre ise deleteTacticButton.isHidden'i false yap, aksi takdirde true yap
                
                cell.contentView.layer.borderWidth = (i == selectedIndexPath!.item) ? 1.5 : 2
                cell.contentView.layer.borderColor = (i == selectedIndexPath!.item) ? UIColor.black.cgColor : UIColor.gray.cgColor
                
           //     cell.deleteTacticButton.isHidden = (i == selectedIndexPath!.item) ? false : true
               }
           }
        
    }
    
    
}



extension CreatePitchViewController{
    
    
   /* func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        <#code#>
    }*/
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate{
            setupCell()
        }
    }
    
    func setupCell(){
        let indexPath = IndexPath(item: layout.currentPage, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath){
            transformCell(cell)
        }
        
    }
    
    
    func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true){
        if !isEffect{
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            print("girdi1")

            return
        }
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            print("girdi2")
        }
        
        for otherCell in collectionView.visibleCells{
            
            if let indexPath = collectionView.indexPath(for: otherCell){
                if indexPath.item != layout.currentPage{
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                        print(indexPath)
                        print("girdi3")

                    }
                }
            }
        }
        
    }
    
}




extension CreatePitchViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /* let cell = tableView.dequeueReusableCell(withIdentifier: "oyuncuSayiCell", for: indexPath)
        cell.textLabel?.text = "Erkan"
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        return cell*/
        
        
        
        switch tableView{
        case oyuncuSayisiTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "oyuncuSayiCell", for: indexPath)
             cell.textLabel?.text = "\(playerSize[indexPath.row])"
             cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
             return cell
        
        case dizilisTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taktikDizilisCell", for: indexPath)
            cell.textLabel?.text = (pitchTactic[indexPath.row])
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
            
        case oyuncuSayisiTableView:
            return playerSize.count
            
        case dizilisTableView:
            return pitchTactic.count

            
        default:
            return 0
            
        }
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView{
            
        case oyuncuSayisiTableView:
            sayiButtonClicked()
            self.tacticSize = playerSize[indexPath.row]
            oyuncuSayiLabel.setTitle("\(playerSize[indexPath.row])", for: .normal)
            tableView.deselectRow(at: indexPath, animated: true)

        case dizilisTableView:
            taktikDizilisClicked()
            self.tacticFormation = pitchTactic[indexPath.row]
            dizilisLabelButton.setTitle("\(pitchTactic[indexPath.row])", for: .normal)
            tableView.deselectRow(at: indexPath, animated: true)

            
        default:
            break
            
        }
        
    }
    
    
    
    
}
