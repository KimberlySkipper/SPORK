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
    var newMedia: Bool?
    
    var shoppingItems = [RecipeInfo]()
   // var ingredients = [Ingredient]()
    var recipeNames: [String]?
    var aRecipe: RecipeInfo?
    var fbRefHandle: FIRDatabaseHandle!
    var dbRef: FIRDatabaseReference!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        configureDatabase()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: FIREBASE methods
    
    func configureDatabase()
    {
        //need to organize the data to look like what I want to return. I want a recipe object
        
        dbRef = FIRDatabase.database().reference()
        fbRefHandle = dbRef.child("recipes").observe(.childAdded, with: {(snapshot) -> Void in
            // print(snapshot.value)
            //must use self. in closure
            let recipe : RecipeInfo? = RecipeInfo.createRecipeInfoWithJSON(snapshot.value as! [String:Any])
            // ignore any partial created objects
            if(recipe != nil){
                recipe?.key = snapshot.key
                self.shoppingItems.append(recipe!)
            //let indexPath = IndexPath(row: self.ingredients.count, section: self.shoppingItems.count - 1)
            // self.shoppingTableView.insertRows(at: [indexPath], with: .automatic)
         
        //    self.shoppingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
               self.shoppingTableView.reloadData()
               
            }else{
                print("WARNING: GOT NIL!")
            }
        })
        
    }
    
    //MARK: Email functionality
   // https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
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
                //recipeString.append("</h1><b>\(recipeTitle)</b></h1>")
                
                let recipeLink = aRecipe.href
               // recipeString.append("<a href=\(recipeLink) ></a>")
                
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
            //(aRecipe?.href)! DOESNT WORK
        present(mail, animated: true)
        } else {
        print("Can not send email")
            }
    }
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ShoppingTableViewCell
        checkboxButtonWasTapped(cell.checkboxButton)
    }
    
    
    
    //MARK: Creating the SECTION VIEW
    
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
        //shoppingTableView.reloadData()
 
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
    
    
    
    //MARK: Editing Cells
    
    // Override to support conditional editing of the table view.
   /*func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
   // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
           //var aRecipe = shoppingItems[indexPath.row]
            shoppingItems.remove(at: indexPath.row)
           // shoppingTableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }*/
    
    
       /* if (editingStyle == UITableViewCellEditingStyle.Delete) {
            myPosts?.removeAtIndex(indexPath.section - 1)
            profileTableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.addIndex(indexPath.section - 1)
            profileTableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            // profileTableView.deleteRowsAtIndexPaths([indexPath],  withRowAnimation: UITableViewRowAnimation.Automatic)
            profileTableView.endUpdates()
     
        }
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    */
}//end class
