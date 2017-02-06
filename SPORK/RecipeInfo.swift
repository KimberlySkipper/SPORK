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
    init(recipeTitle: String, recipeUrl: String, recipeIngredients: [Ingredient], recipeImage: String)
    {
        self.title = recipeTitle
        self.href = recipeUrl
        self.image = recipeImage
        self.ingredients = recipeIngredients
    
    }
    
    // we use this initializer to init on API call
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

    //MARK: Firebase Functions
    
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
    
   
    func sendEditToFirebase(ingredientKey: String, status: Bool)
    {
        dbRef = FIRDatabase.database().reference()
        
        dbRef?.child("recipes").child(key!).child("ingredients").child(ingredientKey).child("status").setValue(status)
    }
    
    func deleteFromFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        //set value takes away the old information and replaces it with the new.
        dbRef?.child("recipes").child(key!).setValue(nil)
        dbRef?.child("recipes").child(key!).removeValue()
    }
    
}// end class



