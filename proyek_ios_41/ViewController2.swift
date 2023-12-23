//
//  ViewController2.swift
//  proyek_ios
//
//  Created by Billy on 21/12/23.
//

import UIKit

protocol refresh {
    func refresh()
}

class ViewController2: UIViewController {
    let ud = UserDefaults.standard
    var items: [String] = []
    var dates: [Date] = []
    var index = 0
    public var deletionHandler: (() -> Void)?
    var delegate: refresh?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
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
        
        itemLabel.text = items[index]
        dateLabel.text = Self.dateFormatter.string(from: dates[index])
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete)), UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))]
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

        // Do any additional setup after loading the view.
    }
    @objc private func didTapDelete(){
        items.remove(at: index)
        dates.remove(at: index)
        ud.setValuesForKeys(["items": items, "dates": dates])
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapEdit(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "View3") as? ViewController3 else{
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.index = index
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = items[index]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh(){
        delegate?.refresh()
        itemLabel.text = items[index]
        dateLabel.text = Self.dateFormatter.string(from: dates[index])
        title = items[index]
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
