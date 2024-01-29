//
//  MenuTableViewController.swift
//  Football Tactics App
//
//  Created by Erkan on 22.01.2024.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    var languagesBasildiMi = false
    
    let langugaesTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        //tableView.backgroundColor = .red
        return tableView
    }()
    
    
    var items = ["Delete All Tactics","Info","Languages"]
    var languages = ["English","Turkish","French"]
    
    struct Languages{
        
        let country: String
        let image: UIImage
        
        
    }
    
    var languagesArray: [Languages] = [Languages(country: "English", image: UIImage(named: "ingiliz")!),
                                       Languages(country: "Turkish", image: UIImage(named: "turk")!),
                                       Languages(country: "French", image: UIImage(named: "frans")!),
                                       Languages(country: "Deutch", image: UIImage(named: "alman")!)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        view.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 253/255, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        langugaesTableView.register(LanguagesTableViewCell.self, forCellReuseIdentifier: "cell2")
        langugaesTableView.delegate = self
        langugaesTableView.dataSource = self

        tableView.bounces = false
        
        view.addSubview(langugaesTableView)
        
        langugaesTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        langugaesTableView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        langugaesTableView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 150).isActive = true
        langugaesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       // langugaesTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
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
            
            switch languages[indexPath.row]{
                
            case "English":
                print("English")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)
            case "Turkish":
                print("Turkish")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)


            case "French":
                print("French")
                dismiss(animated: true)
                langugaesTableView.deselectRow(at: indexPath, animated: true)


                
            default:
                print("default")
            }

            
        default:
            
            if items[indexPath.row] == "Languages"{
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                if languagesBasildiMi == false{
                    langugaesTableView.isHidden = false
                    languagesBasildiMi = true
                }else{
                    langugaesTableView.isHidden = true
                    languagesBasildiMi = false
                }
                
                
               // navigationController?.pushViewController(CreateCharacterViewController(), animated: true)

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
