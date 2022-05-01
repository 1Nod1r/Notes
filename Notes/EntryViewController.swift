//
//  EntryViewController.swift
//  Notes
//
//  Created by Nodirbek on 01/05/22.
//

import UIKit
import CoreData

class EntryViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc private func didTapSave(){
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            DispatchQueue.main.async {
                self.titleField.reloadInputViews()
                self.noteField.reloadInputViews()
            }
            completion?(text, noteField.text)
        }
    }
    
    private func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
