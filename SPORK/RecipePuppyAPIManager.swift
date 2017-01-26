//
//  RecipePuppyAPIManager.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation

protocol RecipePuppyAPIManagerProtocol
{
    func didReceiveRecipeInfo(listOfRecipeInfo:[RecipeInfo])
}

class RecipePuppyAPIManager
{
    // setting a reference to this type
    var delegate: RecipePuppyAPIManagerProtocol
    
    init(delegate: RecipePuppyAPIManagerProtocol)
    {
        self.delegate = delegate
    }
    
    func searchRPFor(listOfIngredients:[Ingredient])
    {
        var recipes = [RecipeInfo]()
        //var listOfIngredients = [Ingredient]()
        var apiData = ""
        
        for i in listOfIngredients
        {
            apiData = apiData + "\(i.name!)" + ","
        }
        
        // loop through listOfIngredients and add each to data with comma's 
        
        let urlPath = "http://www.recipepuppy.com/api/?i=\(apiData)&p=1"
        let url = URL(string: urlPath)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            if error != nil
            {
                print(error!.localizedDescription)
            }
            
            if let dictionary = self.parseJSON(data!)
            {
                // call function from the recipe info class
                if let results = dictionary["results"] as? [[String: Any]]
                    {
                        recipes = RecipeInfo.getRecipeInfoWithJSON(results)
                    self.delegate.didReceiveRecipeInfo(listOfRecipeInfo: recipes)
                    }
            }
        })
        task.resume()
        
        
    }
    
    func parseJSON(_ data: Data) -> [String: Any]?
    {
        do
        {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any]
            {
                return dictionary
            }
            else
            {
                return nil
            }
        }
        catch let error as NSError
        {
            print(error)
            return nil
        }
    }

}// end class







