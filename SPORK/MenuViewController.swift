//
//  MenuViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/23/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowShoppingListSegue"
        {
            segue.destination as! ShoppingListViewController
        }
        
        // Pass the selected object to the new view controller.
    }

    @IBAction func fromShoppingListToMenu(segue: UIStoryboardSegue)
    {
        //no code necessary, but can add funtionality if needed.
    }

}// end class
