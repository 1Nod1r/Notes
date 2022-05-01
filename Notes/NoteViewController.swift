//
//  NoteViewController.swift
//  Notes
//
//  Created by Nodirbek on 01/05/22.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var noteTitle: String?
    public var note: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = noteTitle
        noteField.text = note
    }
}
