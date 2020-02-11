//
//  ViewController.swift
//  DexLink
//
//  Created by Sabath  Rodriguez on 8/4/19.
//  Copyright © 2019 Atomos. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
    }
    
    //controls getting rid of the keyboard once the user touches the background or "return" key
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    //-----------------------------------------------------------------------------
    
    @IBOutlet var usernameEmailLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        //checks if username and password are empty
        
        //start the loading indicator and freezes user interaction events
        let activtyIndicated = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 50, height: 50))
        activtyIndicated.center = self.view.center
        activtyIndicated.hidesWhenStopped = true
        activtyIndicated.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activtyIndicated)
        activtyIndicated.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if usernameEmailLabel.text != nil && passwordLabel != nil {
            var usernameNSString: NSString = NSString(string: usernameEmailLabel.text!)
            //checks if the password enter is valid
            var passwordNSString: NSString = NSString(string: passwordLabel.text!)
            
            // TODO: Ask alan what he wants to do about the password requirements
                
            //stops loading indicator
            activtyIndicated.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
            
            //checks if username contains an @ symbol, checking to see if a proper email
            if usernameNSString.contains("@") && usernameNSString.contains(".com") {
                //if everything entered is valid, checks server for login credentials
                PFUser.logInWithUsername(inBackground: usernameEmailLabel.text!, password: passwordLabel.text!) {
                    (user, error) in
                    
                    if let user = user {
                        // if the server says the user information is correct for logging in
                        self.performSegue(withIdentifier: "toHomeScreenSegue", sender: self)
                        
                        
                        //stops loading indicator
                        activtyIndicated.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    if let error = error {
                        //if the users login credentials are incorrect
                        self.displayAlert(information: "Error", message: "The username or password entered is not correct, please try again.", title: "Okay", secondTitle: nil)
                        
                        //stops loading indicator
                        activtyIndicated.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            } else {
                //warning if the user is not entering a proper email address.
                displayAlert(information: "Invalid Email", message: "The email address you are entering is not valid, please try again", title: "Okay", secondTitle: nil)
                
                //stops loading indicator
                activtyIndicated.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        } else {
            //if username or/and password are empty
            displayAlert(information: "Error", message: "username/password cannot be empty", title: "Okay", secondTitle: nil)
            
            //stops loading indicator
            activtyIndicated.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func displayAlert(information: String, message: String, title: String, secondTitle: String?) {
        let uiAlertController = UIAlertController(title: information, message: message, preferredStyle: UIAlertController.Style.alert)
        uiAlertController.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default) { (action) in
            print("button pressed")
            self.dismiss(animated: true, completion: nil)
        })
        
        if let secondAlert = secondTitle {
            uiAlertController.addAction(UIAlertAction(title: secondAlert, style: UIAlertAction.Style.default, handler: { (action) in
                print("second button presses")
                self.dismiss(animated: true, completion: nil)
            }))
        }
        self.present(uiAlertController, animated: true, completion: nil)
    }
    
    
}

