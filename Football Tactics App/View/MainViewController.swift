//
//  ViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 26.12.2023.
//

import UIKit
import CoreData
import SideMenu

class MainViewController: UIViewController, YourCollectionViewCellDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    
    
    func deleteButtonClicked(in cell: PitchCollectionViewCell) {
            // Burada CollectionViewCell'den gelen olayı işleyebilirsiniz.
        if let indexPath = collectionViewTactics.indexPath(for: cell) {
            let deletedTactic = allTactics[indexPath.row]
            
            print("Delete \(deletedTactic.name)")
            
            print("Delete button clicked in cell at index \(indexPath.row)")
            print("Deleted Tactic ID: \(deletedTactic.id)")
            
            resetCellStates()

            
            guard let uuid = deletedTactic.id else{return}
            deleteSelectedPlayerPositions(id: uuid)
            deleteSelectedTactic(id: uuid)
            
            uniqueuuids()
            
            DispatchQueue.main.async {
                self.collectionViewTactics.reloadData()
                
            }
            
            if allTactics.count == 0{
                
                let boolValueToSave = true
                UserDefaults.standard.set(boolValueToSave, forKey: "boolAnahtar")
                
                
                self.navigationController?.pushViewController(CreatePitchViewController(), animated: true)
                
            }
            
            else{
                collectionViewTactics.selectItem(at: IndexPath(item: indexPath.row, section: 0), animated: true, scrollPosition: .centeredVertically)
                
                let uuidString = uniqueUUIDs.first?.uuidString
                print(uuidString)
                for playerView in playerViews {
                    playerView.removeFromSuperview()
                }
                
                // Dizi içindeki tüm view'leri temizle
                playerViews.removeAll()
                
                // uniqueuuids()
                
                chosenTacticSize = Int(allTactics.first!.size)
                ChosenTacticFormation = (allTactics.first?.formation)!
                
                
                createPlayers(tacticSize: chosenTacticSize)
                
             //   addSubviews()
                
                predicateById(uuidString: uuidString!)
                
                
                if let imageData = allTactics.first!.image{
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(data: imageData)
                        
                        
                    }
                    
                    
                }else{
                    
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = UIImage(named: "2")
                        
                    }
                    
                }
                
                
                
                
                
                // Silme işlemini gerçekleştir
            }
        }
        
        }
    

    var selectedPlayerIndex: Int = 0
    
    var menu: SideMenuNavigationController?
    
    var player: Player? = nil
    
    var characters: [Player] = []
    
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
    var ChosenTacticFormation: String = "4-3-2-1"
    
    var allTactics: [FootballTactics] = []
    var chosenTactic: Tactic?
    
    
    
    let selectedCharacterView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 40
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.isHidden = true
        return view
    }()
    
    
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
        
        selectedCharacterCardIndex = characterIndex
        selectedCharacterUUIDString = uuidString
        
        
        navigationController?.pushViewController(CharacterDetailVC, animated: true)
        
    }
    
    var selectedCharacterCardIndex = 0
    var selectedCharacterUUIDString = ""

    
    //Burası karakter kart ekranı 57 - 197
    private let characterImage: UIImageView = {
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
        
       // self.customCardView.transform = .identity

        customCardView.isHidden = true
    }
    
    private let customCardView: UIView = {
        let alertView = UIView()
      //  alertView.layer.cornerRadius = 30
     //   alertView.layer.borderWidth = 1
      //  alertView.layer.borderColor = UIColor.green.cgColor
       // alertView.backgroundColor = .lightGray
        alertView.isHidden = true
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    
    //Buraya kadar
    
    private let backgroundImageView: UIImageView = {
        let image = UIImage(named: "4")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var noDataLabel: UILabel = {
       let label = UILabel()
        label.text = "There is no tactic saved".localizedString(str: localizedString)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var goToAddTacticButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Add Tactic", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
       // button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .black)
        //button.setImage(UIImage(systemName: "doc.fill.badge.plus"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "doc.fill.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        return button
    }()
    
    
    lazy var noPlayerLabel: UILabel = {
       let label = UILabel()
        label.text = "There is no player saved".localizedString(str: localizedString)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var goToAddCreateCharacterButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Add Tactic", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
       // button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .black)
        //button.setImage(UIImage(systemName: "doc.fill.badge.plus"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "person.fill.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addTarget(self, action: #selector(clickedCharacterAdd), for: .touchUpInside)
        return button
    }()

    
    
    private let tacticsView: UIView = {
        let tacticView = UIView()
        tacticView.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 30
        //tacticView.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        tacticView.layer.cornerRadius = 30
        tacticView.clipsToBounds = true
        tacticView.backgroundColor = .clear

        tacticView.layer.shadowColor = UIColor.lightGray.cgColor
        tacticView.layer.shadowRadius = 5
        tacticView.layer.borderColor = UIColor.black.cgColor
        tacticView.layer.borderWidth = 2
      //  tacticView.isHidden = true
        tacticView.layer.shadowOpacity = 0.65
        return tacticView
    }()
    
    
    
    let numberOfImageViews = 11 // İhtiyacınıza göre sayıyı değiştirin
    var imageViews = [UIImageView]()
    
    var imageIDs = [String]() // Farklı ID'leri tutan dizi

    var chosenLine = "4 4 2"
    
    var degisiklikOlduMu = false
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           print("Değişiklik oldu!")
        
           // degisiklikOlduMu = true
            
     
        
       }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        // Sadece ekleme durumu için işlem yapın
        if type == .insert {
            print("Ekleme yapıldı: \(anObject)")
            degisiklikOlduMu = true
            characterIndex = 0

        }
    }
    
    func resetCellStates() {
          // collectionView'da bulunan tüm hücreleri sıfırla
        if let selectedIndexPath = selectedIndexPath {
               for i in 0..<collectionViewTactics.numberOfItems(inSection: selectedIndexPath.section) {
                   if let cell = collectionViewTactics.cellForItem(at: IndexPath(item: i, section: selectedIndexPath.section)) as? PitchCollectionViewCell {
                       // Seçilen hücre değilse deleteTacticButton.isHidden'i true yap
                       cell.deleteTacticButton.isHidden = true
                       
                       cell.contentView.layer.borderWidth = (i == selectedIndexPath.item) ? 1.5 : 2
                       cell.contentView.layer.borderColor = (i == selectedIndexPath.item) ? UIColor.black.cgColor : UIColor.gray.cgColor
                       cell.transform = .identity
                   }
               }
           }
      }

  
    

    override func viewWillAppear(_ animated: Bool) {
        print("ViewwillappearBaşladı")
        //   super.viewWillAppear(animated)
        
        /*  let indexPath = IndexPath(item: 1, section: 0)
         collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
         
         layout.currentPage = indexPath.item
         layout.previousOffset = layout.updateOffset(collectionView)
         
         if let cell = collectionView.cellForItem(at: indexPath){
         transformCell(cell)
         }*/
        
        
        //   print("aaa")
        
        characterIndex = 0

        resetCellStates()
        
        
        
        
        fetchCharacter(tacticUUID: selectedCharacterUUIDString, characterIndex: selectedCharacterCardIndex)
        
        
        // uniqueuuids()
        
        
        print("selected \(selectedCharacterCardIndex), \(selectedCharacterUUIDString)")
        
        
        fetchAllCharacters()
        
        DispatchQueue.main.async {
            self.collectionViewPlayers.reloadData()
        }
        
        DispatchQueue.main.async {
            self.collectionViewTactics.reloadData()
        }
        
        
        
        for playerView in playerViews {
            playerView.removeFromSuperview()
        }
        
        print(playerViews.count)
        
        
        // Dizi içindeki tüm view'leri temizle
        playerViews.removeAll()
        
        
        print(playerViews.count)
        
        // uniqueuuids()
        print("İlk uuid String")
        uniqueuuids()
        
        createPlayers(tacticSize: chosenTacticSize)
        
        print("Değişiklik = \(degisiklikOlduMu)")
        
        if degisiklikOlduMu == true{
            print("Değişiklik olmuş")
            uniqueuuids()
            savePlayerPositions()
            degisiklikOlduMu = false
        }
        
        
        
        // savePlayerPositions()
        
        
        // savePlayerPositions()
        print(playerViews.count)
        
        // addSubviews()
        
        print(playerViews.count)
        
        //  loadPlayerPositions()
        print("oluşturulacak uuid tactic\(uuidString)")
        predicateById(uuidString: uuidString)
        
        
        
        //  uniqueuuids()
        
        addSubviews()
        
        view.addSubview(selectedCharacterView)
        
        
        print(playersImageBasildiMi)
        print(footballPitchBasildiMi)

        if playersImageBasildiMi && footballPitchBasildiMi{
            if characters.count == 0{
                noDataLabel.isHidden = true
                goToAddTacticButton.isHidden = true
                noPlayerLabel.isHidden = false
                goToAddCreateCharacterButton.isHidden = false
            }else{
                noPlayerLabel.isHidden = true
                goToAddCreateCharacterButton.isHidden = true
            }
        }
        
        else{
            if allTactics.count == 0{
                noDataLabel.isHidden = false
                goToAddTacticButton.isHidden = false
            }else{
                noDataLabel.isHidden = true
                goToAddTacticButton.isHidden = true
            }
        }
       
       
                
                
                
     
        print(characterIndex)

       
        
        
        
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
    
    var screenRatio = 0.0
    

    
    var itemWidth: CGFloat{
        return screenWidth * 0.33
    }
    
    var itemHeigth: CGFloat{
        return itemWidth
    }
    
    func collectionViewSetUp(){
        collectionViewTactics.dragInteractionEnabled = false
        collectionViewTactics.backgroundColor = .clear
        collectionViewTactics.decelerationRate = .normal
        collectionViewTactics.contentInsetAdjustmentBehavior = .never
        collectionViewTactics.showsHorizontalScrollIndicator = false
        collectionViewTactics.showsVerticalScrollIndicator = false
        collectionViewTactics.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionViewTactics.register(PitchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewTactics.dataSource = self
        collectionViewTactics.delegate = self
        collectionViewTactics.clipsToBounds = true
        tacticsView.addSubview(collectionViewTactics)
        //tacticsView.backgroundColor = .blue
        collectionViewTactics.backgroundColor = .clear
        
       // collectionView.collectionViewLayout = layout
       /* layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.itemSize.width = itemWidth*/
        
       // let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
      //  collectionView.addGestureRecognizer(longPressGesture)
        
        
        collectionViewTactics.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 0).isActive = true
        collectionViewTactics.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: 0).isActive = true
       // collectionView.centerYAnchor.constraint(equalTo: tacticsView.centerYAnchor).isActive = true
        //collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        collectionViewTactics.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionViewTactics.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
       // collectionViewTactics.backgroundColor = .red
        
        
    }
    
    
    func collectionViewPlayerSetUp(){

        collectionViewPlayers.dragInteractionEnabled = false
        collectionViewPlayers.backgroundColor = .clear
        collectionViewPlayers.decelerationRate = .normal
        collectionViewPlayers.contentInsetAdjustmentBehavior = .never
        collectionViewPlayers.showsHorizontalScrollIndicator = false
        collectionViewPlayers.showsVerticalScrollIndicator = false
        collectionViewPlayers.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionViewPlayers.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        collectionViewPlayers.dataSource = self
        collectionViewPlayers.delegate = self
        collectionViewPlayers.clipsToBounds = true
        tacticsView.addSubview(collectionViewPlayers)
        //tacticsView.backgroundColor = .blue
        collectionViewPlayers.backgroundColor = .clear
        
       // collectionView.collectionViewLayout = layout
       /* layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.itemSize.width = itemWidth*/
        
       // let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
      //  collectionView.addGestureRecognizer(longPressGesture)
        
        
        collectionViewPlayers.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 0).isActive = true
        collectionViewPlayers.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: 0).isActive = true
       // collectionView.centerYAnchor.constraint(equalTo: tacticsView.centerYAnchor).isActive = true
        //collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        collectionViewPlayers.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionViewPlayers.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
        
    }
    
    
    var selectedIndexPath: IndexPath? // Animasyonu uygulanan hücrenin indeksi

    var shakingIndexPath: IndexPath? // Animasyonu uygulanan hücrenin indeksi
    var selectedIndexPaths: Set<IndexPath> = Set() // Seçilen hücrelerin indeksleri
  //  var selectedIndexPath: IndexPath?
    
    func stopAllAnimations() {
        for cell in collectionViewTactics.visibleCells {
            // Animasyonları durdur
                cell.transform = .identity
        }
        
        // Başka animasyonları durdurmak için gerekirse burada ilave işlemleri yapabilirsiniz.
        
        // shakingIndexPath'yi sıfırla
        shakingIndexPath = nil
        
        
        print("sonlandı")
        
        
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
           let point = gestureRecognizer.location(in: collectionViewTactics)
          // stopAllAnimations()
           switch gestureRecognizer.state {
           case .began:
               // Uzun basma noktasındaki hücrenin indeksini al
               if let indexPath = collectionViewTactics.indexPathForItem(at: point) {
                   // Seçilen hücrenin indeksini ekleyin
                   selectedIndexPaths.insert(indexPath)
                   
                   startShakingAnimation(indexPath: indexPath)
               }
           case .ended, .cancelled:
               // Uzun basma sona erdiğinde veya iptal edildiğinde animasyonları durdur
              // stopShakingAnimation()
               print("sonlanıyor")
              // stopAllAnimations()

           default:
               break
           }
       }
       
     
       
    func startShakingAnimation(indexPath: IndexPath) {
        // Başka bir hücre seçildiğinde mevcut animasyonu durdur
        stopShakingAnimation()

        // Yeni hücreye ait animasyonu başlat
       /* collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        layout.currentPage = indexPath.item
        layout.previousOffset = layout.updateOffset(collectionView)
        setupCell()*/
        

        
        if selectedIndexPath == indexPath{
            UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat], animations: {
                if let cell = self.collectionViewTactics.cellForItem(at: indexPath) {
                    cell.transform = CGAffineTransform(translationX: 5, y: 0).concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
                }
            }, completion: nil)

        }else{
            UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat], animations: {
                if let cell = self.collectionViewTactics.cellForItem(at: indexPath) {
                    cell.transform = CGAffineTransform(translationX: 5, y: 0)
                }
            }, completion: nil)

        }
        

       
        // Animasyonu uygulanan hücrenin indeksini güncelle
        shakingIndexPath = indexPath
    }

    func stopShakingAnimation() {
        print("Durdurulacak")
        // Eğer bir hücre titriyorsa, animasyonu durdur
        if let indexPath = shakingIndexPath {
            if let cell = collectionViewTactics.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                    print("Durdurulacak \(indexPath.item)")

                }
            }
            shakingIndexPath = nil
        }
    }

    // Başka bir hücre seçildiğinde bu fonksiyonu çağırabilirsiniz.
    func didSelectAnotherCell() {
        // Mevcut animasyonu durdur
        stopShakingAnimation()
        // Diğer işlemleri buraya ekleyin
    }
   

    
    
    let langugaesTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
       // tableView.isHidden = true
        tableView.backgroundColor = .red
        return tableView
    }()
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    
    
    let layout = CustomLayout()

    
    let collectionViewTactics: UICollectionView = {
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
    
    let collectionViewPlayers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
      //  view.backgroundColor = .red
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isHidden = true

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
        
        navigationController?.pushViewController(CreatePitchViewController(), animated: true)

     //   navigationController?.popViewController(animated: true)
        
    }
    
    //Tactic Eklemeye yeri
    @objc func addNewTactic(){
        newTacticView.isHidden = false
    }
    
    
    @objc func settingsButtonClicked(){
        present(menu!, animated: true)
    }
    
    var footballPitchBasildiMi: Bool = true
    lazy var footballPitchImage: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addTarget(self, action: #selector(clickedFootballPitch), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedFootballPitch(){
        
        if playersImageBasildiMi{
            
            
            
            if footballPitchBasildiMi{
                playersImageButton.setBackgroundImage(UIImage(systemName: "person.2.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
                footballPitchImage.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
                footballPitchBasildiMi = true
                playersImageBasildiMi = false
                collectionViewTactics.isHidden = false
                collectionViewPlayers.isHidden = true
                
                
                if allTactics.count == 0{
                    noDataLabel.isHidden = false
                    goToAddTacticButton.isHidden = false
                    
                    
                    
                }
                
                for player in playerViews{
                    
                    player.layer.cornerRadius = 0
                    player.layer.borderColor = UIColor.clear.cgColor
                    player.layer.borderWidth = 0
                    
                }
                
         
                
                noPlayerLabel.isHidden = true
                goToAddCreateCharacterButton.isHidden = true

                print("sol")
                
            }
        }
            
        
        //self.footballPitchBasildiMi = !footballPitchBasildiMi
        
    
        
        
    }
    
    var playersImageBasildiMi: Bool = false

    
    lazy var playersImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "person.2.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickedplayersImageButton), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedplayersImageButton(){
        
        
        if footballPitchBasildiMi{
            
            
            if playersImageBasildiMi == false{
                playersImageButton.setBackgroundImage(UIImage(systemName: "person.2.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
                footballPitchImage.setBackgroundImage(UIImage(systemName: "sportscourt.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
                playersImageBasildiMi = true
                collectionViewTactics.isHidden = true
                collectionViewPlayers.isHidden = false
                print("sağ")
            
                
                
                if characters.count != 0 && allTactics.count != 0{
                    
                    playerViews[characterIndex].layer.cornerRadius = 15
                    playerViews[characterIndex].layer.borderWidth = 3
                    playerViews[characterIndex].layer.borderColor = UIColor.white.cgColor
                }
                
             
                
              
                
                
                noDataLabel.isHidden = true
                goToAddTacticButton.isHidden = true
                
           
                
                
                if characters.count == 0{
                    noPlayerLabel.isHidden = false
                    goToAddCreateCharacterButton.isHidden = false
                }
                
                

            }
        }
        
       // self.playersImageBasildiMi = !playersImageBasildiMi

    
        
        
    }
    
    lazy var characterAddButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "person.crop.circle.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 188/255, green: 236/255, blue: 100/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(clickedCharacterAdd), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedCharacterAdd(){
        navigationController?.pushViewController(CreateCharacterViewController(), animated: true)
    }
    
    
    
    lazy var repeatTacticFormationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "trash.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 247/255, green: 40/255, blue: 73/255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(clickedRepeatFormation), for: .touchUpInside)
        return button
    }()
    
    
    @objc func clickedRepeatFormation(){
    
            
        let alertController = UIAlertController(title: "Warning".localized(), message: "Are you sure that you want to delete all tactics ?".localizedString(str: localizedString), preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes".localizedString(str: localizedString), style: .cancel){_ in
            
        /*    for playerView in self.playerViews {
                playerView.removeFromSuperview()
            }

            // Dizi içindeki tüm view'leri temizle
            self.playerViews.removeAll()
            
            
            
            
            
            self.createPlayers(tacticSize: self.chosenTacticSize)
            
            for i in self.playerViews{
                print(i.frame)
            }
            
            self.savePlayerPositions()

            for playerView in self.playerViews {
                playerView.removeFromSuperview()
            }

            
            self.predicateById(uuidString: self.uuidString)*/
            
            
            self.deleteAllTactics()
            self.deleteAllPlayerPositions()
            

            let boolValueToSave = true
            UserDefaults.standard.set(boolValueToSave, forKey: "boolAnahtar")
            
            
            self.navigationController?.pushViewController(CreatePitchViewController(), animated: true)
            
        }
        
        let noAction = UIAlertAction(title: "No".localizedString(str: localizedString), style: .destructive)

        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
     
    
        present(alertController, animated: true)
        
    }
    
    let iconeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "icone")
        imageView.image = image
        return imageView
    }()

    
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
    
    
    
    func fetchAllCharacters(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        request.returnsObjectsAsFaults = false
        
        characters.removeAll()
        
        
        do{
            let results = try context.fetch(request)
            
            guard let results = results as? [NSManagedObject] else {return}
            
            for result in results{
                
             //   print(result)
                
                guard let imageData = result.value(forKey: "image") as? Data,
                      let playerName = result.value(forKey: "name") as? String,
                      let pace = result.value(forKey: "pace") as? Int16,
                     // let no = result.value(forKey: "no") as? String,
                      let passing = result.value(forKey: "passing") as? Int16,
                      let physical = result.value(forKey: "physical") as? Int16,
                      let shooting = result.value(forKey: "shooting") as? Int16,
                      let dribbling = result.value(forKey: "dribbling") as? Int16,
                      let defending = result.value(forKey: "defending") as? Int16,
                      let playerNo = result.value(forKey: "no") as? String

                
                else{
                    return
                }
                
                
                let player = Player(name: playerName, image: imageData, hizlanma: pace, sut: shooting, pas: passing, dribbling: dribbling, defending: defending, physical: physical, playerNo: playerNo)
            
                characters.append(player)
                
            }
            
            
        }catch{
            
        }
        
    }
    
    
    @objc func languageChanged() {
        // Dil değiştiğinde yapılacak işlemleri burada gerçekleştir
        //updateTextsForCurrentLanguage()
        print("Değişti")
        view.setNeedsLayout()
        

        localizedString = UserDefaults.standard.string(forKey: "language")!
        noDataLabel.text = "There is no tactic saved".localizedString(str: localizedString)
        navigationItem.leftBarButtonItem?.title = "Add Tactic".localizedString(str: localizedString)

        
        let language1 = UserDefaults.standard.string(forKey: "language")!

        print("Language 1 \(language1)")

    
        

    }
    
    
    var localizedString = "en"


    func addSubviewsNoData(){
        view.addSubview(noDataLabel)
        view.addSubview(goToAddTacticButton)
        noDataLabel.centerXAnchor.constraint(equalTo: tacticsView.centerXAnchor).isActive = true
        noDataLabel.topAnchor.constraint(equalTo: footballPitchImage.bottomAnchor, constant: 25).isActive = true
        
        goToAddTacticButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 5).isActive = true
        goToAddTacticButton.centerXAnchor.constraint(equalTo: tacticsView.centerXAnchor).isActive = true
        goToAddTacticButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        goToAddTacticButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        

        
        view.addSubview(noPlayerLabel)
        view.addSubview(goToAddCreateCharacterButton)
        noPlayerLabel.centerXAnchor.constraint(equalTo: tacticsView.centerXAnchor).isActive = true
        noPlayerLabel.topAnchor.constraint(equalTo: footballPitchImage.bottomAnchor, constant: 25).isActive = true
        
        goToAddCreateCharacterButton.topAnchor.constraint(equalTo: noPlayerLabel.bottomAnchor, constant: 5).isActive = true
        goToAddCreateCharacterButton.centerXAnchor.constraint(equalTo: tacticsView.centerXAnchor).isActive = true
        goToAddCreateCharacterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        goToAddCreateCharacterButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name("LanguageChangedNotification"), object: nil)

        
        if let stringLanguage = UserDefaults.standard.string(forKey: "language"){
            localizedString = stringLanguage
        }else{
            localizedString = "en"
            UserDefaults.standard.setValue("en", forKey: "language")
        }
   
        
      /*  firstView.isHidden = false
        
        view.addSubview(firstView)
        firstView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        firstView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        firstView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true*/
        
        screenRatio = view.frame.size.width/view.frame.size.height

        print(screenRatio)
        
        uniqueuuids()
        
        fetchAllCharacters()
        
        DispatchQueue.main.async {
            self.collectionViewPlayers.reloadData()
        }
        
    
        print(characters.count)
        
        
        let statusBarHeight = getStatusBarHeight()
        let barHeight = self.navigationController?.navigationBar.frame.height ?? 0

        print("navigation \(barHeight)")
        
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        
        view.addSubview(viewAsagiTaraf)

        
        
        view.backgroundColor = .white
        

        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
                // Fetch request'i yapılandırın (isteğe bağlı)
                // Örneğin, sıralama ekleyebilir veya bir sorgu ölçütü belirleyebilirsiniz.
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true) // propertyName, sıralama yapmak istediğiniz özellik adıdır.
               fetchRequest.sortDescriptors = [sortDescriptor]

                // NSFetchedResultsController oluşturun
                fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: context,
                    sectionNameKeyPath: nil,
                    cacheName: nil
                )

                // Delegate'yi ayarlayın
                fetchedResultsController?.delegate = self

                // Verileri almak için performFetch() metodunu çağırın
                do {
                    try fetchedResultsController?.performFetch()
                    print("aaa")
                } catch {
                    print("Fetch Error: \(error.localizedDescription)")
                }
        


        
        
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTactic))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Tactic".localizedString(str: localizedString), style: .done, target: self, action: #selector(addButtonClick))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(settingsButtonClicked))
        
        menu?.leftSide = true
       // menu?.animationOptions = .curveEaseOut
       // menu!.presentationStyle = .viewSlideOutMenuZoom
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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
       /* uniqueuuids()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }*/
        
        
        tableViewRegister()

        

        
        //Oyuncularn oluşumu buraya sayı verebiliriz!!!
       /* createPlayers(tacticSize: chosenTacticSize)
        
        
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
        uniqueuuids()*/
        
        
       // print(<#T##Any...#>)
        
      //  allTactics.reverse()
        
        DispatchQueue.main.async {
            self.collectionViewTactics.reloadData()
        }
        
        
        
        print(playerViews.count)
        
        
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
        
        
        //addSubviews()
        
        
        viewAsagiTaraf.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewAsagiTaraf.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        viewAsagiTaraf.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewAsagiTaraf.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        

        
        
        view.addSubview(tacticsView)
        tacticsView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4 + 50).isActive = true
        tacticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40).isActive = true
        tacticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tacticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
       
       
        
        view.addSubview(footballPitchImage)
        footballPitchImage.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        footballPitchImage.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 25).isActive = true
        footballPitchImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        footballPitchImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
        view.addSubview(playersImageButton)
        playersImageButton.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        playersImageButton.leadingAnchor.constraint(equalTo: footballPitchImage.trailingAnchor, constant: 25).isActive = true
        playersImageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playersImageButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        

        
        view.addSubview(repeatTacticFormationButton)
        repeatTacticFormationButton.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        repeatTacticFormationButton.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: -25).isActive = true
        repeatTacticFormationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repeatTacticFormationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        view.addSubview(characterAddButton)
        characterAddButton.topAnchor.constraint(equalTo: tacticsView.topAnchor, constant: 5).isActive = true
        characterAddButton.trailingAnchor.constraint(equalTo: repeatTacticFormationButton.leadingAnchor, constant: -25).isActive = true
        characterAddButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        characterAddButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
        collectionViewSetUp()
        collectionViewPlayerSetUp()
        /*collectionViewPlayers.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionViewPlayers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionViewPlayers.heightAnchor.constraint(equalToConstant: 200).isActive = true
        collectionViewPlayers.widthAnchor.constraint(equalToConstant: 200).isActive = true
         */
        
       // collectionViewPlayers.register(PitchCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
