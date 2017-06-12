//
//  MovieDetailsViewController.swift
//  FilmsApp
//
//  Created by Matthieudewit on 12/06/2017.
//  Copyright © 2017 Matthieudewit. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var selectedMovie: Film = Film()
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var jaarLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = selectedMovie.titel
        setMovieDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helper Functions
    
    // some help with formatting, check online: http://nsdateformatter.com
    
    func setMovieDetailLabels() {
        titelLabel.text = selectedMovie.titel
        jaarLabel.text = "\(selectedMovie.jaar)"
    }

}
