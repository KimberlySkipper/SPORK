//
//  RecipeInfo.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation

class RecipeInfo
{
    // where it is stored
    let title: String
    let href: String
    let ingredients: String
    let thumbnail: String
    //how it is created
    init(recipeTitle: String, recipeUrl: String, recipeIngredients: String, recipeImage: String)
    {
        self.title = recipeTitle
        self.href = recipeUrl
        self.ingredients = recipeIngredients
        self.thumbnail = recipeImage
    }
    
    
    static func getRecipeInfoWithJSON(_ results: [String: Any]) -> [RecipeInfo]
    {
       var listOfRecipes = [RecipeInfo]()
        
        for result in results
        {
            if let dictionary = result as? [String: Any]
            {
                let recipeTitle = dictionary["title"] as? String
                let recipeUrl = dictionary["href"] as? String
                let recipeIngredients = dictionary["ingredients"] as? String
                let recipeImage = dictionary["thumbnail"] as? String ?? ""
                listOfRecipes.append(RecipeInfo(recipeTitle: recipeTitle!, recipeUrl: recipeUrl!, recipeIngredients: recipeIngredients!, recipeImage: recipeImage))
                
            }
            
            
            
        }
        return listOfRecipes
    }
    
    
}// end class

//let thumbnailURL = dictionary["artworkUrl60"] as? String ?? ""
//let imageURL = dictionary["artworkUrl100"] as? String ?? ""
//let artistURL = dictionary["artistViewUrl"] as? String ?? ""

//var itemURL = dictionary["collectionViewUrl"] as? String


