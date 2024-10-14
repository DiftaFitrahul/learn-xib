//
//  EditorViewController.swift
//  TodoListXib
//
//  Created by MacBook Difta on 14/10/24.
//

import UIKit

protocol EditorViewControllerDelegate: AnyObject {
    func onPopSuccesEditorTodo()
}

class EditorViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var desctField: UITextField!
    
    weak var delegate: EditorViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Editor"
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        NetworkManager.shared.postTodo(todo: PostTodo(title: titleField.text!, description: desctField.text!)) { isSuccess in
            if isSuccess{
                DispatchQueue.main.async {
                    self.delegate?.onPopSuccesEditorTodo()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}


