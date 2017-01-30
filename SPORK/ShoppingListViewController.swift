//
//  ShoppingListViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/28/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var backToRecipesButton: UIButton!
    @IBOutlet weak var emailListButton: UIButton!
    @IBOutlet weak var returnToMenuButton: UIButton!
    
    var shoppingItems = [RecipeInfo]()
    var recipeNames: [String]?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
    
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // number of RecipeInfo Objects
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (shoppingItems[section].ingredients.count)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       return shoppingItems[section].title
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingTableViewCell
    
        let anIngredient = self.shoppingItems[indexPath.section].ingredients[indexPath.row]
        cell.shoppingItemTextField.text = anIngredient.name
        if (anIngredient.done)!
        {
           cell.checkboxButton.setImage(UIImage(named: "checkedBox"), for: .normal)
           
        }else{
            cell.checkboxButton.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        }
       
      return cell
    }
    
    @IBAction func checkboxButtonWasTapped(_ sender: UIButton)
    {
        let contentView = sender.superview
        let cell = contentView?.superview as! ShoppingTableViewCell
        let indexPath = shoppingTableView.indexPath(for: cell)
        let aRecipe = shoppingItems[indexPath!.section]
        let anItem = aRecipe.ingredients[(indexPath?.row)!]
        if (anItem.done)!
            {
                anItem.done = false
            }
            else
            {
                anItem.done = true
 
            }
        shoppingTableView.reloadData()
 
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
           // var aRecipe = shoppingItems[indexPath.row]
            shoppingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}//end class

