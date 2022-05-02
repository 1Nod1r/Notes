//
//  ViewController.swift
//  Notes
//
//  Created by Nodirbek on 01/05/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    var task: [Task] = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC(){
        title = "Notes"
        table.delegate = self
        table.dataSource = self
        if task.isEmpty {
            label.isHidden = true
            table.isHidden = false
        }
        else {
            label.isHidden = false
            table.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: "title", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "note", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            task = try context.fetch(fetchRequest)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didTapNewNote(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else { return }
        vc.title = "New"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {[weak self] noteTitle, note in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.save(withTitle: noteTitle, withNote: note)
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.navigationBar.tintColor = .label
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func save(withTitle title: String, withNote note: String){
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.note = note
        taskObject.title = title
        do {
            try context.save()
            task.insert(taskObject, at: 0)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteModel(with model: Task, completion: (Result<Void,Error>)->Void){
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
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = task[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.note
        cell.textLabel?.font = .systemFont(ofSize: 22)
        cell.detailTextLabel?.font = .systemFont(ofSize: 19)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else { return }
        vc.title = "Note"
        vc.note = task[indexPath.row].note
        vc.noteTitle = task[indexPath.row].title
        navigationController?.navigationBar.tintColor = .label
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteModel(with: self.task[indexPath.row]) { result  in
                switch result {
                case .success():
                    print("success in deleting object")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .none:
            break
        case .insert:
            break
        @unknown default:
            break
        }
        
    }
}

