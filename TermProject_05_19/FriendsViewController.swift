//
//  ViewController.swift
//  TermProject_05_19
//
//  Created by SJH on 2022/05/19.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var messageTextFeild: UITextField!
    @IBOutlet weak var messageTable: UITableView!
    
    var messageGroup: FriendGroup!
    var selectedDate: Date? = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        messageTable.dataSource = self
        messageTable.delegate = self
        
        messageGroup = MessageGroup(parentNotification: receivingNotigfication)
        messageGroup.queryData(date: Date())
        
        messageTable.rowHeight = UITableView.automaticDimension
         messageTable.estimatedRowHeight = 500

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self)
        navigationItem.title = Owner.getOwner()
        
    }

    @IBAction func logOutButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //    override func viewWillAppear(_ animated: Bool) {
//         super.viewWillAppear(animated)
//         self.navigationItem.hidesBackButton = true
//    }
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
    }
    
}

extension FriendsViewController{
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
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell")
        let plan = messageGroup.getPlans(date: nil)[indexPath.row]
        //cell?.textLabel?.text = plan.date.toStringDateTime()
        //cell?.detailTextLabel?.text = plan.content
        
//        (cell?.contentView.subviews[0] as! UILabel).text = plan.date.toStringDateTime()
        (cell?.contentView.subviews[0] as! UILabel).textAlignment = .left
        (cell?.contentView.subviews[2] as! UILabel).textAlignment = .left
        (cell?.contentView.subviews[0] as! UILabel).text = plan.content
        (cell?.contentView.subviews[2] as! UILabel).text = plan.date.toStringDateTime()
        (cell?.contentView.subviews[1] as! UILabel).text = plan.owner
//        cell?.layer.cornerRadius = 10
//        cell?.layer.borderWidth = 2
//        cell?.layer.borderColor = UIColor.red.cgColor
//        cell?.setwi
        //사용자와 보낸메시지 오너가 같을경우
        if (Owner.getOwner() == plan.owner){
            (cell?.contentView.subviews[0] as! UILabel).textAlignment = .right
            //(cell?.contentView.subviews[0] as! UILabel).text = ""
            //(cell?.contentView.subviews[4] as! UILabel).text = plan.content
           // (cell?.contentView.subviews[4] as! UILabel).textAlignment = .right
            (cell?.contentView.subviews[2] as! UILabel).textAlignment = .right
            (cell?.contentView.subviews[1] as! UILabel).text = " "
        }
        
//        cell.textLabel?.text = plan.content
//        cell.detailTextLabel?.text = plan.date.toStringDateTime()
        
//        cell?.accessoryType = .none
//        cell?.accessoryView = nil
//        if indexPath.row % 2 == 0 {
//            cell?.accessoryType = .detailDisclosureButton
//        }else{
//            cell?.accessoryView = UISwitch(frame: CGRect())
//        }
        
        return cell!
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension}
    

//    override func viewWillLayoutSubviews() {
//    super.viewWillLayoutSubviews()
//    super.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//    }
//
}


