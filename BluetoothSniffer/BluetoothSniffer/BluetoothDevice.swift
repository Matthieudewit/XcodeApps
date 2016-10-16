//
//  BluetoothDevice.swift
//  BluetoothSniffer
//
//  Created by Matthieu de Wit on 16-10-16.
//  Copyright © 2016 MdW Development. All rights reserved.
//

import Foundation

class BluetoothDevice {
    
    var name: String = ""
    var id: String = ""
    var major: Int = 0
    var minor: Int = 0
    var distance: String = ""
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    var description: String {
        get {
            return "\(name) (\(id)), location: \(distance)"
        }
    }
}
