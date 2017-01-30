//
//  Ingredient.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation

class Ingredient
{
    var name: String?
    var done: Bool?
    
    init ()
    {}
    
    init(ingredient: String)
    {
        self.name = ingredient
    }
    // make function to change the string array(from ingrediants in the RecipeInfo object) to object array
    static func changeArrayOfStringsToArrayOfIngredientObjects(oldStringArray:[String]) -> [Ingredient]
    {
        var ingredientArray = [Ingredient]()
        
        for aString in oldStringArray
        {
            let anIngredient = Ingredient()
            anIngredient.done = false
            anIngredient.name = aString

             ingredientArray.append(anIngredient)
            
        }
        return ingredientArray
        
    }
    
    

}// end class
