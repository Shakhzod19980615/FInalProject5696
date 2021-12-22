//
//  Report.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/4/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift

class ReportDebt: UIViewController {

    @IBOutlet weak var reportTableView: UITableView!
    
    var debtMoney: Double = 0
    var nameCategory: String = ""
    
    var debtArr: Results<DebtData>?
    var incomArr: Results<IncomData>?
    var moneyArr: Results<MoneyData>?
    var settingArr: Results<SettingsData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        title = strArr["hisobot"]
        
        debtMoney = moneyArr![5].categorys
        reportTableView.rowHeight = view.frame.height / 6
        reportTableView.reloadData()
    }
    
    func load() {
        debtArr = realm.objects(DebtData.self)
        incomArr = realm.objects(IncomData.self)
        moneyArr = realm.objects(MoneyData.self)
        settingArr = realm.objects(SettingsData.self)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pay(_ sender: UIButton) {
        
        if debtMoney >= Double(debtArr![sender.tag].moneyDebt)! {
            if debtArr![sender.tag].debt {
                sender.setTitle(strArr["tolangan"], for: .normal)
                do {
                    try realm.write {
                        debtArr![sender.tag].debt = false
                        debtMoney -= Double(debtArr![sender.tag].moneyDebt)!
                        moneyArr![5].categorys = debtMoney
                        
                        for i in 0..<incomArr!.count {
                            if Double(incomArr![i].incomMoney)! >= Double(debtArr![sender.tag].moneyDebt)! {
                                incomArr![i].incomMoney = doubleToString(result: (Double(incomArr![i].incomMoney)! - Double(debtArr![sender.tag].moneyDebt)!))
                                break
                            } else {
                                debtArr![sender.tag].moneyDebt = doubleToString(result: (Double(debtArr![sender.tag].moneyDebt)! - Double(incomArr![i].incomMoney)!))
                                incomArr![i].incomMoney = "0"
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "nav7") as! UINavigationController
                present(vc, animated: true, completion: nil)
            }
        }
    }
}
extension ReportDebt: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debtArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportDebtCell", for: indexPath) as! ReportDebtCell
        cell.imageType.image = UIImage(named: "qarz")
        cell.nameSource.text = debtArr![indexPath.row].sourceDebt
        cell.date.text = debtArr![indexPath.row].dateDebt
        cell.money.text = debtArr![indexPath.row].moneyDebt + "  " + settingArr!.last!.currency
        
        
        if debtArr![indexPath.row].debt {
            
            if debtMoney < Double(debtArr![indexPath.row].moneyDebt)! {
                cell.needMoney.text = "(- \(doubleToString(result: Double(cell.money.text!.split(separator: " ")[0])! - debtMoney) + "  " + settingArr!.last!.currency))"
                cell.needMoney.textColor = UIColor.flatRedColorDark()
            } else
            if debtMoney > Double(debtArr![indexPath.row].moneyDebt)! {
                print(debtMoney)
                print(Double(debtArr![indexPath.row].moneyDebt)!)
                cell.needMoney.text = "(+ \(doubleToString(result: (debtMoney - Double(cell.money.text!.split(separator: " ")[0])!)) + "  " + settingArr!.last!.currency))"
                cell.needMoney.textColor = UIColor.flatGreenColorDark()
            }
            
            cell.payButton.setTitle(strArr["tolash"], for: .normal)
        } else {
            cell.payButton.setTitle(strArr["tolangan"], for: .normal)
        }
        cell.payButton.tag = indexPath.row
        return cell
    }
    
    
}
