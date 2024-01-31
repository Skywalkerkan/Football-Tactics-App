//
//  Localized.swift
//  Football Tactics App
//
//  Created by Erkan on 29.01.2024.
//

import Foundation
import UIKit

extension String{
    
    
    func localized() -> String{
        
        return NSLocalizedString(self, tableName: "Localizable",
                                 bundle: .main, value: self,
                                 comment: self)
        
        
    }
    
    func localizedString(str: String) -> String{
        
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil,
                                 bundle: bundle!, value: self,
                                 comment: self)
        
        
    }
    
    
    
}
