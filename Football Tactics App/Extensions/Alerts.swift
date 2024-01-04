//
//  Alerts.swift
//  Football Tactics App
//
//  Created by Erkan on 4.01.2024.
//

import Foundation
import UIKit

class Alerts {
    
    
    private init(){}
    
    static let shared = Alerts()
    
    
    func alertFunction(title: String, message: String) -> UIAlertController{
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        
        alertController.addAction(action)
        
        
        return alertController

    }
    
    
    
}
