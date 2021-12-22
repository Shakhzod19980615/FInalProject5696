//
//  Report.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/4/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import RealmSwift

class Report: UIViewController {

    @IBOutlet weak var reportsTableView: UITableView!
    
    var indexCategory: Int = 0
    var nameCategory: String = ""
    
    var incomArr: Results<IncomData>?
    var moneyArr: Results<MoneyData>?
    var settingArr: Results<SettingsData>?
    
    var maxIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        title = strArr["hisobot"]
        
        maxIndex = moneyArr![indexCategory].dates.count - 1
        reportsTableView.rowHeight = view.frame.height / 6
        reportsTableView.reloadData()
    }
    
    func load() {
        incomArr = realm.objects(IncomData.self)
        moneyArr = realm.objects(MoneyData.self)
        settingArr = realm.objects(SettingsData.self)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
}
extension Report: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyArr![indexCategory].dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportCell
    
        if moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†").count == 3 {
            cell.nameOne.text = nameCategory
            cell.nameTwo.text = String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[0])
            cell.date.text = String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[1])
            
            cell.imageType.image = UIImage(named: "spend_money")
            
            cell.money.text = " - " + String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[2]) + "  " + settingArr!.last!.currency
            cell.money.textColor = UIColor.flatRed()
        } else {
            cell.nameOne.text = String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[0])
            cell.nameTwo.text = String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[1])
            cell.date.text = String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[2])
            
            if cell.nameOne.text == strArr["oylik_maosh"] {
                cell.imageType.image = UIImage(named: "oylik_maosh")
            } else
            if cell.nameOne.text == strArr["biznes_daromad"] {
                cell.imageType.image = UIImage(named: "biznes_daromad")
            } else
            if cell.nameOne.text == strArr["boshqa_daromad"] {
                cell.imageType.image = UIImage(named: "boshqa_daromad")
            } 
            
            cell.money.text = " + " + String(moneyArr![indexCategory].dates[maxIndex - indexPath.row].split(separator: "†")[3]) + "  " + settingArr!.last!.currency
            cell.money.textColor = UIColor.flatGreen()
        }
        
        
        return cell
    }
    
    
}

