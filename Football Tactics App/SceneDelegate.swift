//
//  SceneDelegate.swift
//  Football Tactics App
//
//  Created by Erkan on 26.12.2023.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    
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
           func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
               
               guard let windowScene = scene as? UIWindowScene else { return }
               window = UIWindow(windowScene: windowScene)

               uniqueuuids()
            //   print(kayitliMi)

               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               var rootViewController: UIViewController

               // Unique UUIDs listesinin count değerini kontrol et
               if kayitliMi {
                   // Eğer unique UUIDs listesi boş değilse, MainViewController'ı başlat
                   let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                   rootViewController = UINavigationController(rootViewController: mainViewController)
               } else {
                   // Eğer unique UUIDs listesi boşsa, CreatePitchViewController'ı başlat
                   let createPitchViewController = storyboard.instantiateViewController(withIdentifier: "CreatePitchViewController") as! CreatePitchViewController
                   rootViewController = UINavigationController(rootViewController: createPitchViewController)
               }

               window?.rootViewController = rootViewController
               window?.makeKeyAndVisible()
           
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

