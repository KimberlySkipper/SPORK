//
//  ShoppingListViewController.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/28/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase
import MessageUI


class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var backToRecipesButton: UIButton!
    @IBOutlet weak var emailListButton: UIButton!
    @IBOutlet weak var returnToMenuButton: UIButton!
    
    
    var shoppingItems = [RecipeInfo]()
    var recipeNames: [String]?
    var aRecipe: RecipeInfo?
    var fbRefHandle: FIRDatabaseHandle!
    var dbRef: FIRDatabaseReference!
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Shopping List"
        configureDatabase()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: FIREBASE methods
    
    func configureDatabase()
    {
        dbRef = FIRDatabase.database().reference()
        fbRefHandle = dbRef.child("recipes").observe(.childAdded, with: {(snapshot) -> Void in
            
            let recipe : RecipeInfo? = RecipeInfo.createRecipeInfoWithJSON(snapshot.value as! [String:Any])
            // ignore any partial created objects
            if(recipe != nil){
                recipe?.key = snapshot.key
            self.shoppingItems.append(recipe!)
            self.shoppingTableView.reloadData()
               
            }else{
                print("WARNING: GOT NIL!")
            }
        })
        
    }
    
    //MARK: Email functionality
   // https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
    //The code below was mostly copied from the website above.  Thank you Paul from Hacking with Swift.
    func sendEmail() {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            //Iterate through the recipe info object, specifically the title and the ingredients(name) and assign them to a string to send in the email function. Added HTML to the string format the email.
            var recipeString = String()
            for aRecipe in shoppingItems
            {
                let recipeTitle = aRecipe.title
                let recipeLink = aRecipe.href
               
                //Use HTML to set title as a link to the recipe in the email.
                recipeString.append("</h1><b><a href='\(recipeLink)'>\(recipeTitle)</a></b></h1>")

                print(recipeString)
               for anIngredient in aRecipe.ingredients
                {
                    recipeString.append("<ul><li>\(anIngredient.name)</li></ul>")
                    print(recipeString)
                }
            }
       // mail.setToRecipients(["skipper.jason@gmail.com"])
        mail.setSubject("A Shopping List From SPORK")
        mail.setMessageBody(recipeString, isHTML: true)
        
        present(mail, animated: true)
        } else {
        print("Can not send email")
            }
    }
    
    // function dismisses the email controller back to the recipe when sent.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true)
    }
    
    
    //MARK: TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // number of RecipeInfo Objects
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //number of ingredient objects in a specific section.
        return (shoppingItems[section].ingredients.count)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       return shoppingItems[section].title
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingTableViewCell
    
       let anIngredient = self.shoppingItems[indexPath.section].ingredients[indexPath.row]
        cell.shoppingItemTextField.text = anIngredient.name
        if (anIngredient.done)
        {
           cell.checkboxButton.setImage(UIImage(named: "checkedBox"), for: .normal)
           
        }else{
            cell.checkboxButton.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        }
        //disabled used of keyboard for the shopping list
       cell.shoppingItemTextField.isEnabled = false
 
       
     return cell
    }
    
    //This funtion allows you to select the entire cell versus just checking the small box on the left.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ShoppingTableViewCell
        checkboxButtonWasTapped(cell.checkboxButton)
    }
    
    
    
    //MARK: Creating the SECTION VIEW
    //Must the heightForHeaderInSection when using the viewForHeaderInSection.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.darkGray
        
        // create label
        let label = UILabel()
        label.text = shoppingItems[section].title
        label.frame = CGRect(x: 45, y: 5, width: 250, height: 35)
        label.backgroundColor = UIColor.darkGray
        label.textColor = UIColor.white
        headerView.addSubview(label)
        //create image view
        let image = UIImageView()
        RecipeCollectionViewController.load_image(urlString: shoppingItems[section].image, imageView: image)
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        headerView.addSubview(image)
        //create delete button
        
        let deleteButton = UIButton()
        //removed auto resixeing to see if it fixed the icon traveling bug
         //deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.isEnabled = true
        deleteButton.setImage(#imageLiteral(resourceName: "trashBin3.png"), for: .normal)
        deleteButton.frame = CGRect(x: 330, y: 5, width: 35, height: 35)
        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        //Used the UIButton property .tag to store the index of a specific button.
        deleteButton.tag = section
        headerView.addSubview(deleteButton)

        return headerView
    }
    
    //MARK: Action Handlers
    
    @IBAction func emailWasTapped(_ sender: Any)
    {
        sendEmail()
    }
   
    
    @IBAction func checkboxButtonWasTapped(_ sender: UIButton)
    {
        let contentView = sender.superview
        let cell = contentView?.superview as! ShoppingTableViewCell
        let indexPath = shoppingTableView.indexPath(for: cell)
        let aRecipe = shoppingItems[indexPath!.section]
        let anItem = aRecipe.ingredients[(indexPath?.row)!]
        if (anItem.done)
            {
                anItem.done = false
            }
            else
            {
                anItem.done = true
 
            }
        aRecipe.sendEditToFirebase(ingredientKey: anItem.key!, status: anItem.done)
        //Used this method instead of reloadData() because the image was flashing when checking the box, now it will only effect the cellsin stead ofthe section.
        shoppingTableView.reloadRows(at: [indexPath!], with: .middle)
    }
    
    func didPressDelete(_ sender: UIButton)
    {
        shoppingTableView.beginUpdates()
        //1. remove item from the array
        let removedRecipe = shoppingItems.remove(at: sender.tag)
        //2. delete from firebase
        removedRecipe.deleteFromFirebase()
        //3. delete from the UI (section)
        shoppingTableView.deleteSections([sender.tag], with: .automatic)
        shoppingTableView.endUpdates()
    }
    
    
    @IBAction func searchGroceriesAction(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "ShowMapSegue", sender: UIBarButtonItem())
    }
    
}//end class
