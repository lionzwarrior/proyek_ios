//
//  EntryViewController.swift
//  proyek_ios
//
//  Created by Billy on 21/12/23.
//

import UIKit
import UserNotifications

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
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {(permissionGranted, error) in
            if !permissionGranted {
                print("Permission Denied")
            }
        }
        
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
        notificationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async {
                let title = self.textField.text
                let message = "It's time to do " + title!
                let date = self.datePicker.date
                
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title!
                    content.body = message
                    
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request){ (error) in
                        if error != nil {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: date) ,preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
                else {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifcations in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else {
                            return
                        }
                        
                        if(UIApplication.shared.canOpenURL(settingsURL)) {
                            UIApplication.shared.open(settingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
}
