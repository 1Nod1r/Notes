//
//  ViewModel.swift
//  Notes
//
//  Created by Nodirbek on 10/05/22.
//

import Foundation

final class ViewModel {
    private let coreData = CoreDataManager.shared
    private var tasks = [Task]() {
        didSet {
            didChange?()
        }
    }
    
    init(){
        self.tasks = coreData.getTasks()
    }
    
    var didChange: (() -> Void)?
    
    func fetchNewTask(){
        coreData.fetchNewTask {[weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks.append(contentsOf: tasks)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchAllData(){
        coreData.fetchData {[weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTask(for index: Int) -> Task {
        return tasks[index]
    }

    func numberOfRows() -> Int {
        tasks.count
    }
    
    var tasksIsEmpty: Bool {
        tasks.isEmpty
    }
    
    func removeTask(at index: Int) {
        coreData.deleteModel(with: tasks[index]) { result in
            switch result {
            case .success():
                tasks.remove(at: index)
                print("deleted")
            case .failure(let error):
                print(error)
            }
        }
    }
}
