//
//  EntryViewModel.swift
//  Notes
//
//  Created by Nodirbek on 10/05/22.
//

import Foundation

final class EntryViewModel {
    private var coreDataManager = CoreDataManager.shared
    
    func saveTask(title: String, note: String){
        coreDataManager.save(withTitle: title, withNote: note, id: UUID().uuidString)
    }
}
