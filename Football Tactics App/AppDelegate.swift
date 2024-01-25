//
//  AppDelegate.swift
//  Football Tactics App
//
//  Created by Erkan on 26.12.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var kayitliMi = false
    
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
     
            if results.count > 0{
                self.kayitliMi = true
            }

        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        uniqueuuids()
        print(kayitliMi)
        
        // Unique UUIDs listesinin count değerini kontrol et
        if kayitliMi {
            // Eğer unique UUIDs listesi boş değilse, MainViewController'ı başlat
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let navigationController = UINavigationController(rootViewController: mainViewController)
            window?.rootViewController = navigationController
        } else {
            // Eğer unique UUIDs listesi boşsa, CreatePitchViewController'ı başlat
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createPitchViewController = storyboard.instantiateViewController(withIdentifier: "CreatePitchViewController") as! CreatePitchViewController
            let navigationController = UINavigationController(rootViewController: createPitchViewController)
            window?.rootViewController = navigationController
        }

        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Football_Tactics_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

