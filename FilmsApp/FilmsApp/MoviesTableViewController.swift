//
//  MoviesTableViewController.swift
//  FilmsApp
//
//  Created by Matthieudewit on 12/06/2017.
//  Copyright © 2017 Matthieudewit. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    struct Constants {
        static let CellReuseIdentifier = "filmCell"
    }
    
    var filmJaren = [String]()
    var films = [[Film]]()
    
    // MARK: - Standard Viewcontroller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // set up the refresh control
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        // show refreshControl during viewDidLoad event
        self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.size.height), animated: true)
        refreshControl!.beginRefreshing()
        
//        fetchDateThroughWebService(refreshControl!)
        fetchDateThroughWebServiceTest(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetch Data Functions
    
    func fetchDateThroughWebService_working(_ sender: UIRefreshControl) {
        let URLString = UserDefaults.sharedInstance.webServiceUrl
        let url = URL(string: URLString)
        let request = URLRequest(url: url!)
        
        filmJaren.removeAll()
        films.removeAll()
        tableView.reloadData()
        
        execTask(request: request) { (ok, responseCode, obj) in
            print("Back from request")
            
            if ok {
                print("ok")
                print("Request returned with statusCode: \(responseCode)")
                
                var filmsFound = [Film]()
                
                if let jsonFilms = obj as? [[String: Any]] {
                    for jsonFilm in jsonFilms {
                        
                        let newFilm = self.convertJsonToFilm(jsonFilm: jsonFilm)
                        
                        filmsFound.append(newFilm)
                        print(newFilm)
                    }
                    self.fillTableViewPerWeek(allFilms: filmsFound)
                }
            }
            else {
                print("not ok")
                print("Request returned with statusCode: \(responseCode)")
                
                let message = "URL: \(URLString)\n\n Returned with statusCode: \(responseCode)"
                
                self.displayAlert(title: "Error", message: message)
            }
            
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    func fetchDateThroughWebServiceTest(_ sender: UIRefreshControl) {
        let URLString = "http://filmsservice.mdwdevelopment.com/FilmsServiceTest.svc/json/films/"
        let url = URL(string: URLString)
        let request = URLRequest(url: url!)
        
        filmJaren.removeAll()
        films.removeAll()
        tableView.reloadData()
        
        execTask(request: request) { (ok, responseCode, obj) in
            print("Back from request")
            
            if ok {
                print("ok")
                print("Request returned with statusCode: \(responseCode)")
                
                var filmsFound = [Film]()
                
                if let jsonFilms = obj as? [[String: Any]] {
                    for jsonFilm in jsonFilms {
                        
                        let newFilm = self.convertJsonToFilmTest(jsonFilm: jsonFilm)
                        
                        filmsFound.append(newFilm)
                        print(newFilm)
                    }
                    self.fillTableViewPerWeek(allFilms: filmsFound)
                }
            }
            else {
                print("not ok")
                print("Request returned with statusCode: \(responseCode)")
                
                let message = "URL: \(URLString)\n\n Returned with statusCode: \(responseCode)"
                
                self.displayAlert(title: "Error", message: message)
            }
            
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }

    
    private func execTask(request: URLRequest, taskCallback: @escaping (Bool, Int,
        AnyObject?) -> ()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print("Starting request...")
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                print("Request executed succesfully")
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let response = response as? HTTPURLResponse {
                    print(response.description)
                    
                    if 200...299 ~= response.statusCode {
                        taskCallback(true, response.statusCode, json as AnyObject?)
                    }
                    else {
                        taskCallback(false, response.statusCode, json as AnyObject?)
                    }
                } else {
                    print(response!.description)
                    taskCallback(false, 999, json as AnyObject?)
                }
            }
            else {
                taskCallback(false, 999, nil)
            }
        })
        task.resume()
    }
    
    // MARK: - Helper Functions
    
    func fillTableViewPerWeek(allFilms: [Film]) {
        let firstfilm = allFilms.first!
        var currentYear = firstfilm.jaar
        self.filmJaren.append("Jaar \(currentYear)")
        var filmsPerJaar = [Film]()
        
        for (index,film) in allFilms.enumerated() {
            let jaarVanFilm = film.jaar
            if (currentYear == jaarVanFilm) {
                filmsPerJaar.append(film)
            }
            else {
                self.films.append(filmsPerJaar)
                filmsPerJaar.removeAll()
                currentYear = jaarVanFilm
                self.filmJaren.append("Jaar \(currentYear)")
                filmsPerJaar.append(film)
            }
            
            if (index == allFilms.count-1) {
                self.films.append(filmsPerJaar)
            }
        }
    }
    
    func convertJsonToFilm(jsonFilm: [String: Any]) -> Film {
        let id = jsonFilm["Id"] as? Int
        let titel = jsonFilm["Titel"] as? String
        let jaar = jsonFilm["Jaar"] as? Int
        let genre = jsonFilm["Genre"] as? String
        let regisseur = jsonFilm["Regisseur"] as? String
        let info = jsonFilm["Info"] as? String
        let linkUrl = jsonFilm["LinkUrl"] as? String
        let gezien = jsonFilm["Gezien"] as? Bool
        let dvd = jsonFilm["DVD"] as? Bool
        let gedownload = jsonFilm["Gedownload"] as? Bool
        
        return Film(id: id!, titel: titel!, jaar: jaar!, genre: genre!, regisseur: regisseur!, info: info!, linkUrl: linkUrl!, gezien: gezien!, dvd: dvd!, gedownload: gedownload!)
    }
    
    func convertJsonToFilmTest(jsonFilm: [String: Any]) -> Film {
        let id = jsonFilm["Id"] as? Int
        let titel = jsonFilm["Title"] as? String
        
        return Film(id: id!, titel: titel!)
    }
    
//    func getWeekNumber(date: Date) -> Int {
//        let calendar = Calendar.current
//        return calendar.component(.weekOfYear, from: date)
//    }
//    
//    func printWeekNumber(date: Date) {
//        let calendar = Calendar.current
//        let weekOfYear = calendar.component(.weekOfYear, from: date)
//        print("weekOfYear: \(weekOfYear)")
//    }
    
    func displayAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filmJaren.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = films[indexPath.section][indexPath.row].description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filmJaren[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: " + films[indexPath.section][indexPath.row].description)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var destinationViewController: MovieDetailsViewController = MovieDetailsViewController()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        destinationViewController = segue.destination as! MovieDetailsViewController
        
        if let indexPathSelectedRow = tableView.indexPathForSelectedRow {
            destinationViewController.selectedMovie = films[indexPathSelectedRow.section][indexPathSelectedRow.row]
        }
    }

}
