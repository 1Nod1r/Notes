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
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        setupBindings()
        viewModel.fetchAllData()
    }
    
    func setupBindings(){
        viewModel.didChange = {[weak self] in
            DispatchQueue.main.async {
                self?.configureVC()
                self?.table.reloadData()
            }
        }
    }
    
    private func configureVC(){
        let state = viewModel.tasksIsEmpty
        label.isHidden = state ? false : true
        table.isHidden = state ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNewTask()
    }
    
    func configureTableView(){
        table.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }
    
    @IBAction func didTapNewNote(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else { return }
        vc.title = "New"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {[weak self] noteTitle, note in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.navigationBar.tintColor = .label
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath) as! MainTableViewCell
        let task = viewModel.getTask(for: indexPath.row)
        cell.configure(title: task.title, secondaryText: task.note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else { return }
        vc.title = "Note"
        let task = viewModel.getTask(for: indexPath.row)
        vc.note = task.note
        vc.id = task.id
        vc.viewModel = NoteViewModel()
        vc.noteTitle = task.title
        navigationController?.navigationBar.tintColor = .label
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            viewModel.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        case .none:
            break
        case .insert:
            break
        @unknown default:
            break
        }
        
    }
    
    
}

