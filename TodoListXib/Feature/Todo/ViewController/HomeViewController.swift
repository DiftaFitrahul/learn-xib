//
//  HomeViewController.swift
//  TodoListXib
//
//  Created by MacBook Difta on 14/10/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var listTodo: [Todo] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        getTodo()
        // Do any additional setup after loading the view.
    }
    
    
    private func getTodo() {
        NetworkManager.shared.getTodo { [weak self] result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self?.configureTodo(todos: todos)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func configureTodo(todos: [Todo]){
        listTodo = todos
        updateTodoView(with: todos)
        
    }
   
    
    private func successDeleteTodo(id: String){
        listTodo.removeAll { todo in
          return  todo.id == id
        }
        updateTodoView(with: listTodo )
    }
    
    
    private func updateTodoView(with todos: [Todo]){
        for view in stackView.arrangedSubviews{
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for todo in todos{
            let todoItem = createTodoView(todo: todo)
            stackView.addArrangedSubview(todoItem)
        }
        
        stackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        
    }
    
    private func createTodoView(todo: Todo) -> TodoItem{
        let todoItemView = TodoItem()
        todoItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoItemView.widthAnchor.constraint(equalToConstant: stackView.frame.width),
            todoItemView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        todoItemView.delegate = self
        todoItemView.todoId = todo.id
        todoItemView.titleComp.text = todo.title
        todoItemView.descComp.text = todo.description
        
        
        return todoItemView
        
    }
    
    
    

    @IBAction func AddButton(_ sender: Any) {
        // Assuming the storyboard is "Main"
        let storyboard = UIStoryboard(name: "EditorStory", bundle: nil)

        // Instantiate the EditorViewController from the storyboard using its identifier
        if let editorView = storyboard.instantiateViewController(withIdentifier: "editorid") as? EditorViewController {
            editorView.delegate = self
            navigationController?.pushViewController(editorView, animated: true)
        }

    }
    

}

extension HomeViewController: TodoItemDelegate{
    func onDelTodo(todoId: String) {
    NetworkManager.shared.deleteTodo(id: todoId) { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.successDeleteTodo(id: todoId)
                }
            }
        }
    }
    
   
    
    
}

extension HomeViewController: EditorViewControllerDelegate{
    func onPopSuccesEditorTodo() {
        getTodo()
    }
    
    
}
