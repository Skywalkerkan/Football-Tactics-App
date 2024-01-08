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
    
    
    var playerSize: [Int] = [5,6,7,8,9,10,11]
    var pitchTactic: [String] = ["4-4-2", "4-3-3", "4-3-2-1","3-4-3","5-3-2","5-4-1" ]
    
    var itemWidth: CGFloat{
        return screenWidth * 0.33
    }
    
    var itemHeigth: CGFloat{
        return itemWidth*1.15
    }
    
    private let tacticsView: UIView = {
        let tacticView = UIView()
        tacticView.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 30
        //tacticView.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        tacticView.layer.cornerRadius = 40
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
        tableview.alpha = 0.0
        tableview.bounces = false
        tableview.isHidden = true
        tableview.showsVerticalScrollIndicator = false
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    private let dizilisTableView: UITableView = {
        let tableview = UITableView()
        tableview.alpha = 0.0
        tableview.isHidden = true
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
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
        VC.chosenTacticSize = tacticSize
        VC.ChosenTacticFormation = tacticFormation
        navigationController?.pushViewController(VC, animated: true)
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
        if oyuncuSayisiTableView.isHidden{
        
            oyuncuSayisiTableView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.oyuncuSayisiTableView.alpha = 1.0
              //  self.dizilisTableView.alpha = 0
               // self.dizilisTableView.isHidden = true
            }
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.oyuncuSayisiTableView.alpha = 0.0
            } completion: { _ in
                self.oyuncuSayisiTableView.isHidden = true
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
        if dizilisTableView.isHidden{
        
            dizilisTableView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.dizilisTableView.alpha = 1.0
            }
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.dizilisTableView.alpha = 0.0
            } completion: { _ in
                self.dizilisTableView.isHidden = true
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
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*  UIColor(red: 186/255, green: 193/255, blue: 184/255, alpha: 1)
        UIColor(red: 88/255, green: 164/255, blue: 176/255, alpha: 1)
         UIColor(red: 181/255, green: 210/255, blue: 203/255, alpha: 1)
         UIColor(red: 168/255, green: 174/255, blue: 193/255, alpha: 1)
         */
        
        
        
        view.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 241/255, alpha: 1)

      
        
        viewSetup()
        //oyuncuSayisiTableView.separatorStyle = .none
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(oyuncuSayiButton)
        buttonsStackView.addArrangedSubview(taktikDizilisButton)
        
        buttonsStackView.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 20).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 0).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 0).isActive = true

        oyuncuSayiTableViewSetup()
        taktikDizilisTableViewSetup()
        
        
        view.addSubview(tacticsView)
       // tacticsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        tacticsView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4).isActive = true
        tacticsView.topAnchor.constraint(equalTo: oyuncuSayisiTableView.bottomAnchor).isActive = true
      //  tacticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tacticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tacticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        collectionViewSetUp()
        
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: tacticsView.bottomAnchor, constant: 15).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true

    }
    
    
    func oyuncuSayiTableViewSetup(){
        
        //SayiButton
       // view.addSubview(oyuncuSayiButton)
       /* oyuncuSayiButton.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiButton.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/

        //OyuncuSayiTableView
        view.addSubview(oyuncuSayisiTableView)
        oyuncuSayisiTableView.delegate = self
        oyuncuSayisiTableView.dataSource = self
        oyuncuSayisiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "oyuncuSayiCell")
        oyuncuSayisiTableView.topAnchor.constraint(equalTo: oyuncuSayiButton.bottomAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.leadingAnchor.constraint(equalTo: oyuncuSayiButton.leadingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.trailingAnchor.constraint(equalTo: oyuncuSayiButton.trailingAnchor, constant: 0).isActive = true
        oyuncuSayisiTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    
    func taktikDizilisTableViewSetup(){
        
        //SayiButton
       // view.addSubview(oyuncuSayiButton)
       /* oyuncuSayiButton.topAnchor.constraint(equalTo: tacticTextField.bottomAnchor, constant: 10).isActive = true
        oyuncuSayiButton.leadingAnchor.constraint(equalTo: tacticTextField.leadingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.trailingAnchor.constraint(equalTo: tacticTextField.trailingAnchor, constant: 10).isActive = true
        oyuncuSayiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/

        //OyuncuSayiTableView
        view.addSubview(dizilisTableView)
        dizilisTableView.delegate = self
        dizilisTableView.dataSource = self
        dizilisTableView.register(UITableViewCell.self, forCellReuseIdentifier: "taktikDizilisCell")
        dizilisTableView.topAnchor.constraint(equalTo: taktikDizilisButton.bottomAnchor, constant: 0).isActive = true
        dizilisTableView.leadingAnchor.constraint(equalTo: taktikDizilisButton.leadingAnchor, constant: 0).isActive = true
        dizilisTableView.trailingAnchor.constraint(equalTo: taktikDizilisButton.trailingAnchor, constant: 0).isActive = true
        dizilisTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    
    
    
    func viewSetup(){
        
        //TacticField
        view.addSubview(tacticTextField)
        tacticTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tacticTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tacticTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tacticTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true

        
        
        
        
        
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
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height/4 - 20).isActive = true
        collectionView.topAnchor.constraint(equalTo: tacticsView.topAnchor).isActive = true
        collectionView.backgroundColor = .clear
        
        
    }
    

  

}


extension CreatePitchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PitchCollectionViewCell else{
            return UICollectionViewCell()
        }
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
            tableView.deselectRow(at: indexPath, animated: true)
            self.tacticSize = playerSize[indexPath.row]
            
        case dizilisTableView:
            taktikDizilisClicked()
            tableView.deselectRow(at: indexPath, animated: true)
            self.tacticFormation = pitchTactic[indexPath.row]

            
        default: 
            break
            
        }
        
    }
    
    
    
    
}
