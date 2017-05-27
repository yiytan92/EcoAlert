//
//  FBLoginVC.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 5/9/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginVC: UIViewController, FBSDKLoginButtonDelegate{
    
    var loginButton : FBSDKLoginButton!

    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var AppImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppImage.image = UIImage(named:"EcoAlertImage")
        
        loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if (error != nil) {
            errorMessageLabel.text = "\(error)"
            
        } else if(result.token != nil) {
            self.dismiss(animated: true, completion: nil)
            if(FBSDKAccessToken.current() != nil){
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                print("Logged in")
            }
            
        } else {
            errorMessageLabel.text = "Unknown error occured"
        }
        
        
        
        print("loginButton didCompleteWith \(error)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
    }

    
    
    
    
}
