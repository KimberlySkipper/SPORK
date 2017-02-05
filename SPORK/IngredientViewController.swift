//
//  IngredientViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit



class IngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients = [Ingredient]()
    var api: EdamamAPIManager!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Ingredients"

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        let aGroceryItem = ingredients[indexPath.row]
        if aGroceryItem.name.isEmpty
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
       ingredients.append(Ingredient(ingredient: ""))
       tableView.insertRows(at: [IndexPath(row: ingredients.count-1, section: 0)], with: .automatic)
        
        
    }
     func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text != ""
        {
            let contentView = textField.superview
            let cell = contentView?.superview as! IngredientTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let newIngredient = ingredients[indexPath!.row]
            newIngredient.name = (cell.ingredientTextField?.text)!
            cell.ingredientTextField?.resignFirstResponder()
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var shouldReturn = false
        
        if textField.text != ""
        {
            shouldReturn = true
           let contentView = textField.superview
            let cell = contentView?.superview as! IngredientTableViewCell
    //        let indexPath = tableView.indexPath(for: cell)
    //        let newIngredient = ingredients[indexPath!.row]
    //        newIngredient.name = cell.ingredientTextField?.text
            cell.ingredientTextField?.resignFirstResponder()
            
        }
        
        return shouldReturn
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
           // var anIngredient = ingredients[indexPath.row]
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    @IBAction func recipeButtonWasTapped(_ sender: UIButton)
    {
        //api = RecipePuppyAPIManager(delegate: RecipeCollectionViewController.self as! RecipePuppyAPIManagerProtocol)
        //api.searchRPFor(listOfIngredients: ingredients)
    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as! RecipeCollectionViewController
        api = EdamamAPIManager(delegate: controller as EdamamAPIManagerProtocol)
        api.searchRPFor(listOfIngredients: ingredients)
    }
    

}//end class
