//
//  EntryViewController.swift
//  proyek_ios
//
//  Created by Billy on 21/12/23.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completionHandler: (() -> Void)?
    
    let ud = UserDefaults.standard
    var items: [String] = []
    var dates: [Date] = []
    
    // Untuk notification
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        if ud.value(forKey: "items") != nil {
            items = ud.value(forKey: "items") as! [String]
            dates = ud.value(forKey: "dates") as! [Date]
        }
        
        datePicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    @objc func didTapSaveButton(){
        if let text = textField.text, !text.isEmpty{
            let date = datePicker.date
            items.append(text)
            dates.append(date)
            ud.setValuesForKeys(["items": items, "dates": dates])
            ud.synchronize()
            
            // Untuk authorize notification
            notificationCenter.requestAuthorization(options: [.sound,.badge,.alert]) { sucess, error in
                if error == nil {
                    print("Authorize Succesfully")
                } else {
                    print("Authorize Failed")
                }
            }
            // Add Notification
            localNotification()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
        else{
            print("Add Something")
        }
    }
    
    func localNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "This is My First Notification"
        content.sound = UNNotificationSound.default
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if error == nil {
                print("Message sent sucessfully")
            }
        }
    }
}
