//
//  AdminViewController.swift
//  TermProject_05_19
//
//  Created by SJH on 2022/05/28.
//

import UIKit
import Firebase
import FirebaseAuth

class AdminViewController: UIViewController {

    @IBOutlet weak var systemMessageTextFeild: UITextField!
    @IBOutlet weak var blockOwnerTextFeild: UITextField!
    
    @IBOutlet weak var changePw: UITextField!
    @IBOutlet weak var doneSendlabel: UILabel!
    @IBOutlet weak var doneClearLabel: UILabel!
    
    var messageGroup: MessageGroup!
    var messagTable: UITableView!
    var countSend=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        doneSendlabel.text = ""
        doneClearLabel.text = ""
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
    }

    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }

    @IBAction func clearButton(_ sender: Any) {
        messageGroup.clear()

            let message = Message(date: nil, withData: false)
            message.content = ""
            message.owner = "SYSTEM"
        saveChange(plan: message)
        
        for i in 0...7{
            let message = Message(date: nil, withData: false)
            message.content = ""
            message.owner = ""
            saveChange(plan: message)
        }
        let message2 = Message(date: nil, withData: false)
        message2.content = "채팅방이 초기화 되었습니다."
        message2.owner = "SYSTEM"
        saveChange(plan: message2)
            
            systemMessageTextFeild.text = ""
        doneClearLabel.text = "전체삭제 완료"
        

    }
    
    
    @IBAction func systemMessageSendButton(_ sender: Any) {

        let inputMessage = systemMessageTextFeild.text
        if  inputMessage != ""{
            let message = Message(date: nil, withData: false)
            message.content = inputMessage!
            message.owner = "SYSTEM"
            saveChange(plan: message)
            
            systemMessageTextFeild.text = ""
            if countSend != 0{
            doneSendlabel.text = "전송완료("+String(countSend)+")"
            }
            else{
                doneSendlabel.text = "전송완료"
            }
            countSend += 1
        }
    }

    func saveChange(plan: Message?){
            messageGroup.saveChange(plan: plan!, action: .Add)
    }

}
