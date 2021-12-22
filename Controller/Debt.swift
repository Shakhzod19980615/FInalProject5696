//
//  Debt.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/4/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift
import MDatePickerView

@available(iOS 13.0, *)
class Debt: UIViewController {
    
    @IBOutlet weak var dateConstant: UILabel!
    @IBOutlet weak var sourceConstant: UILabel!
    @IBOutlet weak var moneyConstant: UILabel!
    @IBOutlet weak var saveConstant: UIButton!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var moneyButton: UIButton!
    
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var sourceField: UITextField!
    
    var debtArr: Results<DebtData>?
    var moneyArr: Results<MoneyData>?
    var incomeArr: Results<IncomData>?
    
    var checkPuw: Bool = false
    var editString: String = ""
        
    lazy var MDate : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.delegate = self
        mdate.Color = UIColor(red: 0/255, green: 178/255, blue: 113/255, alpha: 1)
        mdate.cornerRadius = 14
        mdate.translatesAutoresizingMaskIntoConstraints = false
        mdate.from = 1920
        mdate.to = 2100
        return mdate
    }()
    
    let saveDate : UIButton = {
        let saveDateButton = UIButton(type:.system)
        saveDateButton.setTitle("Save", for: .normal)
        saveDateButton.layer.cornerRadius = 14
        saveDateButton.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 113/255, alpha: 1)
        saveDateButton.setTitleColor(.white, for: .normal)
        saveDateButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 25)
        saveDateButton.addTarget(self, action: #selector(saveDateText), for: .touchUpInside)
        saveDateButton.translatesAutoresizingMaskIntoConstraints = false
        return saveDateButton
    }()
    
    @objc func saveDateText() {
        MDate.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        title = strArr["qarz"]
        dateConstant.text = strArr["sana"] ; dateConstant.changeFont(size: 5)
        sourceConstant.text = strArr["manba"] ; sourceConstant.changeFont(size: 5)
        moneyConstant.text = strArr["mablag"] ; moneyConstant.changeFont(size: 5)
        saveConstant.setTitle(strArr["saqlash"], for: .normal) ; saveConstant.titleLabel?.changeFont(size: 2)
        
        dateButton.setTitle(today(), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        view.addGestureRecognizer(tap)
    }
    
    func load() {
        moneyArr = realm.objects(MoneyData.self)
        debtArr = realm.objects(DebtData.self)
        incomeArr = realm.objects(IncomData.self)
    }
    
    @objc func cancel() {
        if moneyButton.isHidden == true {
            moneyField.resignFirstResponder()
            
            moneyField.isHidden = true
            moneyButton.isHidden = false
            moneyButton.setTitle("", for: .normal)
            
            editString = ""
        }
        
        if sourceButton.isHidden == true {
            sourceField.resignFirstResponder()
            
            sourceField.isHidden = true
            sourceButton.isHidden = false
            sourceButton.setTitle("", for: .normal)
            
            editString = ""
            
            checkPuw = false
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func calendar(_ sender: UIButton) {
        if sourceButton.isHidden == false && moneyButton.isHidden == false {
        
            view.addSubview(MDate)
            NSLayoutConstraint.activate([
                MDate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                MDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                MDate.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
                MDate.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            ])
            
            view.addSubview(saveDate)
            saveDate.widthAnchor.constraint(equalTo: MDate.widthAnchor, constant: 0).isActive = true
            saveDate.heightAnchor.constraint(equalTo: MDate.heightAnchor, multiplier: 0.2).isActive = true
            saveDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            saveDate.topAnchor.constraint(equalTo: MDate.bottomAnchor, constant: 20).isActive = true
        }
    }
    func today() -> String {
        
        let date = Calendar(identifier: .gregorian)

        let formatter = DateFormatter()
        formatter.calendar = date
        formatter.dateFormat = "dd.MM.yyyy"

        let today = Date()
        let dateString = formatter.string(from: today)
        
        return dateString
    }
    
    @IBAction func source(_ sender: UIButton) {
        sourceField.text = ""
        
        sourceField.isHidden = false
        sourceButton.isHidden = true
        
        sourceField.becomeFirstResponder()
        
        sourceField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        sourceField.addTarget(self, action: #selector(myTextFielAction), for: UIControl.Event.primaryActionTriggered)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count >= 15 {
            textField.text = ""
        } else {
            editString = textField.text!
        }
    }
    
    @objc func myTextFielAction(textField: UITextField) {
        
        textField.resignFirstResponder()
        
        textField.isHidden = true
        
        sourceButton.isHidden = false
        sourceButton.setTitle(editString, for: .normal)
        
        checkPuw = true
    }
    
    @IBAction func money(_ sender: UIButton) {
        if checkPuw {
            editString = ""
            moneyField.text = ""
            
            moneyField.isHidden = false
            moneyButton.isHidden = true
            
            moneyField.becomeFirstResponder()
            
            moneyField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if editString != "" && moneyButton.isHidden == true {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            
            do {
                try realm.write {
                    let newDebt = DebtData()
                    newDebt.debt = true
                    newDebt.moneyDebt = editString
                    newDebt.dateDebt = dateButton.currentTitle!
                    newDebt.sourceDebt = sourceButton.currentTitle!
                    realm.add(newDebt)
                }
            } catch {
                print(error)
            }
        }
    }
}

@available(iOS 13.0, *)
extension Debt : MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: selectDate)
        dateButton.setTitle(date, for: .normal)
    }
}
