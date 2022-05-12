//
//  NoteViewController.swift
//  Notes
//
//  Created by Nodirbek on 01/05/22.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    var id: String?
    var viewModel: NoteViewModel!
    
    public var noteTitle: String?
    public var note: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = noteTitle
        noteField.text = note
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        navigationController?.popViewController(animated: true)
        guard titleField.hasText, noteField.hasText else { return }
        guard let title = titleField.text, let note = noteField.text else { return }
        viewModel.saveTask(title: title, note: note, id: id)
        print("id \(id)")
    }

    
}
