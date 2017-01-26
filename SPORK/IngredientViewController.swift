//
//  IngredientViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecipePuppyAPIManagerProtocol
{
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients = [Ingredient]()
    var api: RecipePuppyAPIManager!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ingredients"
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        let aGroceryItem = ingredients[indexPath.row]
        if aGroceryItem.name == nil
        {
            cell.ingredientTextField?.becomeFirstResponder()
        }
        else
        {
            cell.ingredientTextField?.text = aGroceryItem.name
        }
        return cell
        
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem)
    {
       // create a new object and append the list
       ingredients.append(Ingredient())
       tableView.insertRows(at: [IndexPath(row: ingredients.count-1, section: 0)], with: .automatic)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var shouldReturn = false
        
        if textField.text != ""
        {
            shouldReturn = true
            let contentView = textField.superview
            let cell = contentView?.superview as! IngredientTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let newIngredient = ingredients[indexPath!.row]
            newIngredient.name = cell.ingredientTextField?.text
            cell.ingredientTextField?.resignFirstResponder()
            
        }
        
        return shouldReturn
    }
    
    func didReceiveRecipeInfo(listOfRecipeInfo: [RecipeInfo])
    {
        //FIXME: need to write code to conform to protocol
    }
    
    @IBAction func recipeButtonWasTapped(_ sender: UIButton)
    {
        api = RecipePuppyAPIManager(delegate: self)
        api.searchRPFor(listOfIngredients: ingredients)
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}//end class
