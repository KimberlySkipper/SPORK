


//
//  RecipeDetailViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/28/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var addGroceriesButton: UIButton!

    @IBOutlet weak var urlLinkButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientListTableView: UITableView!
    
    var myRecipe: RecipeInfo?
    var ingredientsFromAPI = [Ingredient]()
   // var recipeIngredientList: [String]? = ingredient.componentsSepatedBy String(" ")

    var uiImage: UIImage?
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Recipe"
        
        recipeNameLabel.text = myRecipe?.title
        recipeImage.image = uiImage
       // var ingredientsFromAPI: String = recipeIngredientList?.count
        
        
     //   recipeImage.image = UIImage(contentsOfFile: String)

        urlLinkButton.addTarget(self, action: Selector(("didTapLink")), for: .touchUpInside)
        
    }
    
    @IBAction func didTapLink(_ sender: UIButton)
    {
        if let url = (NSURL(string: (myRecipe?.href)!) as? URL)
        {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil )}
        
        
        
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
        return ingredientsFromAPI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let ingredient = ingredientsFromAPI[indexPath.row]
        cell.textLabel?.text = ingredient.name
        
        return cell
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
