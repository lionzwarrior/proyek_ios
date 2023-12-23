//
//  ViewController2.swift
//  proyek_ios
//
//  Created by Billy on 21/12/23.
//

import UIKit

class ViewController3: UIViewController {
    let ud = UserDefaults.standard
    var items: [String] = []
    var dates: [Date] = []
    var index = 0
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completionHandler: (() -> Void)?
    
    static let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ud.value(forKey: "items") != nil {
            items = ud.value(forKey: "items") as! [String]
            dates = ud.value(forKey: "dates") as! [Date]
        }
        
        textField.text = items[index]
        datePicker.date = dates[index]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        
        datePicker.setDate(Date(), animated: true)

        // Do any additional setup after loading the view.
    }
    @objc private func didTapDone(){
        if let text = textField.text, !text.isEmpty{
            let date = datePicker.date
            items[index] = text
            dates[index] = date
            ud.setValuesForKeys(["items": items, "dates": dates])
            ud.synchronize()
            completionHandler?()
            navigationController?.popViewController(animated: true)
        }
        else{
            print("Add Something")
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
