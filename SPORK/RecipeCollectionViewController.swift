//
//  RecipeCollectionViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/25/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class RecipeCollectionViewController: UICollectionViewController, EdamamAPIManagerProtocol
{

    var listOfRecipes = [RecipeInfo]()
     var api: EdamamAPIManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveRecipeInfo(listOfRecipeInfo: [RecipeInfo])
    {
        //FIXME: need to write code to conform to protocol
        
            listOfRecipes = listOfRecipeInfo
            if listOfRecipes.count == 0
            {
                showAlertWith(title: "Ingredients Invalid", message: "These ingredients do not return a recipe please enter new ingredients.")
                navigationController?.popViewController(animated: true)
            } else {
                //data was not loading correclty so creates a function called reload to allow the images to load asyncronuously.
                func reload()
                {
                    self.collectionView?.reloadData()
                }
                DispatchQueue.main.async(execute: reload)
        }
    }
    
    
    //Mark: UIAlertController
    
    func showAlertWith(title: String, message: String, Style: UIAlertControllerStyle = .alert)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: Style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissAlert(sender: UIAlertAction) -> Void
    {
       // this function is called in the showWithAlert function to dismiss the alert
         navigationController?.popViewController(animated: true)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of items
        return listOfRecipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! RecipeImageCell
        cell.backgroundColor = UIColor.white
        
        RecipeCollectionViewController.load_image(urlString: listOfRecipes[indexPath.row].image,imageView: cell.recipeThumbnail)
        cell.recipeTitleLabel.text = listOfRecipes[indexPath.row].title
       
        // Configure the cell
        return cell
    }
    
    //This function was largely copied from this VERY helpful internet post.  Please go visit them here: http://swiftdeveloperblog.com/code-examples/uiimageview-and-uiimage-load-image-from-remote-url/ After many tries, this finally loaded my images in the proper threads.  Thank you.
    
    static func load_image(urlString: String?, imageView: UIImageView)
    {
        if(urlString == nil)
        {
            return;
        }
        let imageURL:URL = URL(string: (urlString)!)!
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async
            {
                let imageData: NSData = NSData(contentsOf:imageURL)!
//                let imageView = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
//                let imageView.center = self.view.center
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    imageView.image = image
//                    imageView.contentMode = UIViewContentMode.scaleAspectFit
//                    self.view.addSubview(imageView)
                }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "DetailViewSegue"
        {
            // Get the new view controller using segue.destinationViewController.
            let detailVC = segue.destination as! RecipeDetailViewController
            let cell = sender as! RecipeImageCell
            let indexPath = collectionView?.indexPath(for: cell)!
            let oneRecipe = listOfRecipes[(indexPath?.row)!]
            detailVC.myRecipe = oneRecipe
            detailVC.uiImage = cell.recipeThumbnail.image
        }
        
    }

}
