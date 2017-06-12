//
//  UserDefaults.swift
//  FilmsApp
//
//  Created by Matthieudewit on 12/06/2017.
//  Copyright © 2017 Matthieudewit. All rights reserved.
//

import Foundation

class UserDefaults {
    
    static let sharedInstance = UserDefaults()
    
    private init() {}
    private let defaults = Foundation.UserDefaults.standard
    
    struct Constants {
        static let DefaultWebServiceUrlKey = "WebServiceUrl"
        static let DefaultWebServiceUrlSetting = "http://localhost/service?wsdl"
    }
    
    var webServiceUrl: String {
        get {
            if let defaultWebServiceUrl = defaults.object(forKey: Constants.DefaultWebServiceUrlKey) as? String {
                return defaultWebServiceUrl
            } else {
                return Constants.DefaultWebServiceUrlSetting
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultWebServiceUrlKey)
            defaults.synchronize()
        }
    }
}
