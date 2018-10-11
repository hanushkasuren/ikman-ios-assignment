//
//  String+Trim.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation

extension String{
    
    func trim() -> String{
        
        let inputString = self
        let trimmedString = inputString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
}
