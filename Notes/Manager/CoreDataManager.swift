//
//  CoreDataManager.swift
//  Notes
//
//  Created by Nodir Musayev on 10.05.2022.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var tasks: [Task] = [Task]()
    
     public func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    public func fetchData(completion: @escaping (Result<[Task], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        var request: NSFetchRequest<Task>
        request = Task.fetchRequest()
        do {
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func fetchNewTask(completion: @escaping (Result<[Task], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        var request: NSFetchRequest<Task>
        request = NSFetchRequest(entityName: "Task")
        let earlyDate = Calendar.current.date(
          byAdding: .second,
          value: -1,
          to: Date())!
        let datePredicate = NSPredicate(format: "updatedAt > %@", earlyDate as NSDate)
        request.predicate = datePredicate
        do {
            try context.save()
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func save(withTitle title: String, withNote note: String, id: String?){
        let context = getContext()
        guard let id = id else { return }
        let predicate = NSPredicate(format: "id=%@", id)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.predicate = predicate
        do {
            guard let result = try context.fetch(request) as? [Task] else { return }
            if !result.isEmpty {
                result[0].title = title
                result[0].note = note
                return
            }
        } catch {
            print(error)
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.note = note
        taskObject.id = id
        taskObject.title = title
        taskObject.updatedAt = Date()
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteModel(with model: Task, completion: (Result<Void,Error>)->Void){
        let context = getContext()
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
            print(error.localizedDescription)
        }
        
    }
    
    public func getTasks() -> [Task] {
        tasks
    }
    
}
