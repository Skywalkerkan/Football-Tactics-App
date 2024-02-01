//
//  MenuTableViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 22.01.2024.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    var localizedString = "en"

    let erkanLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Made with care by E.C."
        label.font = UIFont(name: "Baskerville Bold Italic", size: 16)
        label.isHidden = true
        return label
    }()
    
    
    var languagesBasildiMi = false
    
    let langugaesTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        //tableView.backgroundColor = .red
        return tableView
    }()
    
    
    var items = [String]()
    var languages = ["English","Turkish","French"]
    
    struct Languages{
        
        let country: String
        let image: UIImage
        
        
    }
    
    var languagesArray: [Languages] = []
   
    override func viewWillAppear(_ animated: Bool) {
        localizedString = UserDefaults.standard.string(forKey: "language")!

        languagesArray =  [Languages(country: "English".localizedString(str: localizedString), image:                         UIImage(named: "ingiliz")!),
                           Languages(country: "Turkish".localizedString(str: localizedString), image: UIImage(named: "turk")!),
                           Languages(country: "French".localizedString(str: localizedString), image: UIImage(named: "frans")!),
                           Languages(country: "German".localizedString(str: localizedString), image: UIImage(named: "alman")!)
                          ]
        
        items = ["Info".localizedString(str: localizedString),"Languages".localizedString(str: localizedString)]
        
        
        
        DispatchQueue.main.async {
            self.langugaesTableView.reloadData()
            self.tableView.reloadData()

        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light


        
        
        view.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        langugaesTableView.register(LanguagesTableViewCell.self, forCellReuseIdentifier: "cell2")
        langugaesTableView.delegate = self
        langugaesTableView.dataSource = self

        tableView.bounces = false
        
        view.addSubview(langugaesTableView)
        
        langugaesTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        langugaesTableView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        langugaesTableView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 100).isActive = true
        langugaesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       // langugaesTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        print(view.frame.size.height)
        
        
       
        view.addSubview(erkanLabel)
        erkanLabel.bottomAnchor.constraint(equalTo: langugaesTableView.bottomAnchor, constant: 150).isActive = true
        erkanLabel.centerXAnchor.constraint(equalTo: langugaesTableView.centerXAnchor).isActive = true
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        switch tableView{
            

        case langugaesTableView:
            return 1

            
        default:
            return 1

        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tableView{
            

        case langugaesTableView:
            return languagesArray.count

            
        default:
            return items.count

        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView{
            
    
            

        case langugaesTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? LanguagesTableViewCell else{return UITableViewCell()}

            // Configure the cell...
            cell.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
            cell.countryName.text = languagesArray[indexPath.row].country
            cell.countryImage.image = languagesArray[indexPath.row].image
            
            
            
            
            return cell

            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            // Configure the cell...
            cell.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
            cell.textLabel?.text = items[indexPath.row]
            cell.textLabel?.textAlignment = .center
            
            return cell

        }

        
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
            
        case langugaesTableView:
            
            return 50
            
        
            
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
            
    
            

        case langugaesTableView:
            
            switch languagesArray[indexPath.row].country.localizedString(str: localizedString){
                
            case "English".localizedString(str: localizedString):
                print("English")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)
                let languageChangedNotification = Notification.Name("LanguageChangedNotification")
                let newLanguage = "en"
                
                UserDefaults.standard.setValue("en", forKey: "language")

                
                UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: languageChangedNotification, object: nil)
            case "Turkish".localizedString(str: localizedString):
                print("Turkish")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)
                let languageChangedNotification = Notification.Name("LanguageChangedNotification")
                let newLanguage = "tr"
                
                UserDefaults.standard.setValue("tr", forKey: "language")
                
                UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: languageChangedNotification, object: nil)

                  


            case "French".localizedString(str: localizedString):
                print("French")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)
                
                let languageChangedNotification = Notification.Name("LanguageChangedNotification")
                let newLanguage = "fr"
                
                UserDefaults.standard.setValue("fr", forKey: "language")
                
                UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: languageChangedNotification, object: nil)
                
                
                
            case "German".localizedString(str: localizedString):
                print("German")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)
                
                let languageChangedNotification = Notification.Name("LanguageChangedNotification")
                let newLanguage = "de"
                
                UserDefaults.standard.setValue("de", forKey: "language")
                
                UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: languageChangedNotification, object: nil)


                
            default:
                print("default")
            }

            
        default:
            
            if indexPath.row == 1{
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                if languagesBasildiMi == false{
                    langugaesTableView.isHidden = false
                    languagesBasildiMi = true
                }else{
                    langugaesTableView.isHidden = true
                    languagesBasildiMi = false
                }
                
                
               // navigationController?.pushViewController(CreateCharacterViewController(), animated: true)

            }else{
                erkanLabel.isHidden = false
                tableView.deselectRow(at: indexPath, animated: true)

                
            }

        }
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
