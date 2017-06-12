//
//  LoginViewController.swift
//  FilmsApp
//
//  Created by Matthieudewit on 12/06/2017.
//  Copyright © 2017 Matthieudewit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    struct Messages {
        static let UserOrPassEmpty = "Username or password can't be empty!"
        static let UserOrPassInCorrect = "Username or password is incorrect!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        warningLabel.isHidden = true
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        warningLabel.isHidden = true
        
        if areFieldsEmpty() {
            setWarning(warning: Messages.UserOrPassEmpty)
            return false
        }
        else {
            if usernamePasswordCorrect() {
                return true
            }
            else {
                setWarning(warning: Messages.UserOrPassInCorrect)
                return false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func areFieldsEmpty() -> Bool {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            return true
        }
        else {
            return false
        }
    }
    
    func usernamePasswordCorrect() -> Bool {
        if ((usernameTextField.text?.lowercased())! == "mdw" && passwordTextField.text?.lowercased() == "mdw") {
            return true
        }
        else {
            return false
        }
    }
    
    func setWarning(warning: String) {
        warningLabel.isHidden = false
        warningLabel.text = warning
    }

}
