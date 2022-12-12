//
//  ViewController.swift
//  TermProject_05_19
//
//  Created by SJH on 2022/05/19.
//

import UIKit
import FirebaseFirestore
import NotificationCenter
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var messageTextFeild: UITextField!
    
    @IBOutlet weak var admin: UIBarButtonItem!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var messageTable: UITableView!
    var WithoutKeyboard: NSLayoutConstraint?
    var WithKeyboard: NSLayoutConstraint?
    var keyboardBoolean: Bool = true
    var messageGroup: MessageGroup!
    var selectedDate: Date? = Date()
    var owner: Owner!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveImage), name: Notification.Name("doneOwner"), object: nil)
        
        // Do any additional setup after loading the view.
        messageTable.dataSource = self
        messageTable.delegate = self
        
        messageGroup = MessageGroup(parentNotification: receivingNotigfication)
        messageGroup.queryData(date: Date())
        
        messageTable.rowHeight = UITableView.automaticDimension
         messageTable.estimatedRowHeight = 500

        
        // NotificationCenter에 옵저버 등록을 한다.
        // 키보드가 나타나면 keyboardWillShow 함수를 호출한다
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil )
        // 키보드가 사라지면 keyboardWillHide 함수를 호출한다
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil )

        hideKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self)
        navigationItem.title = Owner.getOwner()
        messageTable.reloadData()
        
        if Owner.getOwner() != ""{
            keyboardBoolean = false
        }
    }
        

    @IBAction func adminButton(_ sender: Any) {
        performSegue(withIdentifier: "adminAuth", sender: self)
    }
    @IBAction func logOutButton(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func sendButton(_ sender: Any) {
        let inputMessage = messageTextFeild.text
        if  inputMessage != ""{
            let message = Message(date: nil, withData: false)
            message.content = inputMessage!
            saveChange(plan: message)
            
            messageTextFeild.text = ""
        }
    }
    
    func receivingNotigfication(plan: Message?, action: DbAction?){
        
        messageTable.reloadData()
        if  messageGroup.messages.count > 10{
        let endIndex = IndexPath(row:messageGroup.getPlans().count-1, section: 0)
        messageTable.scrollToRow(at: endIndex, at: .bottom, animated: true)
        }
    }
    
}

extension ViewController{
    @objc private func receiveImage(_ notification: Notification){
        
        navigationItem.title = Owner.getOwner()
        let message = Message(date: nil, withData: false)
        message.content = Owner.getOwner() + "님이 입장했습니다."
        message.owner = "SYSTEM"
        saveChange(plan: message)
    }
    
}

extension ViewController{
    @objc private func keyboardWillShow(_ notification: Notification) {
        // landscape에서는 아예 리턴하자
        if UIApplication.shared.statusBarOrientation.isLandscape { return}
        if  keyboardBoolean == true{return}
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                       let keyboardRectangle = keyboardFrame.cgRectValue
                       let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                            self.view.window?.frame.origin.y -= keyboardHeight
                
                        }
               }
        keyboardBoolean = true
}
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // landscape에서는 아예 리턴하자
        
        keyboardBoolean = false
        if UIApplication.shared.statusBarOrientation.isLandscape {return}
        if self.view.window?.frame.origin.y != 0 {
                    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                            let keyboardRectangle = keyboardFrame.cgRectValue
                            let keyboardHeight = keyboardRectangle.height
                        UIView.animate(withDuration: 1) {
                            self.view.window?.frame.origin.y += keyboardHeight
                        }
                    }
                }
    }
}


extension ViewController{
    func saveChange(plan: Message?){
        if messageTable.indexPathForSelectedRow != nil{
            messageGroup.saveChange(plan: plan!, action: .Modify)
        }else{
            messageGroup.saveChange(plan: plan!, action: .Add)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageGroup.getPlans().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell")
        let plan = messageGroup.getPlans(date: nil)[indexPath.row]
        
        let contentLabel = (cell?.contentView.subviews[0] as! UILabel)
        let ownerLabel = (cell?.contentView.subviews[1] as! UILabel)
        let dateLabel = (cell?.contentView.subviews[2] as! UILabel)
        
        //상대방이 보낸 경우(기본 레이아웃)
        contentLabel.textColor = .black
        contentLabel.textAlignment = .left
        dateLabel.textAlignment = .left
        contentLabel.text = plan.content
        dateLabel.text = plan.date.toStringDateTime()
        ownerLabel.text = plan.owner

        //사용자와 보낸메시지 오너가 같을경우
        if (Owner.getOwner() == plan.owner){
            contentLabel.textAlignment = .right
            dateLabel.textAlignment = .right
            ownerLabel.text = ""
        }
        
        //시스템이 보낸 메시지 일 경우
        if (plan.owner == "SYSTEM"){
            ownerLabel.text = ""
            contentLabel.text = "SYSTEM"
            contentLabel.textColor = .blue
            contentLabel.textAlignment = .center
            dateLabel.text = plan.content
            dateLabel.textAlignment = .center
        }
        //빈메시지 일경우 데이트도 비우기
        if (plan.owner == "" && plan.content == ""){
                dateLabel.text = ""
        }
        return cell!
    }
    
}

extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminAuth"{
            let svc = segue.destination as! AdminAuthViewController
            svc.messageGroup = self.messageGroup
            svc.messageTable = self.messageTable
        }
    }
}
