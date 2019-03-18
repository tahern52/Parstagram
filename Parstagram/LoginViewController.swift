//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Taher on 3/17/19.
//  Copyright © 2019 codepath. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.usernameField.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else {
                print("An error occurred: \(error?.localizedDescription ?? "No error data available")")
            }
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        // Alert dialog for invalid sign in attempt
        let invalidLoginAlert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
        invalidLoginAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        // Attempt log in
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user, error) in
            if user != nil {
                self.usernameField.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else {
                self.present(invalidLoginAlert, animated: true)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
