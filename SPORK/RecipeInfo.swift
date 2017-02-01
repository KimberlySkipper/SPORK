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
    
    init(recipeTitle: String, recipeUrl: String, recipeIngredients: [String], recipeImage: String)
    {
        self.title = recipeTitle
        self.href = recipeUrl
        self.image = recipeImage
        self.ingredients = Ingredient.changeArrayOfStringsToArrayOfIngredientObjects(oldStringArray: recipeIngredients)
        
    }
    static func createRecipeInfoWithJSON(_ dictionary: [String: Any]) -> RecipeInfo?
    {
        var recipeInfo: RecipeInfo?
        //recipeInfo = nil
    
        if let mainDictionary = dictionary["recipes"] as! [String: Any]?
            {
                let recipeTitle = dictionary["title"] as? String ?? ""
                let recipeUrl = dictionary["href"] as? String ?? ""
               // let recipeIngredients =
                let recipeImage = dictionary["image"] as? String ?? ""
                
                if let childDictionary = dictionary["ingredients"] as! [String: Any]?

                    //(dictionary["ingredients"] as? String)?.components(separatedBy: ",")
                    {
                        var listOfIngredients = [Ingredient]()
                        for (key, value) in childDictionary
                        {
                            let anIngredient = Ingredient()
                            let ingredientDic = value as! [String: Any]
                            let name = ingredientDic["name"] as? String ?? ""
                            let done = ingredientDic["status"] as! Bool
                            listOfIngredients.append(anIngredient)
                        }
                        recipeInfo = RecipeInfo(recipeTitle: recipeTitle,recipeUrl: recipeUrl, recipeIngredients: listOfIngredients, recipeImage: recipeImage)
                    }
                
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
             // "ingredients":[Ingredient].self]
            /*{
            let ingredientData: [String: Any] = ["name": ingredients.name,"status": ingredients.done]
            let shoppingListRef =
            }
            // "status": ingredients.done ?? false]*/
        dbRef?.child("recipes").childByAutoId().setValue(recipeData)
    }
    
   /* func sendEditToFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        
        let recipeData: [String: String] = ["title": title!,
                                         "href": href!,
                                         "image": image!]
                                        // "status": ingredients.done ?? false]
        dbRef?.child("shoppingList").child(key!).setValue(recipeData)
    }
    
    func deleteFromFirebase()
    {
        dbRef = FIRDatabase.database().reference()
        dbRef?.child("shoppingList").child(key!).removeValue()
    }*/
    
    }// end class

//let thumbnailURL = dictionary["artworkUrl60"] as? String ?? ""
//let imageURL = dictionary["artworkUrl100"] as? String ?? ""
//let artistURL = dictionary["artistViewUrl"] as? String ?? ""

//var itemURL = dictionary["collectionViewUrl"] as? String


