//
//  ViewController.swift
//  task
//
//  Created by A on 6/25/18.
//  Copyright © 2018 task. All rights reserved.
//

import UIKit
import SwiftMQTT


class mainVC: UIViewController, MQTTSessionDelegate {
    
   var mqtSession = MQTTSession(host: "m10.cloudmqtt.com", port: 19484, clientID: "firstClient", cleanSession: false, keepAlive: 60)
  
    var topicTitles = ["Topic/topic1", "Topic/topic2", "Topic/topic3"]
    
    var messages: [String] = []
    
    var getMessagesMode: Bool = false
    
    var subscirbesTableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = UIColor.lightGray
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
    }()
    
    var publicationsTableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        return tableView
        
    }()
    
    var topicTextField: UITextField = {
       
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Type Topic Name"
        
        return textField
        
    }()
    
    var messageTextField: UITextField = {
        
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Type Message"
        
        return textField
    }()
    
    var publishBtn: UIButton = {
        
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setTitle("Publish Message", for: .normal)
        
        btn.backgroundColor = UIColor.lightGray
        
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.addTarget(self, action: #selector(publishMessage), for: .touchUpInside)
        
        return btn
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mqtSession.username = "jjpkfkba"
        
        mqtSession.password = "NOauq8BwlPEZ"
        
        mqtSession.delegate = self
        
        mqtSession.connect { (status, error) in
            
            if  status  {
                
                print("connected")
            } else {
                
                print("error is \(error.localizedDescription)")
            }
        }
        
        
        
        showSubscibeTable()
        
        showPublicationTable()
        
        showPublishArea()
    }
    
    func showSubscibeTable() {
        
        subscirbesTableView.delegate = self
        
        subscirbesTableView.dataSource = self
        
        self.view.addSubview(subscirbesTableView)
        
        subscirbesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15.0).isActive = true
        
        subscirbesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        
        subscirbesTableView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        subscirbesTableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
        
    }
    
    func showPublicationTable() {
        
        
        self.view.addSubview(publicationsTableView)
        
        publicationsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15.0).isActive = true
        
        publicationsTableView.leftAnchor.constraint(equalTo: subscirbesTableView.rightAnchor, constant: 5.0).isActive = true
        
        publicationsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        
        publicationsTableView.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 5).isActive = true
        
        publicationsTableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
    }
    
    func showPublishArea() {
        
       self.view.addSubview(topicTextField)
        
       self.view.addSubview(messageTextField)
        
       self.view.addSubview(publishBtn)
        
       topicTextField.topAnchor.constraint(equalTo: subscirbesTableView.bottomAnchor, constant: 40.0).isActive = true
        
       topicTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        
       topicTextField.rightAnchor.constraint(equalTo: publicationsTableView.leftAnchor, constant: 5.0).isActive = true
        
       topicTextField.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 10).isActive = true
        
        topicTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        
        messageTextField.topAnchor.constraint(equalTo: topicTextField.bottomAnchor, constant: 30.0).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        
        messageTextField.rightAnchor.constraint(equalTo: publicationsTableView.leftAnchor, constant: 5.0).isActive = true
        
        messageTextField.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 10).isActive = true
        
        messageTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        
        publishBtn.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: 20.0).isActive = true
        
        publishBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        
        publishBtn.rightAnchor.constraint(equalTo: publicationsTableView.leftAnchor, constant: 5.0).isActive = true
        
        publishBtn.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 10).isActive = true
        
        publishBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func mqttDidReceive(message data: Data, in topic: String, from session: MQTTSession) {
        
       let message = String(data: data, encoding: .utf8)
        
        print("message is \(message)")
        
        self.getMessagesMode = true
        
        if publicationsTableView.delegate == nil {
        
        publicationsTableView.delegate = self
        
        publicationsTableView.dataSource = self
            
        }
        
        messages.append(message!)
        
        publicationsTableView.reloadData()
        
    }
    
    func mqttDidDisconnect(session: MQTTSession) {
        
    }
    
    func mqttSocketErrorOccurred(session: MQTTSession) {
        
        print("the error \(session)")
    }
    
    
    func publishMessage() {
        
        let topic = topicTextField.text!
        
        
        let message = messageTextField.text!
        
        if topic != "" && message != "" {
            
            do {
            
             let data = message.data(using: .utf8)
             
             mqtSession.publish(data!, in: topic, delivering: .atMostOnce, retain: true) { (delievered, error) in
             
             if delievered {
             
             print("success")
             }
             }
             
             } catch let error as NSError {
             
             }
            
            
        }
        
    }

}

extension mainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if getMessagesMode {
            
            return messages.count
        }
        
        return topicTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if getMessagesMode {
            
            
            if let cell = publicationsTableView.dequeueReusableCell(withIdentifier: "cell2") {
                
                
                cell.textLabel?.text = messages[indexPath.row]
                
                cell.textLabel?.textColor = UIColor.black
                
                cell.selectionStyle = .none
                
                return cell
            }
            
        } else {
        
        if let cell = subscirbesTableView.dequeueReusableCell(withIdentifier: "cell")  {
            
            cell.textLabel?.textColor = UIColor.white
            
            cell.textLabel?.text = topicTitles[indexPath.row]
            
            cell.editingAccessoryType = .checkmark
                        
            cell.backgroundColor = UIColor.lightGray
            
            cell.selectionStyle = .none
            
            cell.tag = 0
            
            return cell
        }
        
            
        }
        
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = subscirbesTableView.cellForRow(at: indexPath)
        
        let topic = cell?.textLabel?.text
        
        if cell?.tag == 0 {
        
        mqtSession.subscribe(to: topic!, delivering: .atMostOnce) { (subscribed, error) in
            
            if subscribed {
                
                print("subscribed Successfully")
            } else {
                
                print (error.localizedDescription)
            }
        }
            cell?.tag = 1
            
            cell?.backgroundColor = UIColor.gray
            
            
        } else {
            
            mqtSession.unSubscribe(from: topic!, completion: { (unsubscribed, error) in
                
                if unsubscribed {
                    
                    print("unsubscribed")
                }
            })
            
            cell?.tag = 0
            
            cell?.backgroundColor = UIColor.lightGray
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if getMessagesMode {
            
            return "Received Messages"
        }
        
        return "Subscriptions"
    }
    
}

