//
//  CreatePitchViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 4.01.2024.
//

import UIKit





class CreatePitchViewController: UIViewController {
    
    let screenWidth =  UIScreen.main.bounds.size.width
    let screenHeigth =  UIScreen.main.bounds.size.height
    let isCellIdentify = false
    var tacticSize: Int = 11
    var tacticFormation: String = "4-4-2"
    var chosenPitchImage: UIImage?
    
    
    var playerSize: [Int] = [5,6,7,8,9,10,11]
    var pitchTactic: [String] = ["4-4-2", "4-3-3", "4-3-2-1","3-4-3","5-3-2","5-4-1" ]
    
    var itemWidth: CGFloat{
        return screenWidth * 0.33
    }
    
    var itemHeigth: CGFloat{
        return itemWidth*1.15
    }
    
    
    var pitchImages: [UIImage] = []
    
    private let tacticsView: UIView = {
        let tacticView = UIView()
        tacticView.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 30
        //tacticView.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
      //  tacticView.layer.cornerRadius = 40
        tacticView.clipsToBounds = true
        return tacticView
    }()
    
    private let tacticTextField: UITextField = {
       let text = UITextField()
        text.placeholder = "Tactic Name"
        text.textAlignment = .center
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 2
        text.layer.cornerRadius = 10
        text.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let oyuncuSayisiTableView: UITableView = {
        let tableview = UITableView()
        tableview.alpha = 1
       // tableview.bounces = false
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(sayiButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let dizilisTableView: UITableView = {
        let tableview = UITableView()
        tableview.alpha = 1
        tableview.isHidden = false
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(taktikDizilisClicked), for: .touchUpInside)
        return button
    }()
    
    
    let oyuncuSayiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    
    let taktikDizilisView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    
    
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        button.setTitle("Save Tactic", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func saveButtonClicked(){
        let VC = MainViewController()
      
        
        let id = UUID()
        let uuidString = id.uuidString
        VC.chosenTacticSize = tacticSize
        VC.ChosenTacticFormation = tacticFormation
        VC.uuidString = uuidString
        
        addTactic(uuid: id)
        
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    private func addTactic(uuid: UUID){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let newTactic = FootballTactics(context: context)
        newTactic.size = 11
        newTactic.id = uuid
        newTactic.name = tacticTextField.text
        newTactic.formation = "4-4-2"
        
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
        button.setTitle("Team Size", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sayiButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    @objc func sayiButtonClicked(){
        if oyuncuSayiView.isHidden{
        
            oyuncuSayiView.isHidden = false
            blackView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.oyuncuSayiView.alpha = 1.0
              //  self.dizilisTableView.alpha = 0
               // self.dizilisTableView.isHidden = true
                self.blackView.alpha = 0.3
            }
            
        }else{
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
        button.setTitle("Formation", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    let blackView: UIView = {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.3
        blackView.isHidden = true
        blackView.translatesAutoresizingMaskIntoConstraints = false
        return blackView
    }()
    
    
   
    override func viewWillAppear(_ animated: Bool) {

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*  UIColor(red: 186/255, green: 193/255, blue: 184/255, alpha: 1)
        UIColor(red: 88/255, green: 164/255, blue: 176/255, alpha: 1)
         UIColor(red: 181/255, green: 210/255, blue: 203/255, alpha: 1)
         UIColor(red: 168/255, green: 174/255, blue: 193/255, alpha: 1)
         */
        
        
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
        
        
        
        view.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)

      
        
        viewSetup()
        
        
        view.addSubview(tacticsView)
       // tacticsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        tacticsView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        tacticsView.topAnchor.constraint(equalTo: oyuncuSayiLabel.bottomAnchor, constant: 15).isActive = true
      //  tacticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tacticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tacticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: tacticsView.bottomAnchor, constant: 15).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
     
        
        
        

        
       
        
        view.addSubview(blackView)
        
        blackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
        sayiVeDizilisViewSetup()
        oyuncuSayiTableViewSetup()
        taktikDizilisTableViewSetup()
        
        collectionViewSetUp()

        

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
    
    
    func oyuncuSayiTableViewSetup(){
        
        //SayiButton
       // view.addSubview(oyuncuSayiButton)
       /* oyuncuSayiButton.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiButton.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/

        //OyuncuSayiTableView
        
        
        
        
        let labelSayiView = UILabel()
        labelSayiView.translatesAutoresizingMaskIntoConstraints = false
        labelSayiView.text = "Oyuncu Sayısı"
        labelSayiView.textAlignment = .center
        labelSayiView.backgroundColor = .lightGray
        
        oyuncuSayiView.addSubview(labelSayiView)
        
        oyuncuSayiView.addSubview(oyuncuSayisiTableView)
        oyuncuSayiView.backgroundColor = .clear

        
        
        oyuncuSayisiTableView.delegate = self
        oyuncuSayisiTableView.dataSource = self
        oyuncuSayisiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "oyuncuSayiCell")
        
        labelSayiView.leadingAnchor.constraint(equalTo: oyuncuSayiView.leadingAnchor, constant: 0).isActive = true
        labelSayiView.trailingAnchor.constraint(equalTo: oyuncuSayiView.trailingAnchor, constant: 0).isActive = true
        labelSayiView.topAnchor.constraint(equalTo: oyuncuSayiView.topAnchor, constant: 0).isActive = true
        labelSayiView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        oyuncuSayisiTableView.topAnchor.constraint(equalTo: labelSayiView.bottomAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.leadingAnchor.constraint(equalTo: oyuncuSayiView.leadingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.trailingAnchor.constraint(equalTo: oyuncuSayiView.trailingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.bottomAnchor.constraint(equalTo: oyuncuSayiView.bottomAnchor, constant: 0).isActive = true
        
        
        

    }
    
    
    
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
        let labelTaktikView = UILabel()
        labelTaktikView.backgroundColor = .lightGray
        labelTaktikView.textAlignment = .center
        labelTaktikView.translatesAutoresizingMaskIntoConstraints = false
        labelTaktikView.text = "Taktik Diziliş"
        
        
        dizilisTableView.delegate = self
        dizilisTableView.dataSource = self
        dizilisTableView.register(UITableViewCell.self, forCellReuseIdentifier: "taktikDizilisCell")
        
        
        taktikDizilisView.addSubview(labelTaktikView)
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
        buttonsStackView.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 0).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 0).isActive = true
        
        
        view.addSubview(oyuncuSayiLabel)
        oyuncuSayiLabel.topAnchor.constraint(equalTo: oyuncuSayiButton.bottomAnchor, constant: 20).isActive = true
        oyuncuSayiLabel.leadingAnchor.constraint(equalTo: oyuncuSayiButton.leadingAnchor, constant: 20).isActive = true
        oyuncuSayiLabel.trailingAnchor.constraint(equalTo: oyuncuSayiButton.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(dizilisLabelButton)
        
        dizilisLabelButton.topAnchor.constraint(equalTo: taktikDizilisButton.bottomAnchor, constant: 20).isActive = true
        dizilisLabelButton.leadingAnchor.constraint(equalTo: taktikDizilisButton.leadingAnchor, constant: 20).isActive = true
        dizilisLabelButton.trailingAnchor.constraint(equalTo: taktikDizilisButton.trailingAnchor, constant: -20).isActive = true
        
        
        
        
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
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        layout.itemSize.width = itemWidth
        collectionView.clipsToBounds = true
        collectionView.leadingAnchor.constraint(equalTo: tacticsView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: tacticsView.trailingAnchor, constant: 0).isActive = true
       // collectionView.centerYAnchor.constraint(equalTo: tacticsView.centerYAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        collectionView.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionView.backgroundColor = .clear
        
        
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
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.backgroundColor = .gray
        cell.contentView.clipsToBounds = true
        cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == layout.currentPage{
            
        }else{
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
            
            self.chosenPitchImage = pitchImages[indexPath.row]
            print(chosenPitchImage)
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
                        print(indexPath)
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
            cell.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
             return cell
        
        case dizilisTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taktikDizilisCell", for: indexPath)
            cell.textLabel?.text = (pitchTactic[indexPath.row])
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)
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
