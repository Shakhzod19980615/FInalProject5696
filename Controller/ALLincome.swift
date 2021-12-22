//
//  ALLincome.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 7/26/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift

@available(iOS 13.0, *)
class ALLincome: UIViewController {
    
    var incomeview: UIView!
    var incomArr: Results<IncomData>?
    var settingArr: Results<SettingsData>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        title = strArr["daromad_manbalari"]
        
        addIncomeView()
        addIncomeViews()
        
    }
    @IBAction func removeAllData(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: strArr["barcha_malumotlarni_ochirish"], message: strArr["ishonchingiz_komilmi"], preferredStyle: .alert)
        let yes = UIAlertAction(title: strArr["ha"], style: .destructive) { (action) in
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                print(error)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "nav0") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(yes)
        let no = UIAlertAction(title: strArr["yoq"], style: .default, handler: nil)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    
    func addIncomeView() {
        let incomeView = UIView(frame: CGRect(x: 20, y: UIApplication.shared.statusBarFrame.size.height + navigationController!.navigationBar.frame.height + 20, width: view.frame.width - 40, height: view.frame.height * 0.15))
        incomeView.layer.cornerRadius = 10
        incomeView.backgroundColor = UIColor(hexString: "#424459")
        view.addSubview(incomeView)
        
        let btn_lbl = UIButton(frame: CGRect(x: 0, y: 0, width: incomeView.frame.width, height: incomeView.frame.height))
        btn_lbl.layer.cornerRadius = 10 ; btn_lbl.setTitleColor(UIColor.white, for: .normal)
        btn_lbl.contentHorizontalAlignment = .center
        btn_lbl.setTitle(strArr["daromad_manbai"], for: .normal)
        btn_lbl.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 17)
        incomeView.addSubview(btn_lbl)
        
        let btn = UIButton(frame: CGRect(x: incomeView.frame.width * 0.8 - 5, y: 5, width: incomeView.frame.width * 0.2, height: incomeView.frame.width * 0.2))
        btn.addTarget(self, action: #selector(goADDincome), for: .touchUpInside)
        btn.setImage(UIImage(named: "daromad_qoshish"), for: .normal)
        incomeView.addSubview(btn)
        
        incomeview = incomeView
    }
    
    @objc func goADDincome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "typeincome") as! ADDincome
        self.present(vc, animated: true, completion: nil)
    }
    
    func addIncomeViews() {
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: incomeview.frame.maxY + 20, width:  incomeview.frame.width, height: view.frame.height - incomeview.frame.maxY - 20))
        scrollView.contentSize.height = CGFloat(incomArr!.count) * (view.frame.height * 0.25 + 20)
        view.addSubview(scrollView)
        
        for i in 0..<incomArr!.count {
            let newIncomeView = UIView(frame: CGRect(x: 0, y: CGFloat(i) * (view.frame.height * 0.25 + 20), width: incomeview.frame.width, height: view.frame.height * 0.25))
            newIncomeView.layer.cornerRadius = 10 ; newIncomeView.tag = i
            newIncomeView.backgroundColor = UIColor(hexString: "#424459")
            newIncomeView.layer.borderWidth = 2 ; newIncomeView.layer.borderColor = UIColor.white.cgColor
            scrollView.addSubview(newIncomeView)
            
            let lbltype = UILabel(frame: CGRect(x: 20, y: 20, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lbltype.textColor = .white
            lbltype.text = incomArr![i].typeIncom ; lbltype.font = UIFont(name: "Chalkboard SE", size: 30)
            newIncomeView.addSubview(lbltype)
            
            let lblnote = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.2 + 40, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lblnote.textColor = .white
            lblnote.text = incomArr![i].noteIncom ; lblnote.font = UIFont(name: "Chalkboard SE", size: 25)
            newIncomeView.addSubview(lblnote)
            
            let lblmoney = UILabel(frame: CGRect(x: 20, y: newIncomeView.frame.height * 0.4 + 60, width: newIncomeView.frame.width - 40, height: newIncomeView.frame.height * 0.2))
            lblmoney.textColor = .white
            
            lblmoney.text = incomArr![i].incomMoney + "  " + settingArr!.last!.currency
            
            lblmoney.font = UIFont(name: "Chalkboard SE", size: 20)
            newIncomeView.addSubview(lblmoney)
        }
    }
    
    func load() {
        incomArr = realm.objects(IncomData.self)
        settingArr = realm.objects(SettingsData.self)
    }
    
    @IBAction func back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
}
