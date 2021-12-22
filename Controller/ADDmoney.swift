//
//  ADDmoney.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 7/27/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift
import UnderKeyboard
import MDatePickerView

@available(iOS 13.0, *)
class ADDmoney: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var moneyTextField = UITextField()

    var debtArr: Results<DebtData>?
    var moneyArr: Results<MoneyData>?
    var incomeArr: Results<IncomData>?
    var settingArr: Results<SettingsData>?
    
    var devidedMoney = [0.1, 0.1, 0.1, 0.35, 0.35, 0]
    var devidedWithDebtMoney = [0.1, 0.1, 0.1, 0.2, 0.2, 0.3]
    
    let keyboardObserver = UnderKeyboardObserver()
    
    var indexTag: Int = 0
    
    var strDate: String = ""
    var nowString: String = ""
    var changeDate: String = ""
    
    var checkPuw: Bool = true
    var checkDebt: Bool = false
    
    lazy var MDate : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.delegate = self
        mdate.Color = UIColor.flatBlue()
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
        saveDateButton.backgroundColor = UIColor.flatBlue()
        saveDateButton.setTitleColor(.white, for: .normal)
        saveDateButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 25)
        saveDateButton.addTarget(self, action: #selector(saveDateText), for: .touchUpInside)
        saveDateButton.translatesAutoresizingMaskIntoConstraints = false
        return saveDateButton
    }()
    
    @objc func saveDateText() {
        
        save(tag: indexTag)
        
        changeDate += strDate
        
        if changeDate.split(separator: "†").count == 2 {
            changeDate += today()
        }
        
        do {
            try realm.write {
                for i in 0...4 {
                    moneyArr![i].moneyDate = changeDate + "†" + doubleToString(result: moneyArr![i].adds.last!)
                    moneyArr![i].dates.append(moneyArr![i].moneyDate)
                }
            }
        } catch {
            print(error)
        }
        
        MDate.removeFromSuperview()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        (vc.viewControllers.first as! Home).add = true
        self.present(vc, animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = strArr["mablag_qoshish"]
        
        load()
        
        for i in 0..<debtArr!.count {
            if debtArr![i].debt {
                checkDebt = true ; break
            }
        }
        
        addIncomeViews()
    }
    
    func load() {
        debtArr = realm.objects(DebtData.self)
        moneyArr = realm.objects(MoneyData.self)
        incomeArr = realm.objects(IncomData.self)
        settingArr = realm.objects(SettingsData.self)
    }
    
    func addIncomeViews() {
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: UIApplication.shared.statusBarFrame.size.height + navigationController!.navigationBar.frame.height + 20, width: view.frame.width - 40, height: view.frame.height))
        scrollView.contentSize.height = CGFloat(incomeArr!.count) * (view.frame.height * 0.25 + 40)
        view.addSubview(scrollView)
        
        for i in 0..<incomeArr!.count {
            let newIncomeView = UIView(frame: CGRect(x: 0, y: CGFloat(i) * (view.frame.height * 0.25 + 20), width: scrollView.frame.width, height: view.frame.height * 0.25))
            newIncomeView.layer.cornerRadius = 10 ; newIncomeView.tag = i
            newIncomeView.backgroundColor = UIColor(hexString: "#424459")
            newIncomeView.layer.borderWidth = 2 ; newIncomeView.layer.borderColor = UIColor.white.cgColor
            scrollView.addSubview(newIncomeView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(addMoney))
            newIncomeView.addGestureRecognizer(tap)
            
            let lbltype = UILabel(frame: CGRect(x: 20, y: 20, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lbltype.textColor = .white
            lbltype.text = incomeArr![i].typeIncom ; lbltype.font = UIFont(name: "Chalkboard SE", size: 30)
            newIncomeView.addSubview(lbltype)
            
            let lblnote = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.2 + 40, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lblnote.textColor = .white
            lblnote.text = incomeArr![i].noteIncom ; lblnote.font = UIFont(name: "Chalkboard SE", size: 25)
            newIncomeView.addSubview(lblnote)
            
            let lblmoney = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.4 + 60, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lblmoney.textColor = .white
            
            lblmoney.text = incomeArr![i].incomMoney + "  " + settingArr!.last!.currency
            
            lblmoney.font = UIFont(name: "Chalkboard SE", size: 20)
            newIncomeView.addSubview(lblmoney)
        }
    }
    
    @objc func addMoney(_ sender: UISwipeGestureRecognizer) {
        if checkPuw {
            indexTag = sender.view!.tag
            
            view.subviews[0].removeAllSubViews()

            let income = sender.view!.subviews[0] as! UILabel
            let note = sender.view!.subviews[1] as! UILabel
            
            changeDate = income.text! + "†" + note.text! + "†"
            
            UIView.animate(withDuration: 1) {
                sender.view?.frame = CGRect(x: 0, y: 0.15 * self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height * 0.25)
            }
            view.subviews[0].addSubview(sender.view!)
            
            moneyTextField.isHidden = false
            
            let tapview = sender.view!
            let moneyLabel = tapview.subviews.last! as! UILabel
            moneyLabel.text! += " + "
            
            moneyTextField.becomeFirstResponder()
            moneyTextField.keyboardType = .decimalPad
            
            moneyTextField.textColor = .white
            moneyTextField.tintColor = .white
            moneyTextField.font = UIFont(name: "Chalkboard SE", size: 20)
            
            let maxX = moneyLabel.text?.widthOfString(usingFont: UIFont(name: "Chalkboard SE", size: 20)!)
            
            moneyTextField.frame = CGRect(x: 20 + maxX!, y: moneyLabel.frame.origin.y, width: moneyLabel.frame.width - maxX!, height: moneyLabel.frame.height)

            moneyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            moneyTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(done)), onCancel: (target: self, action: #selector(cancel)))
        
            tapview.addSubview(moneyTextField)
            
            checkPuw = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.last == "+" {
            textField.text! += " "
        }
        
        
        if textField.text!.count >= 15 {
            textField.text = ""
        } else {
            nowString = textField.text!
        }
    
    }
    
    @objc func done() {
        if nowString != "" && nowString != "0" {
            
            view.removeAllSubViews()
            view.addSubview(MDate)
            
            backButton.isEnabled = false
            
            NSLayoutConstraint.activate([
                MDate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                MDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                MDate.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                MDate.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            ])
            
            view.addSubview(saveDate)
            saveDate.widthAnchor.constraint(equalTo: MDate.widthAnchor, constant: 0).isActive = true
            saveDate.heightAnchor.constraint(equalTo: MDate.heightAnchor, multiplier: 0.2).isActive = true
            saveDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            saveDate.topAnchor.constraint(equalTo: MDate.bottomAnchor, constant: 20).isActive = true
        }
    }
    
    @objc func cancel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav3") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    func save(tag : Int) {
        
        do {
            try realm.write {
                
                let lastIncome = Double(self.incomeArr![tag].incomMoney.split(separator: " ").first!)!
                let nowIncome = Double(nowString)
                self.incomeArr![tag].incomMoney = doubleToString(result: lastIncome + nowIncome!)
                
                for i in 0...5 {
                    if checkDebt {
                        moneyArr![i].addMoney = Double(nowString)! * devidedWithDebtMoney[i]
                    } else {
                        moneyArr![i].addMoney = Double(nowString)! * devidedMoney[i]
                    }
                    moneyArr![i].adds.append(moneyArr![i].addMoney)
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action:
        Selector)? = nil) {
        
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
    
        self.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

@available(iOS 13.0, *)
extension ADDmoney : MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: selectDate)
        strDate = date
    }
}
