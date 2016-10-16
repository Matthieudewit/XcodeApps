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
    var uuid: String = ""
    var major: Int = 0
    var minor: Int = 0
    var distance: String = ""
    
    init(name: String, uuid: String) {
        self.name = name
        self.uuid = uuid
    }
    
    init(name: String, uuid: String, major: Int, minor: Int) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    var description: String {
        get {
            return "\(name) (\(uuid)), location: \(distance)"
        }
    }
}
