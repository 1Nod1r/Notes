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
    
    var viewModel = EntryViewModel()
    
    public var completion: ((String,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        noteField.delegate = self
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc private func didTapSave(){
        guard let text = titleField.text, let note = noteField.text else { return }
            self.viewModel.saveTask(title: text, note: note)
            completion?(text, noteField.text)
    }
    
    private func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

extension EntryViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            DispatchQueue.main.async {
                self.titleField.reloadInputViews()
                self.noteField.reloadInputViews()
            }
            
            completion?(text, noteField.text)
        }
        return true
    }
}
