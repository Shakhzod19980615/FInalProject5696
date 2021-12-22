//
//  ADDIncome.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 7/25/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift
import UnderKeyboard

@available(iOS 13.0, *)
class ADDincome: UIViewController {
    
    @IBOutlet weak var incomeInfo: UIView!
    
    @IBOutlet weak var constantType: UILabel!
    @IBOutlet weak var constantNote: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeIncome: UILabel!
    
    @IBOutlet weak var typeOne: UILabel!
    @IBOutlet weak var typeTwo: UILabel!
    @IBOutlet weak var typeThree: UILabel!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var typeIncomeStackView: UIStackView!
    
    @IBOutlet weak var addKeyboardConstraints: NSLayoutConstraint!
    
    var incomArr: Results<IncomData>?
    var settingArr: Results<SettingsData>?
    
    let keyboardObserver = UnderKeyboardObserver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        font()
        
        noteField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        view.addGestureRecognizer(tap)
        
        load()
        
    }
    
    func font() {
        titleLabel.text = strArr["qanday_turdagi_daromodni_qoshmoqchisiz"]
        titleLabel.changeFont(size: 3)
        
        typeOne.text = strArr["oylik_maosh"] ; typeOne.changeFont(size: 4)
        typeTwo.text = strArr["biznes_daromad"] ; typeTwo.changeFont(size: 4)
        typeThree.text = strArr["boshqa_daromad"] ; typeThree.changeFont(size: 4)
        
        constantNote.text = strArr["qayerdan"] ; constantNote.changeFont(size: 1.5)
        constantType.text = strArr["daromad_turi : "] ; constantType.changeFont(size: 1.5)
        
        nextButton.setTitle(strArr["davom_etish"], for: .normal) ; nextButton.titleLabel?.changeFont(size: 1.5)
        cancelButton.setTitle(strArr["bekor_qilish"], for: .normal) ; cancelButton.titleLabel?.changeFont(size: 1.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        keyboardObserver.start()
        
        keyboardObserver.willAnimateKeyboard = { height in
            self.addKeyboardConstraints.constant = -200
            self.typeIncomeStackView.alpha = 0
        }
        keyboardObserver.animateKeyboard = { height in
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped() {
        noteField.endEditing(true)
    }
    
    @IBAction func addIncome(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1) {
            self.incomeInfo.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
                self.incomeInfo.alpha = 1
            }, completion:  nil)
            
            if sender.tag == 1 {
                self.typeIncome.text = strArr["oylik_maosh"]
            } else
            if sender.tag == 2 {
                self.typeIncome.text = strArr["biznes_daromad"]
            } else {
                self.typeIncome.text = strArr["boshqa_daromad"]
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.noteField.becomeFirstResponder()
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        if !noteField.text!.isEmpty {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
            
            let newIncom = IncomData()
            newIncom.typeIncom = typeIncome.text!
            newIncom.noteIncom = noteField.text!
            newIncom.incomMoney = "0"
            save(incoms: newIncom)
    
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func save(incoms: IncomData) {
        do {
            try realm.write {
                realm.add(incoms)
            }
        } catch {
            print(error)
        }
    }
    
    func load() {
        incomArr = realm.objects(IncomData.self)
        settingArr = realm.objects(SettingsData.self)
    }
}

func doubleToString(result : Double) -> String {
    if ceil(result) == result {
        return String(Int(result))
    } else {
        return String(result)
    }
}

extension UILabel {
    func changeFont(size: Double) {
        self.font = UIFont(name: "Chalkboard SE", size: self.frame.height / CGFloat(size))
    }
}

@available(iOS 13.0, *)
extension ADDincome: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.addKeyboardConstraints.constant = 30
            self.typeIncomeStackView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}
