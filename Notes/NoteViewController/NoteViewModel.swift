//
//  NoteViewModel.swift
//  Notes
//
//  Created by Nodirbek on 10/05/22.
//

import Foundation

final class NoteViewModel {
    private var coreDataManager = CoreDataManager.shared
    
    func saveTask(title: String, note: String, id: String?){
        
        coreDataManager.save(withTitle: title, withNote: note, id: id)
    }
}
