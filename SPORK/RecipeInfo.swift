//
//  RecipeInfo.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation
import Firebase

class RecipeInfo
{
    // where it is stored
    let title: String
    let href: String
    let ingredients: [Ingredient]
    let image: String
    var key: String?
    var gID: Int?
    
    var dbRef: FIRDatabaseReference!
    
    
    //how it is created
    //is it necessary to initialize the gID??
    init(recipeTitle: String, recipeUrl: String, recipeIngredients: [Ingredient], recipeImage: String)
    {
        self.title = recipeTitle
        self.href = recipeUrl
        self.image = recipeImage
        self.ingredients = recipeIngredients
    
    }
    
    // we use 
    init(recipeTitle: String, recipeUrl: String, recipeIngredients: [String], recipeImage: String)
    {
        self.title = recipeTitle
        self.href = recipeUrl
        self.image = recipeImage
        self.ingredients = Ingredient.changeArrayOfStringsToArrayOfIngredientObjects(oldStringArray: recipeIngredients)
        
    }
    // pasrse data coming back from Firebase
    static func createRecipeInfoWithJSON(_ dictionary: [String: Any]) -> RecipeInfo?
    {
        var recipeInfo: RecipeInfo?
    
                let recipeTitle = dictionary["title"] as? String ?? ""
                let recipeUrl = dictionary["href"] as? String ?? ""
                let recipeImage = dictionary["image"] as? String ?? ""
        
                // dont create a recipie info if it has no ingredients yet
                if let childDictionary = dictionary["ingredients"] as! [String: Any]?

                    {
                        var listOfIngredients = [Ingredient]()
                        for (key, value) in childDictionary
                        {
                            
                            let ingredientDic = value as! [String: Any]
                            let name = ingredientDic["name"] as? String ?? ""
                            let done = ingredientDic["status"] as! Bool
                            let anIngredient = Ingredient(ingredient: name, isDone: done, key: key)
                            listOfIngredients.append(anIngredient)
                        }
                        recipeInfo = RecipeInfo(recipeTitle: recipeTitle,recipeUrl: recipeUrl, recipeIngredients: listOfIngredients, recipeImage: recipeImage)
                    }
                
            return recipeInfo
    }

    
    func sendToFirebase()
    {
        dbRef = FIRDatabase.database().reference()
       // create a dictionary of dictionaries
        let recipeData: [String: Any] =
            ["gID": FIRGoogleAuthProviderID,
             "title": title,
             "href": href,
             "image": image]
        let recipeRef = dbRef?.child("recipes").childByAutoId()
        recipeRef?.setValue(recipeData)
        
        for anIngredient in ingredients
        {
            let ingredientJSON: [String: Any] = ["name": anIngredient.name, "status": anIngredient.done]
            recipeRef?.child("ingredients").childByAutoId().setValue(ingredientJSON)
        }
    }
    
   
   func sendEditToFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        
        let recipeData: [String: Any] =
            ["gID": FIRGoogleAuthProviderID,
             "title": title,
             "href": href,
             "image": image]
        let recipeRef = dbRef?.child("recipes").childByAutoId()
        recipeRef?.setValue(recipeData)
        
        for anIngredient in ingredients
        {
            let ingredientJSON: [String: Any] = ["name": anIngredient.name, "status": anIngredient.done]
            recipeRef?.child("ingredients").childByAutoId().setValue(ingredientJSON)
        }
        
        dbRef?.child("recipes").child(key!).setValue(recipeData)
    }
    
    func deleteFromFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        dbRef?.child("recipes").child(key!).removeValue()
    }
    
}// end class



