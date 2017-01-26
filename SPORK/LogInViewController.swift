//
//  ViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/23/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInUIDelegate
{
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        googleSignInButton.style = GIDSignInButtonStyle.standard
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
        
        
        
        title = "Log In or Sign Up"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

