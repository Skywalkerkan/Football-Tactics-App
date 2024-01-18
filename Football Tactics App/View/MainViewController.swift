//
//  ViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 26.12.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    
    
    var player: Player? = nil
    var characterIndex = 0
    var playerViews: [UIView] = []

    var uuidLists: [UUID] = []
    
    var uniqueUUIDs: [UUID] = []

    var uuidString: String = ""{
        didSet{
           // print("uuid \(uuidString)")
        }
    }
    var characterID = ""
    
    
    var chosenTacticSize: Int = 11
    var ChosenTacticFormation: String = "4-4-2"
    
    var allTactics: [FootballTactics] = []
    var chosenTactic: Tactic?
    
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
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
                
        
        let CharacterDetailVC = CharacterDetailViewController()
        CharacterDetailVC.characterIndex = characterIndex
        CharacterDetailVC.tacticUUIDString = uuidString
        
        
        navigationController?.pushViewController(CharacterDetailVC, animated: true)
        
    }
    
    //Burası karakter kart ekranı 57 - 197
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
    
    //Buraya kadar
    
    private let backgroundImageView: UIImageView = {
        let image = UIImage(named: "pitch")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tacticsView: UIView = {
        let tacticView = UIView()
        tacticView.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 30
        //tacticView.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        tacticView.layer.cornerRadius = 30
        tacticView.clipsToBounds = true
        tacticView.backgroundColor = .lightGray

        tacticView.layer.shadowColor = UIColor.black.cgColor
        tacticView.layer.shadowRadius = 10
        tacticView.layer.borderColor = UIColor.black.cgColor
        tacticView.layer.borderWidth = 2
       // tacticView.layer.shadowOffset = 5
      //  tacticView.isHidden = true
        tacticView.layer.shadowOpacity = 0.3
        return tacticView
    }()
    
    
    
    let numberOfImageViews = 11 // İhtiyacınıza göre sayıyı değiştirin
    var imageViews = [UIImageView]()
    
    var imageIDs = [String]() // Farklı ID'leri tutan dizi

    var chosenLine = "4 4 2"

    override func viewWillAppear(_ animated: Bool) {
        
     //   super.viewWillAppear(animated)
        
      /*  let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        layout.currentPage = indexPath.item
        layout.previousOffset = layout.updateOffset(collectionView)
        
        if let cell = collectionView.cellForItem(at: indexPath){
            transformCell(cell)
        }*/
        
     //   print("aaa")
        
        for playerView in playerViews {
            playerView.removeFromSuperview()
        }

        // Dizi içindeki tüm view'leri temizle
        playerViews.removeAll()
        createPlayers()
        
        addSubviews()

        
      //  loadPlayerPositions()
        print("oluşturulacak uuid tactic\(uuidString)")
        predicateById(uuidString: uuidString)
        
        
      //  uniqueuuids()

        
        
    }
    
  /*  override func viewDidAppear(_ animated: Bool) {
        
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        layout.currentPage = indexPath.item
        layout.previousOffset = layout.updateOffset(collectionView)
        
        if let cell = collectionView.cellForItem(at: indexPath){
            transformCell(cell)
        }
    }*/
    
    
    func tableViewRegister(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        //tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    let screenWidth =  UIScreen.main.bounds.size.width
    let screenHeigth =  UIScreen.main.bounds.size.height
    
    var itemWidth: CGFloat{
        return screenWidth * 0.33
    }
    
    var itemHeigth: CGFloat{
        return itemWidth
    }
    
    func collectionViewSetUp(){
        collectionView.dragInteractionEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .normal
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(PitchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = true
        tacticsView.addSubview(collectionView)
        //tacticsView.backgroundColor = .blue
        collectionView.backgroundColor = .clear
        
       // collectionView.collectionViewLayout = layout
       /* layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.itemSize.width = itemWidth*/
        
        collectionView.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: 0).isActive = true
       // collectionView.centerYAnchor.constraint(equalTo: tacticsView.centerYAnchor).isActive = true
        //collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        collectionView.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15).isActive = true
        
        
    }

    
    
    
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    
    
    let layout = CustomLayout()

    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true

      //  view.isHidden = true
        return view
    }()
    
    
   /* let characterLabel: UILabel = {
      let label = UILabel()
        label.text = "aa"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()*/
    
    let newTacticView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.isHidden = true
        return view
    }()
    
    lazy var addTacticButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        button.setTitle("Ekle", for: .normal)
        return button
    }()
    
    @objc func addButtonClick(){
        
        //İlk önce tüm oyuncuları kaldır
       /* for playerView in playerViews {
            playerView.removeFromSuperview()
        }

        // Dizi içindeki tüm view'leri temizle
        playerViews.removeAll()
        
        
        createPlayers()
        savePlayerPositions()
      //  loadPlayerPositions()
        predicateById(uuidString: uuidString)
        
        uniqueuuids()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }*/
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //Tactic Eklemeye yeri
    @objc func addNewTactic(){
        newTacticView.isHidden = false
    }
    
    
    @objc func settingsButtonClicked(){
        
    }
    
    var footballPitchBasildiMi: Bool = false
    
    lazy var footballPitchImage: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 107/255, green: 142/255, blue: 65/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(clickedFootballPitch), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedFootballPitch(){
        
        if footballPitchBasildiMi{
            
            footballPitchImage.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 107/255, green: 142/255, blue: 65/255, alpha: 1)), for: .normal)
            
        }else{
            footballPitchImage.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        }
            
        
        self.footballPitchBasildiMi = !footballPitchBasildiMi
        
    
        
        
    }
    
    
    lazy var repeatTacticFormationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "repeat.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 107/255, green: 142/255, blue: 65/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(clickedRepeatFormation), for: .touchUpInside)
        return button
    }()
    
    
    @objc func clickedRepeatFormation(){
    
            
     
    
        
        
    }
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  firstView.isHidden = false
        
        view.addSubview(firstView)
        firstView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        firstView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        firstView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true*/
        
        
        
        
        view.backgroundColor = .white
        

        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTactic))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(settingsButtonClicked))

        view.addSubview(backgroundImageView)
        
       


   
     //   collectionViewSetUp()
        
        //Tactic Oluşturma Penceresi
        view.addSubview(newTacticView)
        newTacticView.addSubview(addTacticButton)
        newTacticView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        newTacticView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        newTacticView.widthAnchor.constraint(equalToConstant: 250).isActive = true
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTactic))
        
        //Unique uuidleri bulma
        uniqueuuids()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        
        tableViewRegister()

        

        
        //Oyuncularn oluşumu buraya sayı verebiliriz!!!
        createPlayers()
        
        
        //Uygulamanın ilk kez açıldığının kontrolü
     /*   let isFirstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
               // Eğer uygulama ilk kez açılıyorsa
        if !isFirstLaunch {
            // İlk kez açılıyormuş gibi işlemler
            //İlk kez girilmişse uygulamada oluşturulan viewlerin konumlarının kaydedilmesi
            savePlayerPositions()
            uniqueuuids()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }*/
        
        savePlayerPositions()
        uniqueuuids()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        
        
        
      //  loadPlayerPositions()
        
        
        
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            guard let result = results.first as? NSManagedObject else{return}
            guard let uuid = result.value(forKey: "id") as? UUID else {return}
        
            self.uuidString = uuid.uuidString
            
        } catch  {
            print(error.localizedDescription)
        }*/
        
        
       // addSubviews()
        

        
        
        view.addSubview(tacticsView)
        tacticsView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4 + 40).isActive = true
        tacticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40).isActive = true
        tacticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tacticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
       
       
        
        view.addSubview(footballPitchImage)
        footballPitchImage.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        footballPitchImage.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 25).isActive = true
        footballPitchImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        footballPitchImage.widthAnchor.constraint(equalToConstant: 30).isActive = true

        
        view.addSubview(repeatTacticFormationButton)
        repeatTacticFormationButton.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        repeatTacticFormationButton.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: -25).isActive = true
        repeatTacticFormationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repeatTacticFormationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
        collectionViewSetUp()
       
        
        backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: tacticsView.topAnchor, constant: -view.frame.size.height/40).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
    }
    
    
    
    //Kaç tane oyuncunun oluşturulduğu
    func createPlayers() {
            var numberY = 60
            var numberX = 0
            var katsayi = 1
            var eklenenX = 30
        
        var playerWidthHeigth = view.frame.size.width/6
        
        print("\(view.frame.size.width/6)")

        var numberYKaleci = 0.75*view.frame.size.height - view.frame.size.height/7
        
  
        // 4 - 4 - 2
            for i in 0..<11 {
      
                var playerView: UIView = UIView()
                
                playerView.backgroundColor = .red
                playerView.translatesAutoresizingMaskIntoConstraints = false
                
                
                if i == 0{
                    playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 32.5), y: Int(numberYKaleci), width: 65, height: 65))

                }
                else if i > 0 && i < 5{
                    if i == 1{
                        eklenenX = Int(view.frame.size.width / 10)
                    }
                    numberY = Int(view.frame.size.height/2)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 80
                }
                else if i >= 5 && i < 9{
                    if i == 5{
                        eklenenX = Int(view.frame.size.width / 10)
                    }
                    numberY = Int(view.frame.size.height/3)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 80
                }
                else{
                    if i == 9{
                        eklenenX = Int(view.frame.width/2 - 75)
                    }
                    numberY = Int(view.frame.size.height/5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 80
                }
        
        
        // 4 - 3 - 3
           /* for i in 0..<11 {
         
                   var playerView: UIView = UIView()
                   
                   playerView.backgroundColor = .red
                   playerView.translatesAutoresizingMaskIntoConstraints = false
                   
                   
                   if i == 0{
                       playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 32.5), y: Int(numberYKaleci), width: 65, height: 65))

                   }
                   else if i > 0 && i < 5{
                       if i == 1{
                           eklenenX = Int(view.frame.size.width / 10)
                       }
                       numberY = Int(view.frame.size.height/2)
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += 80
                   }
                   else if i >= 5 && i < 8{
                       if i == 5{
                           eklenenX = Int(view.frame.size.width / 3 - 65)
                       }
                       numberY = Int(view.frame.size.height/3)
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += Int(view.frame.size.width) / 4

                       
                   }
                   else{
                       if i == 8{
                           eklenenX = Int(view.frame.size.width / 3 - 65)
                       }
                       
                       numberY = Int(view.frame.size.height/5)

                       if i == 9{
                           numberY = Int(view.frame.size.height/5.5)

                       }
                       
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += Int(view.frame.size.width) / 4
                   }*/
        
        
        //4 - 3 - 2 - 1
        /*
            for i in 0..<11 {
      
                var playerView: UIView = UIView()
                
                playerView.backgroundColor = .red
                playerView.translatesAutoresizingMaskIntoConstraints = false
                
                
                if i == 0{
                    playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 32.5), y: Int(numberYKaleci), width: 65, height: 65))

                }
                else if i > 0 && i < 5{
                    if i == 1{
                        eklenenX = Int(view.frame.size.width / 10)
                    }
                    numberY = Int(view.frame.size.height/2)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 80
                }
                else if i >= 5 && i < 8{
                    if i == 5{
                        eklenenX = Int(view.frame.size.width / 5)
                    }
                    numberY = Int(view.frame.size.height/2.5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 85
                }
                else if i >= 8 && i < 10{
                    if i == 8{
                        eklenenX = Int(view.frame.width/2 - 90)
                    }
                    numberY = Int(view.frame.size.height/3.5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                    eklenenX += 120
                    
                    
                }else{
                    numberY = Int(view.frame.size.height/4.2)
                    eklenenX = Int(view.frame.width/2 - 32.5)

                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))

                    
                    
                }*/
        // 3 - 5 - 2
           /* for i in 0..<11 {
        
                  var playerView: UIView = UIView()
                  
                  playerView.backgroundColor = .red
                  playerView.translatesAutoresizingMaskIntoConstraints = false
                  
                  
                  if i == 0{
                      playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 32.5), y: Int(numberYKaleci), width: 65, height: 65))

                  }
                  else if i > 0 && i < 4{
                      if i == 1{
                          eklenenX = Int(view.frame.size.width / 3 - 65)
                      }
                      numberY = Int(view.frame.size.height/2)
                      playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                      eklenenX += Int(view.frame.size.width) / 4
                  }else if i == 4{
                      
                      eklenenX = Int(view.frame.size.width / 2 - 32.5)
                  
                      numberY = Int(view.frame.size.height/2.5 - 10)
                      playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                  }
                  else if i >= 5 && i < 9{
                     
                      numberY = Int(view.frame.size.height/3.5)
                      if i == 5{
                          eklenenX = Int(view.frame.size.width / 10)
                          numberY = Int(view.frame.size.height/3.2)
                      }
                      
                      if i == 8{
                          numberY = Int(view.frame.size.height/3.2)
                      }
                      
                      playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                      eklenenX += 80
                      
                      
                  }
                  else{
                      if i == 9{
                          eklenenX = Int(view.frame.width/2 - 75)
                      }
                      numberY = Int(view.frame.size.height/6)
                      playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                      eklenenX += 80
                  }*/
        
            // 3 - 4 - 3
         /*   for i in 0..<11 {
         
                   var playerView: UIView = UIView()
                   
                   playerView.backgroundColor = .red
                   playerView.translatesAutoresizingMaskIntoConstraints = false
                   
                   
                   if i == 0{
                       playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 32.5), y: Int(numberYKaleci), width: 65, height: 65))

                   }
                   else if i > 0 && i < 4{
                       if i == 1{
                           eklenenX = Int(view.frame.size.width / 3 - 65)
                       }
                       numberY = Int(view.frame.size.height/2.05)
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += Int(view.frame.size.width) / 4
                   }
                   else if i >= 4 && i < 8{
                      
                       numberY = Int(view.frame.size.height/3.2)
                       if i == 4{
                           eklenenX = Int(view.frame.size.width / 10)
                           numberY = Int(view.frame.size.height/3)
                       }
                       
                       if i == 7{
                           numberY = Int(view.frame.size.height/3)
                       }
                       
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += 80
                       
                       
                   }
                   else{
                       if i == 8{
                           eklenenX = Int(view.frame.size.width / 3 - 65)
                       }
                       numberY = Int(view.frame.size.height/6)
                       if i == 9{
                           numberY = Int(view.frame.size.height/7)
                       }
                       playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 65, height: 65))
                       eklenenX += Int(view.frame.size.width) / 4

                       
                       
                     
                       
                   }
            */
            
        
        
                
              /*  if i == 0{
                    playerView = UIView(frame: CGRect(x: Int((view.frame.size.width)/2 - 37.5), y: numberY, width: 75, height: 75))
                }else if i > 0 && i < 5{
                    numberY = Int(view.frame.size.height/5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 75, height: 75))
                    eklenenX += 80
                }else if i >= 5 && i < 9{
                    if i == 5{
                        eklenenX = 30
                    }
                    numberY = Int(view.frame.size.height/2-37.5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 75, height: 75))
                    eklenenX += 80
                }else{
                    if i == 9{
                        eklenenX = Int(view.frame.width/2 - 75)
                    }
                    numberY = Int(view.frame.size.height/1.5)
                    playerView = UIView(frame: CGRect(x: eklenenX, y: numberY, width: 75, height: 75))
                    eklenenX += 80
                }*/
                
                
               // playerView.backgroundColor = UIColor.blue

                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                playerView.addGestureRecognizer(panGesture)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                playerView.addGestureRecognizer(tapGesture)
                
                let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                longTapGesture.minimumPressDuration = 0.75
                playerView.addGestureRecognizer(longTapGesture)
                
                playerViews.append(playerView)
                view.addSubview(playerView)
               // playerView.addSubview(characterLabel)
               // numberX += 1
                
            }
        }
    
    
    var isAnimating = false
    @objc func longHandleTap(_ gestureRecognizer: UILongPressGestureRecognizer){
        
        guard let longTappedView = gestureRecognizer.view else{return}
        
        guard let index = self.playerViews.firstIndex(of: longTappedView) else{
            return
        }
        
        characterIndex = index
        
        let playerViewcik = playerViews[index]
        
        if gestureRecognizer.state == .began && !isAnimating {
            // Uzun basma başladığında yapılacak işlemler
            isAnimating = true
            print("Uzun basma başladı!")
        
            fetchCharacter(tacticUUID: uuidString, characterIndex: index)
            
            
            UIView.animate(withDuration: 0.5, animations: {
                // Küçültme animasyonunu
                playerViewcik.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                // Animasyon tamamlandığında yapılacak işlemler
                //self.isAnimating = false
                self.customAlertView.isHidden = false
            }
            
        }
        else if gestureRecognizer.state == .ended {
            if let index = playerViews.firstIndex(of: longTappedView){
                print("LongPressedIndex \(index)")
                
                UIView.animate(withDuration: 0.5, animations: {
                    // Küçültme animasyonunu
                    playerViewcik.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) { _ in
                    // Animasyon tamamlandığında yapılacak işlemler
                    self.isAnimating = false
                  //  playerViewcik.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
              
            }
            print("Uzun basma sona erdi!")
        }
        
        
        
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
                  let playerName = result.value(forKey: "name") as? String,
                  let pace = result.value(forKey: "pace") as? Int16,
                  let passing = result.value(forKey: "passing") as? Int16,
                  let physical = result.value(forKey: "physical") as? Int16,
                  let shooting = result.value(forKey: "shooting") as? Int16,
                  let dribbling = result.value(forKey: "dribbling") as? Int16,
                  let defending = result.value(forKey: "defending") as? Int16
            else{
                return
            }

            player = Player(name: playerName, image: imageData, hizlanma: pace, sut: shooting, pas: passing, dribbling: dribbling, defending: defending, physical: physical)
            
            guard let player = player else{return}
            /*characterNameTextField.text = player.name
            characterImageView.image = UIImage(data: player.image)
            characterImageCard.image = UIImage(data: player.image)*/
            print(player)
            
            
            hizlanmaLabel.text = "\(player.hizlanma)" + " Pac"
            sutLabel.text = "\(player.sut)" + " Sht"
            pasLabel.text = "\(player.pas)" + " Pac"
            dripplingLabel.text = "\(player.dribbling)" + " Drp"
            defLabel.text = "\(player.defending)" + " Def"
            phyLabel.text = "\(player.physical)" + " Phy"
            
            characterImage.image = UIImage(data: player.image)
            
            characterName.text = player.name


          
        } catch {
            print("Fetch error: \(error)")
        }
        
    }
    
    
    
    
    
    
    // Bir kere basma halinde
    @objc func handleTap(_ gestureRecognizer: UIPanGestureRecognizer) {

        guard let tappedView = gestureRecognizer.view else { return }

           // Tıklanan oyuncu görünümünün index'ini bulma
           if let index = playerViews.firstIndex(of: tappedView) {
               print("Tapped player index: \(index)")
               
               
               let CharacterDetailVC = CharacterDetailViewController()
               CharacterDetailVC.characterIndex = index
               CharacterDetailVC.tacticUUIDString = uuidString
               navigationController?.pushViewController(CharacterDetailVC, animated: true)
               
              // predicateById(uuidString: uuidString)
              // predicateAndUploadByIdIndex(uuidString: uuidString, index: index)
               
           }
        
            
        
        
       }
    
    
    
    //Basılı tutma halinde sürükleme işlemleri
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
           guard let playerView = gestureRecognizer.view else { return }

           let translation = gestureRecognizer.translation(in: view)
           playerView.center = CGPoint(x: playerView.center.x + translation.x, y: playerView.center.y + translation.y)
           gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        
        
        
      
        if gestureRecognizer.state == .ended{
            
            if let index = playerViews.firstIndex(of: playerView) {
                print("Tapped player index: \(index) Panned : \(uuidString)")
                
                print(uuidString, index)
               // predicateById(uuidString: uuidString)
               // predicateAndUploadByIdIndex(uuidString: uuidString, index: index)
                predicateAndUploadByIdIndex(uuidString: uuidString, index: index)

            }

               // Burada oyuncu konumunu hafızaya kaydedebilirsiniz.
                //savePlayerPositions()
        }
        
        
            
        
        

        // Örneğin: UserDefaults, veritabanı veya başka bir depolama mekanizması kullanabilirsiniz.
       }
    
    
    
    //Uygulama ilk kez çalıştığında ya da bir sayfa eklendiğinde bu çalıştırılacak ve güncel verileri id üzerinden kaydedecek
    func savePlayerPositions() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            print("idye kaydedilece \(uuidString)")
            let id = UUID(uuidString: uuidString)
            //let idString = self.uuidString
            // Clear existing data
        //    deleteAllPlayerPositions()

        guard let imageData = UIImage(named: "forma")?.pngData() else{return}
        let characterName = "Adı"
        
        
        //İndexleriyle ve idleriyle x ve y konumlarıyla beraber kaydetme
            for (index, playerView) in playerViews.enumerated() {
                let entity = NSEntityDescription.entity(forEntityName: "PlayerPosition", in: managedContext)!
                let playerPosition = NSManagedObject(entity: entity, insertInto: managedContext)

                let position = playerView.center
                
                playerPosition.setValue(id, forKey: "id")
                playerPosition.setValue(index, forKey: "index")
                playerPosition.setValue(position.x, forKey: "x")
                playerPosition.setValue(position.y, forKey: "y")
                playerPosition.setValue(characterName, forKey: "name")
                playerPosition.setValue(imageData, forKey: "image")
                
                //Oyuncu Özellikleri
                playerPosition.setValue(50, forKey: "defending")
                playerPosition.setValue(50, forKey: "dribbling")
                playerPosition.setValue(50, forKey: "physical")
                playerPosition.setValue(50, forKey: "pace")
                playerPosition.setValue(50, forKey: "shooting")
                playerPosition.setValue(50, forKey: "passing")


            }

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    

        func loadPlayerPositions() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

            do {
                let results = try managedContext.fetch(fetchRequest)
              //  print(results)
                for case let result as NSManagedObject in results {
                    if let index = result.value(forKey: "index") as? Int,
                       let x = result.value(forKey: "x") as? CGFloat,
                       let y = result.value(forKey: "y") as? CGFloat,
                       let id = result.value(forKey: "id") as? UUID,
                       let uuidString = id.uuidString as? String,
                       let characterName = result.value(forKey: "name") as? String,
                       let imageData = result.value(forKey: "image") as? Data,
                       
                        
                       
                        
                       index < playerViews.count {
                        
                       // print(characterName, index)
                        
                        
                        let characterLabel: UILabel = {
                           let label = UILabel()
                            label.textAlignment = .center
                            label.translatesAutoresizingMaskIntoConstraints = false
                            return label
                        }()
                        
                        let characterImage: UIImageView = {
                           let imageView = UIImageView(image: UIImage(named: "forma"))
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.contentMode = .scaleAspectFill
                            imageView.clipsToBounds = true
                          //  imageView.layer.cornerRadius = 50
                            return imageView
                        }()
                        
                        
                      //  let characterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                        characterLabel.text = "Adı"
                        let playerView = playerViews[index]
                        playerView.backgroundColor = .red
                        playerView.addSubview(characterImage)
                        playerView.addSubview(characterLabel)

                        playerView.center = CGPoint(x: x, y: y)
                        
                        //Label Layout
                        characterImage.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
                        characterImage.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
                        characterImage.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                        characterImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
                        //characterImage.widthAnchor.constraint(equalToConstant: 50).isActive = true

                        
                        characterLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor).isActive = true
                        characterLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
                        characterLabel.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                        
                        
                        characterLabel.text = characterName
                        characterImage.image = UIImage(data: imageData)
                        
                        self.uuidString = uuidString
                        
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }

        func deleteAllPlayerPositions() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

            do {
                let results = try managedContext.fetch(fetchRequest)
                for case let result as NSManagedObject in results {
                    managedContext.delete(result)
                }
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    
    
    
    func predicateAndUploadByIdIndex(uuidString: String, index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PlayerPosition> = PlayerPosition.fetchRequest()

        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        
        let predicate = NSPredicate(format: "id == %@ AND index == %d", uuid as CVarArg, index)
        fetchRequest.predicate = predicate
        
        
        
        do {
            if let existingPlayerPosition = try managedContext.fetch(fetchRequest).first {
                // Güncelleme işlemini gerçekleştir
             //   print(existingPlayerPosition)
                let position = playerViews[index].center
                existingPlayerPosition.setValue(position.x, forKey: "x")
                existingPlayerPosition.setValue(position.y, forKey: "y")
            } else {
                // Belirtilen ID ve index'e sahip öğe bulunamazsa buraya düşer
                print("PlayerPosition not found for the given ID and index.")
            }
        } catch {
            print("Fetch error: \(error)")
        }
        
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    
    func predicateById(uuidString: String){
        //print("gelen id \(uuidString)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")
        
        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", "\(uuid)")

        fetchRequest.predicate = predicate
        
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let result as NSManagedObject in results {
                if let index = result.value(forKey: "index") as? Int,
                   let x = result.value(forKey: "x") as? CGFloat,
                   let y = result.value(forKey: "y") as? CGFloat,
                   let id = result.value(forKey: "id") as? UUID,
                   let uuidString = id.uuidString as? String,
                   let imageData = result.value(forKey: "image") as? Data,
                   let characterName = result.value(forKey: "name") as? String,
                 //  let tacticName = result.value(forKey: "tacticname") as? String,
                   
                    
                    index < playerViews.count {
                    
                   // let characterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                  //  print(characterName)

               //     title = tacticName
                    
                    let characterLabel: UILabel = {
                       let label = UILabel()
                        label.textAlignment = .center
                        label.translatesAutoresizingMaskIntoConstraints = false
                        return label
                    }()
                    
                    let characterImage: UIImageView = {
                       let imageView = UIImageView(image: UIImage(named: "forma"))
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        imageView.contentMode = .scaleAspectFill
                        imageView.clipsToBounds = true
                        imageView.layer.cornerRadius = 20
                        return imageView
                    }()
                    
                    let characterNumber: UILabel = {
                        let label = UILabel()
                        label.text = "33"
                        label.textAlignment = .center
                        label.translatesAutoresizingMaskIntoConstraints = false
                        label.layer.cornerRadius = 13
                        label.layer.borderWidth = 2
                        label.font = UIFont.systemFont(ofSize: 13, weight: .black)
                        label.backgroundColor = .lightGray
                        label.clipsToBounds = true
                        label.layer.borderColor = UIColor.black.cgColor
                        return label
                    }()
                    
                   // characterLabel.text = "Oyuncu Adı"
                    characterLabel.text = characterName
                    characterImage.image = UIImage(data: imageData)
                    let playerView = playerViews[index]
                    playerView.addSubview(characterImage)
                    playerView.addSubview(characterLabel)
                    playerView.addSubview(characterNumber)

                    playerView.center = CGPoint(x: x, y: y)
                    
                    //Label Layout
                    characterImage.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
                    characterImage.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
                    characterImage.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                    characterImage.heightAnchor.constraint(equalToConstant: 65).isActive = true
                    characterImage.widthAnchor.constraint(equalToConstant: 65).isActive = true

                    
                    characterLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: -5).isActive = true
                    characterLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
                    characterLabel.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                    
                    characterNumber.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                    characterNumber.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
                    characterNumber.widthAnchor.constraint(equalToConstant: 26).isActive = true
                    characterNumber.heightAnchor.constraint(equalToConstant: 26).isActive = true

                    

                    
                    //print("\(index): \(x), \(y), \(uuidString)")
                    
                    self.uuidString = uuidString
                    
                }
                
            }
        }catch{
            
        }

    }
    
    
    ///Unique UUIDLERİ BUL GETİR tableViewde göster
    func uniqueuuids() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        // NSFetchRequest oluştur
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")

        do {
            // Fetch işlemi gerçekleştir
            let results = try managedContext.fetch(fetchRequest)

            // Farklı UUID'leri bulmak için bir dizi oluştur
            var uniqueUUIDsSet = Set<UUID>()
            
            allTactics.removeAll()
            for result in results {
                if let footballTactics = result as? FootballTactics, let uuid = footballTactics.id {
                    uniqueUUIDsSet.insert(uuid)
                    allTactics.append(footballTactics)
                    
                }
            }
            
            print("all tacticler \(allTactics.count)")
            
            uniqueUUIDs = Array(uniqueUUIDsSet)
            
            guard let imageData = allTactics.last?.image as? Data else{
                return
                
            }
            DispatchQueue.main.async {
                self.backgroundImageView.image = UIImage(data: imageData)

            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            // Farklı UUID'leri yazdır
           // print("Farklı UUID Sayısı: \(uniqueUUIDs.count)")
            for uniqueUUID in uniqueUUIDs {
                print("UUID: \(uniqueUUID)")
            }

        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    
    
    func fetchTactics(uuidString: String){
        
        guard let uuid = UUID(uuidString: uuidString) else{return}
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")
        let predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        request.predicate = predicate
        
        
        do{
            let results = try context.fetch(request)
            
            guard let result = results.first as? NSManagedObject else{return}
            
           guard let id = result.value(forKey: "id") as? UUID,
            let formation = result.value(forKey: "formation") as? String,
            let name = result.value(forKey: "name") as? String,
                 let size = result.value(forKey: "size") as? Int else{return}

            
            chosenTactic = Tactic(id: id, formation: formation, name: name, size: size)
            
            print(chosenTactic)
            
        }catch{
            
        }
        
        
        
    }
    
    
    
    
    
    
    
   /* func dizilisOlustur(){
        
        
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
                 
            imageView.backgroundColor = .white
            imageView.frame.size = CGSize(width: 50, height: 50)
                 
            // let randomX = CGFloat.random(in: 0...(view.frame.width - imageView.frame.width))
            //  let randomY = CGFloat.random(in: 0...(view.frame.height - imageView.frame.height))
            
            
                // 4 4 2 düzeni
                
                var xPoints = frameWidth/4 - frameWidth/7 + x + 5
                var yPoints = frameHeight - frameHeight/3 - y
                
            
            
                if chosenLine == "4 4 2"{
                    
                    if index == 0{
                        xPoints = frameWidth/2 - 25
                        yPoints = frameHeight - 100
                    }
                    else if index == 1{
                        x = 0
                         xPoints = frameWidth/4 - frameWidth/7 + x + 5
                         yPoints = frameHeight - frameHeight/3 - y
                    }
                    
                    else if index == 5 {
                        
                        imageView.backgroundColor = .red
                        x = 0
                        y = frameHeight/4.7
                        xPoints = frameWidth/4 - frameWidth/7 + x + 5
                        yPoints = frameHeight - frameHeight/3 - y
                      //  yPoints = frameHeight - 200
                    }else if index == 9{
                        x = 0
                        y = frameHeight / 2.5
                        xPoints = frameWidth/2 + x + 25
                        yPoints = frameHeight - frameHeight/3 - y
                    }
                    }
            
            
              
                
               
                 
                 imageView.frame.origin = CGPoint(x: xPoints, y: yPoints)
                 
                let imageID = generateUniqueID()
                imageIDs.append(imageID)
                imageView.tag = index

            
            
                x += frameWidth/4.7
                //y += 100
            
                 // Gesture Recognizer ekle
                 let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 imageView.addGestureRecognizer(panGesture)
                 imageView.isUserInteractionEnabled = true
                 
            
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                
            imageView.addGestureRecognizer(tapGesture)
            
                 view.addSubview(imageView)
                 imageViews.append(imageView)
             }
    }*/
    
    /*func generateUniqueID() -> String {
          return UUID().uuidString
      }
      
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        guard let tappedImageView = gesture.view as? UIImageView else { return }
        let index = tappedImageView.tag
        let imageID = imageIDs[index]
        
        print(index)
        
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
    */
    
    
    
    
    private func addSubviews(){
        
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width
        
        view.addSubview(customAlertView)
        
        
      /*  backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true*/

        
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




extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueUUIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.isUserInteractionEnabled = true
        cell.backgroundColor = .red
        cell.textLabel?.text = uniqueUUIDs[indexPath.row].uuidString
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuidString = uniqueUUIDs[indexPath.row].uuidString
      //  print(uuidString)
        for playerView in playerViews {
            playerView.removeFromSuperview()
        }

        // Dizi içindeki tüm view'leri temizle
        playerViews.removeAll()
        createPlayers()
        
        predicateById(uuidString: uuidString)

        
    }
    
    
    
}







extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTactics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PitchCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = .gray
        cell.contentView.clipsToBounds = true
        cell.clipsToBounds = true
        
        cell.tacticNameLabel.text = allTactics[indexPath.row].name
        cell.pitchNameLabel.text = allTactics[indexPath.row].formation
        if let imageData = allTactics[indexPath.row].image {
            
            DispatchQueue.main.async {
                cell.pitchImageView.image = UIImage(data: imageData)
                
            }
           } else {
               // Handle the case when image data is nil (optional Data is nil)
               // You might want to set a placeholder image or handle it differently
               cell.pitchImageView.image = UIImage(named: "2")
           }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3.3, height: itemHeigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uuidString = uniqueUUIDs[indexPath.row].uuidString
        print(uuidString)
        for playerView in playerViews {
            playerView.removeFromSuperview()
        }

        // Dizi içindeki tüm view'leri temizle
        playerViews.removeAll()
        createPlayers()
        
        addSubviews()
        
        predicateById(uuidString: uuidString)
        
        fetchTactics(uuidString: uuidString)
        
        if let imageData = allTactics[indexPath.row].image{
            DispatchQueue.main.async {
                self.backgroundImageView.image = UIImage(data: imageData)

            }
        }else{
            
            DispatchQueue.main.async {
                self.backgroundImageView.image = UIImage(named: "2")

            }

        }
        
        
        if indexPath.item == layout.currentPage{
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
        }else{
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
        }
    }
    
    

    
    
    
}



extension MainViewController{
    
    
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
            return
        }
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        for otherCell in collectionView.visibleCells{
            
            if let indexPath = collectionView.indexPath(for: otherCell){
                if indexPath.item != layout.currentPage{
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
        
    }
    
}


