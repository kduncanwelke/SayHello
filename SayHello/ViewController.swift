//
//  ViewController.swift
//  SayHello
//
//  Created by Kate Duncan-Welke on 2/19/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadName()
    }
    
    // MARK: Custom functions
    
    func updateGreeting() {
        // update greeting based on presence of name
        if let name = Name.loaded?.name {
            greetingLabel.text = "Hello \(name)!"
            saveButton.setTitle("   Resave Name   ", for: .normal)
        } else {
            greetingLabel.text = "Hello!"
            saveButton.setTitle("   Save Name   ", for: .normal)
        }
    }
    
    func loadName() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<SavedData>(entityName: "SavedData")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            // get the first item in the fetchrequest array
            if let data = result.first {
                // put SavedData object into loaded and update greeting
                Name.loaded = data
                updateGreeting()
            }
            print("total loaded")
            
        } catch let error as NSError {
            // handle error
        }
    }
    
    func saveName() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // if there is no text in the textField, don't continue
        guard let enteredText = textField.text else { return }
        
        guard let currentName = Name.loaded else {
            // there is no existing save - create a new object
            let nameSave = SavedData(context: managedContext)
            
            nameSave.name = enteredText
            Name.loaded = nameSave
            
            do {
                try managedContext.save()
                print("saved")
            } catch {
                // handle errors
            }
        
            // update greeting, reset textfield
            updateGreeting()
            textField.text = nil
            return
        }
        
        // we passed the guard statement so a save exists - update the existing object
        currentName.name = enteredText
        Name.loaded = currentName
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // handle errors
        }
        
        // update greeting, reset textfield
        updateGreeting()
        textField.text = nil
    }
    
    func deleteName() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        guard let toDelete = Name.loaded else { return }
        managedContext.delete(toDelete)
        
        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to save")
        }
        
        // reset loaded to nil, as the object has been deleted
        Name.loaded = nil
        updateGreeting()
    }

    
    // MARK: IBActions
    
    @IBAction func savePressed(_ sender: UIButton) {
        saveName()
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        deleteName()
    }

}

