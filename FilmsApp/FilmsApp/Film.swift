//
//  Film.swift
//  FilmsApp
//
//  Created by Matthieudewit on 12/06/2017.
//  Copyright © 2017 Matthieudewit. All rights reserved.
//

import Foundation

open class Film : CustomStringConvertible
{
    
    let id, jaar: Int
    let titel, genre, regisseur, info ,linkUrl: String
    let gezien, dvd, gedownload: Bool
    
    open var description: String { return buildDescriptionString() }
    
    init() {
        self.id = 0
        self.titel = ""
        self.jaar = 2017
        self.genre = ""
        self.regisseur = ""
        self.info = ""
        self.linkUrl = ""
        self.gezien = false
        self.dvd = false
        self.gedownload = false
    }
    
    // test
    init(id: Int, titel: String) {
        self.id = id
        self.titel = titel
        self.jaar = 2017
        self.genre = ""
        self.regisseur = ""
        self.info = ""
        self.linkUrl = ""
        self.gezien = false
        self.dvd = false
        self.gedownload = false
    }
    
    init(id: Int, titel: String, jaar: Int, genre: String, regisseur: String, info: String, linkUrl: String, gezien: Bool, dvd: Bool, gedownload: Bool) {
        self.id = id
        self.titel = titel
        self.jaar = jaar
        self.genre = genre
        self.regisseur = regisseur
        self.info = info
        self.linkUrl = linkUrl
        self.gezien = gezien
        self.dvd = dvd
        self.gedownload = gedownload
    }
    
    func buildDescriptionString() -> String {
        return "\(titel) (\(jaar))"
    }
}
