


//
//  RecipeDetailViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/28/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var addGroceriesButton: UIButton!
    @IBOutlet weak var urlLinkButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientListTableView: UITableView!
    
    var myRecipe: RecipeInfo?
    var ingredientsFromAPI: [Ingredient]?
    var uiImage: UIImage?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Recipe"
        
        recipeNameLabel.text = myRecipe?.title
        recipeImage.image = uiImage
        ingredientsFromAPI = (myRecipe?.ingredients)!
    }
    
    @IBAction func didTapLink(_ sender: UIButton)
    {
        // fix for kraft recipies
        let kraftFixed = myRecipe?.href.replacingOccurrences(of: "kraftfoods", with: "kraftrecipes")
        if let url = (NSURL(string: (kraftFixed)!) as? URL)
        {
            print(myRecipe?.href ?? "OH NO!")
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil )}
        }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredientsFromAPI!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredientsFromAPI?[indexPath.row].name
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        myRecipe?.sendToFirebase()
        // Pass the selected object to the new view controller.
    }


}
