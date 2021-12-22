//
//  SPENDmoney.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 7/28/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift
import MDatePickerView

@available(iOS 13.0, *)
class SPENDmoney: UIViewController {

    @IBOutlet weak var dateConstant: UILabel!
    @IBOutlet weak var categoryConstant: UILabel!
    @IBOutlet weak var noteConstant: UILabel!
    @IBOutlet weak var moneyConstant: UILabel!
    
    @IBOutlet weak var swipeViews: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var moneyButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var moneyField: UITextField!
    
    @IBOutlet weak var saveConstant: UIButton!
    
    var incomArr: Results<IncomData>?
    var moneyArr: Results<MoneyData>?
    var settingArr: Results<SettingsData>?
    
    var devidedMoney = ["10 %", "10 %", "10 %", "35 %", "35 %"]
    var categoryArr = [strArr["ozim"], strArr["ota_onam"], strArr["fond"], strArr["oilam"], strArr["investitsiya"]]
    
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
    
    var maxMoney: Double = 0
    var indexTag: Int = 0
    var direction: Int = 0
    var checkPush: Bool = false
    var editString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = strArr["xarajat"]
        dateConstant.text = strArr["sana"] ; dateConstant.changeFont(size: 5)
        categoryConstant.text = strArr["kategoriya"] ; categoryConstant.changeFont(size: 5)
        noteConstant.text = strArr["izoh"] ; noteConstant.changeFont(size: 5)
        moneyConstant.text = strArr["mablag"] ; moneyConstant.changeFont(size: 5)
        saveConstant.setTitle(strArr["saqlash"], for: .normal) ; saveConstant.titleLabel?.changeFont(size: 1.5)
            
        dateButton.setTitle(today(), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        view.addGestureRecognizer(tap)
        
        load()
    }
    
    @objc func cancel() {
        if moneyButton.isHidden == true {
            moneyField.resignFirstResponder()
            
            moneyField.isHidden = true
            moneyButton.isHidden = false
            
            editString = ""
            
            checkPush = true
        }
        if noteButton.isHidden == true {
            noteField.resignFirstResponder()
            
            noteField.isHidden = true
            noteButton.isHidden = false
            
            editString = ""
            
        }
    }
    
    func load() {
        incomArr = realm.objects(IncomData.self)
        moneyArr = realm.objects(MoneyData.self)
        settingArr = realm.objects(SettingsData.self)
    }
    