/*
        collectionViewPlayers.delegate = self
        collectionViewPlayers.dataSource = self*/
        

       
        
        backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
       // backgroundImageView.bottomAnchor.constraint(equalTo: tacticsView.topAnchor, constant: -view.frame.size.height/40).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        view.addSubview(iconeImageView)
        iconeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        iconeImageView.heightAnchor.constraint(equalToConstant: barHeight+10).isActive = true
        iconeImageView.widthAnchor.constraint(equalToConstant: barHeight+10).isActive = true
        iconeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
      
        addSubviewsNoData()
        
        
    }
    
    let viewAsagiTaraf: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //Kaç tane oyuncunun oluşturulduğu
    func createPlayers(tacticSize: Int) {
            var numberY = 60
            var numberX = 0
            var katsayi = 1
            var eklenenX = 30
        
        var playerWidthHeigth = view.frame.size.width/6
        
        print("\(view.frame.size.width/6)")

        var numberYKaleci = 0.75*view.frame.size.height - view.frame.size.height/7
        
  
        switch ChosenTacticFormation{
         
        case "4-4-2":
            for i in 0..<tacticSize {
                
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
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
            }
            
            
        case "4-3-3":
            for i in 0..<tacticSize {
                
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
                }
                
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
            }
            
        case "4-3-2-1":
            for i in 0..<tacticSize {
                
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
                    
                    
                    
                }
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
                
            }
            
            
        case "3-5-2":
            
            for i in 0..<tacticSize {
         
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
                   }
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
                
            }
            
            
        case "3-4-3":
            
            for i in 0..<tacticSize {
            
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
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
                
            }
            

            
        default:
            for i in 0..<tacticSize {
                
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
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                 playerView.addGestureRecognizer(panGesture)

                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                 playerView.addGestureRecognizer(tapGesture)
                 
                 let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                 longTapGesture.minimumPressDuration = 0.75
                 playerView.addGestureRecognizer(longTapGesture)
                 
                 playerViews.append(playerView)
                 view.addSubview(playerView)
            }
            
            
            
        }
        
        // 4 - 4 - 2
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
                }*/
        
        
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

               /* let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                playerView.addGestureRecognizer(panGesture)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                playerView.addGestureRecognizer(tapGesture)
                
                let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHandleTap(_:)))
                longTapGesture.minimumPressDuration = 0.75
                playerView.addGestureRecognizer(longTapGesture)
                
                playerViews.append(playerView)
                view.addSubview(playerView)*/
               
                
            
        }
    
    
    var isAnimating = false
    @objc func longHandleTap(_ gestureRecognizer: UILongPressGestureRecognizer){
        
        guard let longTappedView = gestureRecognizer.view else{return}
        
        guard let index = self.playerViews.firstIndex(of: longTappedView) else{
            return
        }
        
        characterIndex = index
        selectedPlayerIndex = characterIndex
        
        
        for player in playerViews{
            player.layer.cornerRadius = 0
            player.layer.borderWidth = 0
            player.layer.borderColor = UIColor.clear.cgColor
        }
        
        
            playerViews[characterIndex].layer.cornerRadius = 15
            playerViews[characterIndex].layer.borderWidth = 3
            playerViews[characterIndex].layer.borderColor = UIColor.white.cgColor
        
        
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
                self.customCardView.isHidden = false
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
                  let defending = result.value(forKey: "defending") as? Int16,
                  let playerNo = result.value(forKey: "playerno") as? String
            else{
                return
            }

            player = Player(name: playerName, image: imageData, hizlanma: pace, sut: shooting, pas: passing, dribbling: dribbling, defending: defending, physical: physical, playerNo: playerNo)
            
            guard let player = player else{return}
            /*characterNameTextField.text = player.name
            characterImageView.image = UIImage(data: player.image)
            characterImageCard.image = UIImage(data: player.image)*/
            //print(player)
            
            
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
            guard let id = id else{return}
            //let idString = self.uuidString
            // Clear existing data
        //    deleteAllPlayerPositions()

        guard let imageData = UIImage(named: "forma")?.pngData() else{return}
        let characterName = "Name".localized()
        
        
        //İndexleriyle ve idleriyle x ve y konumlarıyla beraber kaydetme
            for (index, playerView) in playerViews.enumerated() {
                let entity = NSEntityDescription.entity(forEntityName: "PlayerPosition", in: managedContext)!
                let playerPosition = NSManagedObject(entity: entity, insertInto: managedContext)

                let position = playerView.center
                
                playerPosition.setValue(id, forKey: "id")
                
                print("Save ID \(id)")
                
                playerPosition.setValue(index, forKey: "index")
                playerPosition.setValue(position.x, forKey: "x")
                playerPosition.setValue(position.y, forKey: "y")
                playerPosition.setValue("", forKey: "name")
                playerPosition.setValue(imageData, forKey: "image")
                playerPosition.setValue("99", forKey: "playerno")

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

        func deleteSelectedPlayerPositions(id: UUID) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

            guard let uuid = UUID(uuidString: uuidString) else{
                return
            }
            
            
            let predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            
            fetchRequest.predicate = predicate
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                for case let result as NSManagedObject in results {
                    managedContext.delete(result)
                }
                
                try managedContext.save()

                
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    
    func deleteSelectedTactic(id: UUID) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")

        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        
        
        let predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let result as NSManagedObject in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()

        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    
    func deleteAllPlayerPositions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerPosition")

        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        

        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let result as NSManagedObject in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()

            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllTactics() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")

        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        

        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let result as NSManagedObject in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()

            
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
        print("predicate oncesi \(uuid)")
        fetchRequest.predicate = predicate
   //     print("predicateById")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Result sayısı \(results.count)")
            for result in results {
                
                
                print("result =")
                
                guard let result = result as? NSManagedObject else{return}
                
                print("Resultlar \(result)")
                if let index = result.value(forKey: "index") as? Int,
                   let x = result.value(forKey: "x") as? CGFloat,
                   let y = result.value(forKey: "y") as? CGFloat,
                   let id = result.value(forKey: "id") as? UUID,
                   let uuidString = id.uuidString as? String,
                   let imageData = result.value(forKey: "image") as? Data,
                   let characterName = result.value(forKey: "name") as? String,
                   let playerNo = result.value(forKey: "playerno") as? String,
                 //  let tacticName = result.value(forKey: "tacticname") as? String,
                   
                    
                   
                    
                    index < playerViews.count {
                 //   print(index, x, y, id, uuidString, imageData, characterName)

                   // let characterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                  //  print(characterName)

               //     title = tacticName
                    
                    
                    print("Başarıyla giriş yapıldı")
                    
                    let characterLabel: UILabel = {
                       let label = UILabel()
                        label.textAlignment = .center
                        label.tag = 1
                        label.font = UIFont.boldSystemFont(ofSize: 14)
                        label.numberOfLines = 0
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
                        label.tag = 2
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
                    
                    if characterName == ""{
                        characterLabel.text = "Player"
                    }else{
                        characterLabel.text = characterName

                    }
                    
                    characterImage.image = UIImage(data: imageData)
                    characterNumber.text = playerNo
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

                    
                    characterLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: -2.5).isActive = true
                    characterLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
                    characterLabel.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                    
                    characterNumber.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
                    characterNumber.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
                    characterNumber.widthAnchor.constraint(equalToConstant: 26).isActive = true
                    characterNumber.heightAnchor.constraint(equalToConstant: 26).isActive = true

                    

                    
                    //print("\(index): \(x), \(y), \(uuidString)")
                    
                    self.uuidString = uuidString
                    
                }
                
                print("İNDEX SAYIDAN BÜYÜK")
            }
         //   print("giremedik abi1")
            print("Predicate yerine girmiyor")

            
            let resultlar = try managedContext.fetch(fetchRequest)
            
           // print(resultlar)
            
        }catch{
          //  print("giremedik abi2")
            print("Predicate başarısız")
        }

    }
    
    
    func predicateAndUploadCharacter(uuidString: String, index: Int, playerCharacter: Player){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PlayerPosition> = PlayerPosition.fetchRequest()

        guard let uuid = UUID(uuidString: uuidString) else{
            return
        }
        
        let predicate = NSPredicate(format: "id == %@ AND index == %d", uuid as CVarArg, index)
        fetchRequest.predicate = predicate
        
        
        
        
        
        do {
            if let character = try managedContext.fetch(fetchRequest).first {
                // Güncelleme işlemini gerçekleştir
             //   print(existingPlayerPosition)
                /*let position = playerViews[index].center
                existingPlayerPosition.setValue(position.x, forKey: "x")
                existingPlayerPosition.setValue(position.y, forKey: "y")*/
                
                
                
                
                character.setValue(playerCharacter.name, forKey: "name")
                character.setValue(playerCharacter.image, forKey: "image")
                
                character.setValue(playerCharacter.defending, forKey: "defending")
                character.setValue(playerCharacter.dribbling, forKey: "dribbling")
                character.setValue(playerCharacter.physical, forKey: "physical")
                character.setValue(playerCharacter.hizlanma, forKey: "pace")
                character.setValue(playerCharacter.sut, forKey: "shooting")
                character.setValue(playerCharacter.pas, forKey: "passing")

                character.setValue(playerCharacter.playerNo, forKey: "playerno")

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

    
    
    ///Unique UUIDLERİ BUL GETİR tableViewde göster
    func uniqueuuids() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        // NSFetchRequest oluştur
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FootballTactics")

        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // Fetch işlemi gerçekleştir
            let results = try managedContext.fetch(fetchRequest)

            // Farklı UUID'leri bulmak için bir dizi oluştur
            var uniqueUUIDsSet = Set<UUID>()
            
            
            
            
            
           // print("all tactikler \(allTactics)")
            
            allTactics.removeAll()
            uniqueUUIDs.removeAll()
            for result in results {
                if let footballTactics = result as? FootballTactics, let uuid = footballTactics.id {
                   // uniqueUUIDsSet.insert(uuid)
                    uniqueUUIDs.append(uuid)
                    allTactics.append(footballTactics)
                  //  print(footballTactics.id)
                }
            }
            allTactics.reverse()
            uniqueUUIDs.reverse()
            
            if allTactics.count > 0{
                
                
                
                
                if let tacticSize = allTactics.first?.size {
                    chosenTacticSize = Int(tacticSize)
                } else {
                    // Eğer allTactics.first?.size nil ise, uygun bir varsayılan değer veya başka bir strateji belirleyebilirsiniz.
                    chosenTacticSize = 11 // Veya başka bir değer
                }
                ChosenTacticFormation = (allTactics.first?.formation)!
                uuidString = (allTactics.first?.id!.uuidString)!
                
                print("all tacticler \(allTactics.count)")
                
                // uniqueUUIDs = Array(uniqueUUIDsSet)
                
                guard let imageData = allTactics.first?.image as? Data else{
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
        
        customCardView.isHidden = false
        
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
        
        view.addSubview(customCardView)
        
        
      /*  backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true*/

        
        customCardView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        
        customCardView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        customCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/10).isActive = true

        
        let cardBackImageView = UIImageView(image: UIImage(named: "cardView"))
        cardBackImageView.translatesAutoresizingMaskIntoConstraints = false
        cardBackImageView.contentMode = .scaleToFill
        cardBackImageView.clipsToBounds = true
        customCardView.clipsToBounds = true
        
        
        customCardView.addSubview(cardBackImageView)
        
        cardBackImageView.topAnchor.constraint(equalTo: customCardView.topAnchor).isActive = true
        cardBackImageView.bottomAnchor.constraint(equalTo: customCardView.bottomAnchor).isActive = true
        cardBackImageView.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor).isActive = true
        cardBackImageView.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor).isActive = true
        
        
        
        
        // closeCharacterButton
        customCardView.addSubview(closeCharacterButton)
        
        closeCharacterButton.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -15).isActive = true
        closeCharacterButton.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 15).isActive = true
        closeCharacterButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        closeCharacterButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        // character details
        customCardView.addSubview(detailButton)
        
        detailButton.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 20).isActive = true
        detailButton.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 15).isActive = true
        detailButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // Character Button Image
        
        customCardView.addSubview(characterImage)
        
        characterImage.topAnchor.constraint(equalTo: customCardView.topAnchor, constant: 15).isActive = true
        characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        characterImage.widthAnchor.constraint(equalToConstant: view.frame.width/3.4).isActive = true
        characterImage.heightAnchor.constraint(equalToConstant: view.frame.width/3.2).isActive = true

        
        customCardView.addSubview(characterName)
        
        characterName.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 10).isActive = true
        characterName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        characterName.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 10).isActive = true
        characterName.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -10).isActive = true
        
        customCardView.addSubview(cizgiYatay)
        
        cizgiYatay.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 5).isActive = true
        cizgiYatay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiYatay.heightAnchor.constraint(equalToConstant: 1).isActive = true
        cizgiYatay.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true

        
        customCardView.addSubview(cizgiDikey)
        
        cizgiDikey.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant: 10).isActive = true
        cizgiDikey.bottomAnchor.constraint(equalTo: customCardView.bottomAnchor, constant: -25).isActive = true
        cizgiDikey.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cizgiDikey.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        customCardView.addSubview(leftStackView)
        
        leftStackView.addArrangedSubview(hizlanmaLabel)
        leftStackView.addArrangedSubview(sutLabel)
        leftStackView.addArrangedSubview(pasLabel)

        
        leftStackView.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant: 0).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: cizgiDikey.bottomAnchor, constant: 0).isActive = true
        leftStackView.leadingAnchor.constraint(equalTo: customCardView.leadingAnchor, constant: 10).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: cizgiDikey.leadingAnchor, constant: -10).isActive = true

        
         
        customCardView.addSubview(rightStackView)
        
        rightStackView.addArrangedSubview(dripplingLabel)
        rightStackView.addArrangedSubview(defLabel)
        rightStackView.addArrangedSubview(phyLabel)
        
        rightStackView.topAnchor.constraint(equalTo: cizgiYatay.bottomAnchor, constant:  0).isActive = true
        rightStackView.leadingAnchor.constraint(equalTo: cizgiDikey.trailingAnchor, constant: 10).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: customCardView.trailingAnchor, constant: -10).isActive = true
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
        createPlayers(tacticSize: chosenTacticSize)
        
        predicateById(uuidString: uuidString)

        
    }
    
    
    
}







extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
            
        case collectionViewTactics:
            /*if allTactics.count > 10{
                return 10

            }else{
                return allTactics.count

            }*/
            return allTactics.count
            
        case collectionViewPlayers:
            
            return characters.count
            
        default:
            return 10
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case collectionViewTactics:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PitchCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            
            cell.contentView.layer.cornerRadius = 15
            cell.contentView.backgroundColor = .gray
            cell.contentView.clipsToBounds = true
            cell.clipsToBounds = true
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            
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
            
        
        case collectionViewPlayers:
          //  print("aaaaaaaa")
            guard let cell = collectionViewPlayers.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? CharacterCollectionViewCell else{
                return UICollectionViewCell()
            }
            
           // cell.delegate = self
            
            
            cell.characterNameLabel.text = characters[indexPath.row].name
            cell.characterNumberLabel.text = characters[indexPath.row].playerNo
            
            let image = UIImage(data: characters[indexPath.row].image)
            
            cell.characterImageView.image = image


            
            cell.contentView.layer.cornerRadius = 15
            cell.contentView.clipsToBounds = true
            cell.clipsToBounds = true
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.black.cgColor

       
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if screenRatio > 0.5{
            return CGSize(width: view.frame.size.width/3.75, height: 110)

        }else{
            return CGSize(width: view.frame.size.width/3.4, height: 125)

        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case collectionViewTactics:
            let uuidString = uniqueUUIDs[indexPath.row].uuidString
            print(uuidString)
            for playerView in playerViews {
                playerView.removeFromSuperview()
            }

            // Dizi içindeki tüm view'leri temizle
            playerViews.removeAll()
            
           // uniqueuuids()
            
            chosenTacticSize = Int(allTactics[indexPath.row].size)
            ChosenTacticFormation = allTactics[indexPath.row].formation!
            
            characterIndex = 0
            
            createPlayers(tacticSize: chosenTacticSize)
            
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
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? PitchCollectionViewCell else{
                return
            }
            
            
            if indexPath.item == layout.currentPage{
                layout.currentPage = indexPath.item
                layout.previousOffset = layout.updateOffset(collectionView)
                setupCell()
                print("1")
            }else{
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                layout.currentPage = indexPath.item
                layout.previousOffset = layout.updateOffset(collectionView)
                setupCell()
                print("2")
            }
            
            selectedIndexPath = indexPath

               // Tüm hücreleri döngü ile kontrol et
            for i in 0..<collectionView.numberOfItems(inSection: selectedIndexPath!.section) {
                   // Her hücreyi al
                if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: selectedIndexPath!.section)) as? PitchCollectionViewCell {
                       // Seçilen hücre ise deleteTacticButton.isHidden'i false yap, aksi takdirde true yap
                    cell.deleteTacticButton.isHidden = (i == selectedIndexPath!.item) ? false : true
                    
                    cell.contentView.layer.borderWidth = (i == selectedIndexPath!.item) ? 1.5 : 2
                    cell.contentView.layer.borderColor = (i == selectedIndexPath!.item) ? UIColor.black.cgColor : UIColor.gray.cgColor
                    
                   }
               }
            
      
          
            
         //   cell.deleteTacticButton.isHidden = false
            
        case collectionViewPlayers:
            
            print(characters[indexPath.row])
            print(playerViews.count)
            
            
                
            if characterIndex == chosenTacticSize{
                 characterIndex = 0
             }
            
            else{
                
            }
                
            //    let playerView = playerViews[selectedPlayerIndex]
                let playerView = playerViews[characterIndex]
                var playerName = "Name"
                var playerNo = "99"
                var playerImageData = Data()
            
            
                //SelectedCharacer
            
            for player in playerViews{
                player.layer.cornerRadius = 0
                player.layer.borderWidth = 0
                player.layer.borderColor = UIColor.clear.cgColor
            }
            
            print(characterIndex)
            
            if playerViews.count == characterIndex+1{
                playerViews[0].layer.cornerRadius = 15
                playerViews[0].layer.borderWidth = 3
                playerViews[0].layer.borderColor = UIColor.white.cgColor
            }else{
                playerViews[characterIndex+1].layer.cornerRadius = 15
                playerViews[characterIndex+1].layer.borderWidth = 3
                playerViews[characterIndex+1].layer.borderColor = UIColor.white.cgColor
            }
            
            
               
                            
            
                // ImageView alt görünümüne eriş
                if let imageView = playerView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                    // ImageView özelliklerini değiştir
                    guard let image = UIImage(data: characters[indexPath.row].image) else{return}
                    imageView.image = image
                    playerImageData = characters[indexPath.row].image
                    // Diğer özellikleri değiştir...
                }
                
                if let labelView = playerView.subviews.first(where: { $0 is UILabel && $0.tag == 1 }) as? UILabel {
                    // UILabel özelliklerini değiştir
                    labelView.text = "\(characters[indexPath.row].name)"
                    playerName = characters[indexPath.row].name
                    // Diğer özellikleri değiştir...
                }
                
                if let labelView = playerView.subviews.first(where: { $0 is UILabel && $0.tag == 2 }) as? UILabel {
                    // UILabel özelliklerini değiştir
                    labelView.text = characters[indexPath.row].playerNo
                    //No Değiştir
                    playerNo = "55"
                    
                    // Diğer özellikleri değiştir...
                }
                
                
                print("selected \(selectedPlayerIndex)")
                
                
                
                /* if characterIndex == chosenTacticSize{
                 characterIndex = 0
                 }else{*/
                predicateAndUploadCharacter(uuidString: uuidString, index: characterIndex, playerCharacter: characters[indexPath.row])
                
            
        
            characterIndex += 1
                
                
            
            
            
            
        default:
            print(indexPath)
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
        if let cell = collectionViewTactics.cellForItem(at: indexPath){
            transformCell(cell)
           didSelectAnotherCell()
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
        
        for otherCell in collectionViewTactics.visibleCells{
            
            if let indexPath = collectionViewTactics.indexPath(for: otherCell){
                if indexPath.item != layout.currentPage{
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
        
    }
    
}
