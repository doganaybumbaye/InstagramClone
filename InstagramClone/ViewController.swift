//
//  ViewController.swift
//  InstagramClone
//
//  Created by Doğanay Şahin on 18.09.2021.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func signInButton(_ sender: Any) {
        if emailField.text != "" && passwordField.text != ""{
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { authresult, error in
                if error != nil {
                    self.makeAlert(title: "Login Err", message: error!.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Login failed", message: "Someting went Wrong")
        }
        
        
        
        
    }
    @IBAction func signUpButton(_ sender: Any) {
        
        if emailField.text != "" && passwordField.text != ""{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(title: "Errr", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            

        }else{
            makeAlert(title: "Error", message: "Username/Password missing.")

        }
    }
    func makeAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

