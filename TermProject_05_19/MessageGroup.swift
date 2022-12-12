//
//  PlanGroup.swift
//  ch09-1871453-tableView
//
//  Created by SJH on 2022/04/27.
//

import Foundation
import FirebaseFirestore

class MessageGroup: NSObject{
    var messages = [Message]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var fromDate, toDate: Date?     // queryPlan 함수에서 주어진다.
    var database: Database!
    var parentNotification: ((Message?, DbAction?) -> Void)?
    
    init(parentNotification: ((Message?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        //database = DbMemory(parentNotification: receivingNotification) // 데이터베이스 생성
        //database = DbFile(parentNotification: receivingNotification) // 데이터베이스 생성
        database = DbFirebase(parentNotification: receivingNotification)
    }
    func receivingNotification(plan: Message?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let plan = plan{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addPlan(plan: plan)
                case .Modify: modifyPlan(modifiedPlan: plan)
                case .Delete: removePlan(removedPlan: plan)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(plan, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
    func clear(){
        for i in 0..<(messages.count){
        saveChange(plan: messages[i], action: .Delete)
        }
    }
}

extension MessageGroup{    // PlanGroup.swift
    
    func queryData(date: Date){
        messages.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        
        // date가 속한 1개월 +-알파만큼 가져온다
        fromDate = date.firstOfMonth().firstOfWeek()// 1일이 속한 일요일을 시작시간
        toDate = date.lastOfMonth().lastOfWeek()    // 이달 마지막일이 속한 토요일을 마감시간
        database.queryPlan(fromDate: fromDate!, toDate: toDate!)
    }
    
    func saveChange(plan: Message, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveChange(plan: plan, action: action)
    }
}

extension MessageGroup{     // PlanGroup.swift
    func getPlans(date: Date? = nil) -> [Message] {
        
        // plans중에서 date날짜에 있는 것만 리턴한다
        if let date = date{
            var planForDate: [Message] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for plan in messages{
                if plan.date >= start && plan.date <= end {
                    planForDate.append(plan)
                }
            }
            return planForDate
        }
        return messages
    }
}

extension MessageGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return messages.count }
    
    func isIn(date: Date) -> Bool{
        if let from = fromDate, let to = toDate{
            return (date >= from && date <= to) ? true: false
        }
        return false
    }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<messages.count{
            if key == messages[i].key{
                return i
            }
        }
        return nil
    }
}

extension MessageGroup{         // PlanGroup.swift
    private func addPlan(plan: Message){ messages.append(plan) }
    private func modifyPlan(modifiedPlan: Message){
        if let index = find(modifiedPlan.key){
            messages[index] = modifiedPlan
        }
    }
    private func removePlan(removedPlan: Message){
        if let index = find(removedPlan.key){
            messages.remove(at: index)
        }
    }
    func changePlan(from: Message, to: Message){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            messages[fromIndex] = to
            messages[toIndex] = from
        }
    }
}
