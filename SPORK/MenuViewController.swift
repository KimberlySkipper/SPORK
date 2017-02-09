//
//  MenuViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/23/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MenuViewController: UIViewController
{

   override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    //Home button from the ShoppingListViewController to UNWIND back to HOME "Menu" page
    @IBAction func fromShoppingListToMenu(segue: UIStoryboardSegue)
    {
        //no code necessary, but can add funtionality if needed.
    }
    
    @IBAction func logOutBarButton(_ sender: UIBarButtonItem)
    {
        GIDSignIn.sharedInstance().signOut()
        AppState.sharedInstance.signedIn = false
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print ("user is signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        //FIXME: change user to available = false
        let _ = self.navigationController?.popViewController(animated: true)
    }


}// end class