    @IBAction func calendar(_ sender: UIButton) {
        if noteButton.isHidden == false && moneyButton.isHidden == false {
            swipeViews.removeAllSubViews()
            
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
    
    @IBAction func category(_ sender: UIButton) {
        direction = 0
        checkPush = false
        MDate.removeFromSuperview()
        swipeViews.removeAllSubViews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
                self.swipeViews.alpha = 1
            }, completion:  nil)
        }
        devidedCategory()
    }
    
    func devidedCategory() {
        for i in 0..<5 {
            if moneyArr![i].categorys != 0 {
                let newIncomeView = UIView(frame: CGRect(x: 10 + CGFloat(4 * i + 4), y: 10 + CGFloat(10 * i + 10), width: swipeViews.frame.width - 20 - CGFloat(8 * i + 8), height: swipeViews.frame.height * 0.8))
                newIncomeView.layer.cornerRadius = 10 ; newIncomeView.tag = i
                newIncomeView.backgroundColor = UIColor(hexString: "#424459")
                newIncomeView.layer.borderWidth = 2 ; newIncomeView.layer.borderColor = UIColor.white.cgColor
                swipeViews.addSubview(newIncomeView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(addCategory(_:)))
                let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                
                leftSwipe.direction = .left
                rightSwipe.direction = .right
                
                newIncomeView.addGestureRecognizer(tap)
                newIncomeView.addGestureRecognizer(leftSwipe)
                newIncomeView.addGestureRecognizer(rightSwipe)
        
                
                let lbltype = UILabel(frame: CGRect(x: 20, y: 20, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
                lbltype.textColor = .white
                lbltype.text = categoryArr[i] ; lbltype.font = UIFont(name: "Chalkboard SE", size: 30)
                newIncomeView.addSubview(lbltype)
                
                let lblnote = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.2 + 40, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
                lblnote.textColor = .white
                lblnote.text = devidedMoney[i] ; lblnote.font = UIFont(name: "Chalkboard SE", size: 25)
                newIncomeView.addSubview(lblnote)
                
                let lblmoney = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.4 + 60, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
                lblmoney.textColor = .white
                
                lblmoney.text = doubleToString(result: moneyArr![i].categorys) + "  " + settingArr!.last!.currency
                
                lblmoney.font = UIFont(name: "Chalkboard SE", size: 20)
                newIncomeView.addSubview(lblmoney)
            }
        }
    }
    
    @objc func addCategory(_ sender: UITapGestureRecognizer) {
        let nameCategory = sender.view!.subviews.first as! UILabel
        let moneyCategory = sender.view!.subviews.last as! UILabel
        maxMoney = Double(moneyCategory.text!.split(separator: " ")[0])!
        indexTag = sender.view!.tag
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.swipeViews.alpha = 0
                self.categoryButton.setTitle(nameCategory.text!, for: .normal)
           }, completion:  nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.swipeViews.removeAllSubViews()
        }
        checkPush = true
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        let tapview = sender.view!
        
        if direction == 0 {
            if sender.direction == .right {
                UIView.animate(withDuration: 1) {
                    tapview.frame.origin.x = tapview.frame.origin.x + tapview.frame.width - 10
                }
                direction += 1
            } else
            if sender.direction == .left {
               UIView.animate(withDuration: 1) {
                   tapview.frame.origin.x = tapview.frame.origin.x - tapview.frame.width + 10
               }
               direction -= 1
            }
        } else
        if tapview.frame.origin.x < tapview.frame.width && direction > 0 {
            if sender.direction == .right {
                UIView.animate(withDuration: 1) {
                    tapview.frame.origin.x = tapview.frame.origin.x + tapview.frame.width - 10
                }
                direction += 1
            }
        } else
        if tapview.frame.origin.x > tapview.frame.width && direction > 0 {
            if sender.direction == .left {
                UIView.animate(withDuration: 1) {
                    tapview.frame.origin.x = tapview.frame.origin.x - tapview.frame.width + 10
                }
                direction -= 1
            }
        } else
        if tapview.frame.origin.x > 0 && direction < 0 {
            if sender.direction == .left {
                UIView.animate(withDuration: 1) {
                    tapview.frame.origin.x = tapview.frame.origin.x - tapview.frame.width + 10
                }
                direction -= 1
            }
        } else
        if tapview.frame.origin.x < 0 && direction < 0 {
            if sender.direction == .right {
                UIView.animate(withDuration: 1) {
                    tapview.frame.origin.x = tapview.frame.origin.x + tapview.frame.width - 10
                }
                direction += 1
            }
        }
    }
    
    @IBAction func note(_ sender: UIButton) {
        if checkPush {
            swipeViews.removeAllSubViews()
            
            noteField.text = ""
            
            noteField.isHidden = false
            noteButton.isHidden = true
            
            noteField.becomeFirstResponder()
            
            noteField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            noteField.addTarget(self, action: #selector(myTextFielAction), for: UIControl.Event.primaryActionTriggered)
            
            checkPush = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        editString = textField.text!
    }
    
    @objc func myTextFielAction(textField: UITextField) {
        
        checkPush = true
        
        textField.resignFirstResponder()
        
        textField.isHidden = true
        
        noteButton.isHidden = false
        noteButton.setTitle(editString, for: .normal)
    }
    
    @IBAction func money(_ sender: UIButton) {
        if checkPush {
            swipeViews.removeAllSubViews()
            
            editString = ""
            moneyField.text = ""
            
            moneyField.isHidden = false
            moneyButton.isHidden = true
            
            moneyField.becomeFirstResponder()
            moneyField.attributedPlaceholder = NSAttributedString(string: " <= \(doubleToString(result: maxMoney))",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            moneyField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            checkPush = false
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if editString != "" && moneyButton.isHidden == true {
            if Double(editString)! <= maxMoney {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
                let vC = vc.viewControllers.last as! Home
                vC.spend = true
                vC.indexTag = indexTag
                self.present(vc, animated: true, completion: nil)
                
                do {
                    try realm.write {
                        moneyArr![indexTag].spendMoney = Double(editString)!
                        moneyArr![indexTag].spends.append(moneyArr![indexTag].spendMoney)
                        
                        for i in 0..<incomArr!.count {
                            if Double(incomArr![i].incomMoney)! >= Double(editString)! {
                                incomArr![i].incomMoney = doubleToString(result: (Double(incomArr![i].incomMoney)! - Double(editString)!))
                                break
                            } else {
                                editString = doubleToString(result: (Double(editString)! - Double(incomArr![i].incomMoney)!))
                                incomArr![i].incomMoney = "0"
                            }
                        }
                        
                        moneyArr![indexTag].moneyDate = noteButton.currentTitle! + "†" + dateButton.currentTitle! + "†" + editString
                        moneyArr![indexTag].dates.append(moneyArr![indexTag].moneyDate)
                    }
                } catch {
                    print(error)
                }
                
            } else {
                moneyField.text = ""
                moneyField.textAlignment = .center
                moneyField.attributedPlaceholder = NSAttributedString(string: " <= \(doubleToString(result: maxMoney))",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
}
extension UIView {
    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
}

@available(iOS 13.0, *)
extension SPENDmoney : MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: selectDate)
        dateButton.setTitle(date, for: .normal)
    }
}
