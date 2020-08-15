//
//  UserSettings.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/15/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import Foundation

final class UserSettings {
    
    static func allowVibration() -> Bool {
        if let string = UserDefaults.standard.object(forKey: DefaultsKeys.allowVibration) as? String, string == "false" {
            return true // hardcode
            //return false
        }
        return true
    }
}

struct DefaultsKeys {
    
    static let allowVibration = "allowVibration"
}
