//
//  TodoItem.swift
//  TodoListXib
//
//  Created by MacBook Difta on 14/10/24.
//

import UIKit

protocol TodoItemDelegate: AnyObject{
    func onDelTodo(todoId: String)
}

class TodoItem: UIView {

    weak var delegate: TodoItemDelegate?
    var todoId: String!
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleComp: UILabel!
   
    @IBOutlet weak var descComp: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetUp()
        configureUI()
    }
    
    func xibSetUp(){
        view = loadingViewFromNib()
        view.frame = self.bounds
        addSubview(view)
    }
    
    func configureUI(){
        titleComp.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        descComp.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    func loadingViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TodoItem", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    @IBAction func delComp(_ sender: Any) {
        delegate?.onDelTodo(todoId: todoId)
    }
}
