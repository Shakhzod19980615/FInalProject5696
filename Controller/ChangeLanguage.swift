//
//  ChangeLanguage.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/8/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift

@available(iOS 13.0, *)
class ChangeLanguage: UIViewController {

    @IBOutlet weak var widthStackView: NSLayoutConstraint!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    
    var settingArr: Results<SettingsData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
    }
    
    func load() {
        settingArr = realm.objects(SettingsData.self)
    }
    
    @IBAction func selectLanguage(_ sender: UIButton) {
        if title == "Valyutani tanlang" {
            saveCurrency(currency: sender.currentTitle!)
            goHome()
        } else {
    
            UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseIn, animations: {
                self.widthStackView.setMultiplier(0.0001, of: &self.widthStackView)
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseOut, animations: {
                    self.widthStackView.setMultiplier(0.7, of: &self.widthStackView)
                    self.view.layoutIfNeeded()
                })
            })
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let setting = SettingsData()
                setting.language = sender.currentTitle!
                self.saveLang(lang: setting)
                
                self.title = "Valyutani tanlang"
                
                self.firstBtn.setTitle("UZS", for: .normal)
                self.secondBtn.setTitle("USD", for: .normal)
                self.thirdBtn.setTitle("RUB", for: .normal)
            }
        }
    }
    
    func goHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
    func saveLang(lang: SettingsData) {
        do {
            try realm.write {
                realm.add(lang)
            }
        } catch {
            print(error)
        }
    }
    
    func saveCurrency(currency: String) {
        do {
            try realm.write {
                settingArr?.last?.currency = currency
            }
        } catch {
            print(error)
        }
    }
}
extension NSLayoutConstraint {
    func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])

        let newConstraint = NSLayoutConstraint(item: constraint.firstItem!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)

        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier

        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }

}
