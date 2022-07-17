//
//  ViewController.swift
//  Snapchat App Clone
//
//  Created by Yavuz Güner on 15.07.2022.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if passwordTextField.text != nil && emailTextField.text != nil {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            self.makeAlert(title: "Error", message: "Username/E-mail/Password is Wrong")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameTextField.text != nil && passwordTextField.text != nil && emailTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ [self] (auth,error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    //Kullanıcı adını veritabanına kaydedeceğiz.
                    
                    let firestore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailTextField.text!, "username" : self.userNameTextField.text!] as! [String:Any]
                    firestore.collection("UserInfo").addDocument( data: userDictionary) { (error) in
                        if error != nil {
                            
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username/E-mail/Password is Wrong")
        }
    }
    
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

