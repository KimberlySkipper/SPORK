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
    var key: String?
    var name: String
    var done: Bool

    
    init(ingredient: String, isDone: Bool, key: String)
    {
        self.name = ingredient
        self.done = isDone
        self.key = key
    }
    
    init(ingredient: String)
    {
        self.name = ingredient
        self.done = false
    }
    // Changes the array of strings, from the API, to an array of Ingredient Objects.
    static func changeArrayOfStringsToArrayOfIngredientObjects(oldStringArray:[String]) -> [Ingredient]
    {
        var ingredientArray = [Ingredient]()
        
        for aString in oldStringArray
        {
            let anIngredient = Ingredient(ingredient: aString)
             ingredientArray.append(anIngredient)
            
        }
        return ingredientArray
        
    }
    
}// end class
