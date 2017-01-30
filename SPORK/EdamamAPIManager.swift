 import Foundation
 
 protocol EdamamAPIManagerProtocol
 {
    func didReceiveRecipeInfo(listOfRecipeInfo:[RecipeInfo])
 }
 
 class EdamamAPIManager
 {
    // setting a reference to this type
    var delegate: EdamamAPIManagerProtocol
    
    init(delegate: EdamamAPIManagerProtocol)
    {
        self.delegate = delegate
    }
    
    func searchRPFor(listOfIngredients:[Ingredient])
    {
        var recipes = [RecipeInfo]()
        //var listOfIngredients = [Ingredient]()
        var apiData = ""

        // loop through listOfIngredients and add each to data with comma's
        for i in listOfIngredients
        {
            apiData = apiData + "\(i.name!.replacingOccurrences(of: " ", with: "-"))" + ","
        }
        //let encodedName = apiData.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        
        let urlPath = "https://api.edamam.com/search?app_id=4f4a0765&app_key==\(apiData)"
        print(urlPath)
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
                if let results = dictionary["hits"] as? [[String: Any]]
                {
                    recipes = self.getRecipeInfoWithJSON2(results)
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
    func getRecipeInfoWithJSON2(_ results: [[String: Any]]) -> [RecipeInfo]
    {
        var listOfRecipes = [RecipeInfo]()
        
        for result in results
        {
            let dictionary = (result as [String: Any])["recipe"] as! [String: Any]
            let recipeTitle = dictionary["label"] as? String
            let recipeUrl = dictionary["url"] as? String
            let recipeIngredients = (dictionary["ingredientLines"] as? [String])
            let recipeImage = dictionary["image"] as? String ?? ""
            listOfRecipes.append(RecipeInfo(recipeTitle: recipeTitle!, recipeUrl: recipeUrl!, recipeIngredients: recipeIngredients!, recipeImage: recipeImage))
        }
        return listOfRecipes
    }
    
    
 }// end class
