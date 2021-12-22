//
//  ViewController.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 7/24/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ChameleonFramework

var strArr = [String: String]()

@available(iOS 13.0, *)
class Home: UIViewController, ChartViewDelegate {
    
    var incomeview: UIView!
    var pieChart = PieChartView()
    
    var add: Bool = false
    var debt: Bool = false
    var spend: Bool = false
    
    var indexTag: Int = 0
    var direction: Int = 0
    var allMoney: Double = 0
    var debtMoney: Double = 0
    
    var debtArr: Results<DebtData>?
    var moneyArr: Results<MoneyData>?
    var incomeArr: Results<IncomData>?
    var settingArr: Results<SettingsData>?
    
    var categoryOne = PieChartDataEntry(value: 0)
    var categoryTwo = PieChartDataEntry(value: 0)
    var categoryThree = PieChartDataEntry(value: 0)
    var categoryFour = PieChartDataEntry(value: 0)
    var categoryFive = PieChartDataEntry(value: 0)
    var categorySix = PieChartDataEntry(value: 0)
    
    var numberOfdataEntries = [PieChartDataEntry]()
    
    var devidedMoney = [0.1, 0.1, 0.1, 0.35, 0.35, 0]
        
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        if settingArr?.last?.language == "O'zbek" {
            strArr = ALLstrings().uz()
        } else
        if settingArr?.last?.language == "English" {
            strArr = ALLstrings().eng()
        } else {
            strArr = ALLstrings().ru()
        }
        
        if moneyArr?.count == 0 {
            for _ in 0...5 {
                let newMoney = MoneyData()
                newMoney.categorys = 0
                newMoney.addMoney = 0 ; newMoney.spendMoney = 0
                newMoney.moneyDate = ""
                save(money: newMoney)
            }
        }
        
        addIncomeView()
        addIncomeViews()
        
        pieChart.delegate = self
        pieChart.frame = CGRect(x: view.frame.width * 0.1, y: incomeview.frame.maxY + 10, width: view.frame.width * 0.8, height: view.frame.width * 0.8)
        view.addSubview(pieChart)
        chartsCircle()
        
        title = today()
    }
    
    func addIncomeView() {
        let incomeView = UIView(frame: CGRect(x: CGFloat(4 * incomeArr!.count + 20), y: UIApplication.shared.statusBarFrame.size.height + navigationController!.navigationBar.frame.height + 20 + CGFloat(10 * incomeArr!.count), width: view.frame.width - 2 * CGFloat(4 * incomeArr!.count + 20), height: view.frame.height * 0.25))
        incomeView.layer.cornerRadius = 10
        incomeView.backgroundColor = UIColor(hexString: "#424459")
        incomeView.layer.borderWidth = 2 ; incomeView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(incomeView)
        
        let lbl = UILabel(frame: CGRect(x: 10, y: 10, width: incomeView.frame.width - 20, height: incomeView.frame.height * 0.3))
        lbl.layer.cornerRadius = 10 ; lbl.textColor = .white ; lbl.textAlignment = .center
        lbl.text = strArr["daromad_manbai"] ; lbl.font = UIFont(name: "Chalkboard SE", size: 20)
        incomeView.addSubview(lbl)
        
        let btn = UIButton(frame: CGRect(x: incomeView.frame.width * 0.37, y: incomeView.frame.height * 0.4, width: incomeView.frame.width * 0.26, height: incomeView.frame.width * 0.26))
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
        for i in 0..<incomeArr!.count {
            
            let newIncomeView = UIView(frame: CGRect(x: incomeview.frame.origin.x - CGFloat(4 * i + 4), y: incomeview.frame.origin.y - CGFloat(10 * i + 10), width: incomeview.frame.width + CGFloat(8 * i + 8), height: incomeview.frame.height))
            newIncomeView.layer.cornerRadius = 10 ; newIncomeView.tag = i
            newIncomeView.backgroundColor = UIColor(hexString: "#424459")
            newIncomeView.layer.borderWidth = 2 ; newIncomeView.layer.borderColor = UIColor.white.cgColor
            view.addSubview(newIncomeView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(goALLincome))
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            newIncomeView.addGestureRecognizer(tap)
            newIncomeView.addGestureRecognizer(leftSwipe)
            newIncomeView.addGestureRecognizer(rightSwipe)
    
            
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
    
    @objc func goALLincome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav2") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
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
    
    func today() -> String {
        
        let date = Calendar(identifier: .gregorian)

        let formatter = DateFormatter()
        if settingArr!.last?.language == "Русский" {
            formatter.locale = Locale(identifier: "ru_RU")
        }
        formatter.calendar = date
        formatter.dateFormat = "LLLL yyyy"

        let today = Date()
        let dateString = formatter.string(from: today)
        
        return dateString
    }
    
    func chartsCircle() {
        
        for i in 0..<debtArr!.count {
            if debtArr![i].debt {
                debt = true
            }
        }
        
        if debt == false && moneyArr![5].categorys != 0 {
            for i in 0..<moneyArr!.count {
                do {
                    try realm.write {
                        if i != moneyArr!.count - 1 {
                            moneyArr![i].categorys += (moneyArr![5].categorys * devidedMoney[i])
                        } else {
                            moneyArr![i].categorys = 0
                        }
                    }
                } catch {
                    print(error)
                }
            }
            load()
        }
                
        if add == true {
            do {
                try realm.write {
                    for i in 0..<moneyArr!.count {
                        moneyArr![i].categorys += moneyArr![i].addMoney
                    }
                }
            } catch {
                print(error)
            }
        } else
        if spend == true {
            do {
                try realm.write {
                    moneyArr![indexTag].categorys -= moneyArr![indexTag].spendMoney
                }
            } catch {
                print(error)
            }
        }
        if moneyArr![0].categorys != 0 {
            categoryOne.value = moneyArr![0].categorys
            categoryOne.label = strArr["ozim"]
            numberOfdataEntries.append(categoryOne)
        }
        
        if moneyArr![1].categorys != 0 {
            categoryTwo.value = moneyArr![1].categorys
            categoryTwo.label = strArr["ota_onam"]
            numberOfdataEntries.append(categoryTwo)
        }
        
        if moneyArr![2].categorys != 0 {
            categoryThree.value = moneyArr![2].categorys
            categoryThree.label = strArr["fond"]
            numberOfdataEntries.append(categoryThree)
        }
        
        if moneyArr![3].categorys != 0 {
            categoryFour.value = moneyArr![3].categorys
            categoryFour.label = strArr["oilam"]
            numberOfdataEntries.append(categoryFour)
        }
        
        if moneyArr![4].categorys != 0 {
            categoryFive.value = moneyArr![4].categorys
            categoryFive.label = strArr["investitsiya"]
            numberOfdataEntries.append(categoryFive)
        }
        
        if debt && moneyArr![5].categorys != 0 {
            categorySix.value = moneyArr![5].categorys
            categorySix.label = strArr["qarz"]
            numberOfdataEntries.append(categorySix)
        }
        
        allMoney = categoryOne.value + categoryTwo.value + categoryThree.value + categoryFour.value + categoryFive.value + categorySix.value
        
        pieChart.chartDescription?.text = ""
        
        var size: CGFloat = 0
        
        if doubleToString(result: allMoney).count >= 8 {
            size = 0.7 * pieChart.frame.width / CGFloat(doubleToString(result: allMoney).count)
        } else {
            size = 20
        }
        
        let myAttribute = [NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: size)!]
        let myAttrString = NSAttributedString(string: doubleToString(result: allMoney), attributes: myAttribute)
        
        pieChart.centerAttributedText = myAttrString
        
        
        pieChart.legend.enabled = false
        pieChart.entryLabelFont = UIFont(name: "Chalkboard SE", size: 15)
        
        updateChartData()
    }
    
    func save(money: MoneyData) {
        do {
            try realm.write {
                realm.add(money)
            }
        } catch {
            print(error)
        }
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberOfdataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.flatRed(), UIColor.flatGreen(), UIColor.flatOrange(), UIColor.flatPlum(), UIColor.flatBlue(), UIColor.flatBlackColorDark()]
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewController(withIdentifier: "nav5") as! UINavigationController
        let vC = vc.viewControllers.first as! Report
        vC.indexCategory = Int(highlight.x)
        
        switch Int(highlight.x) {
            
        case 0: vC.nameCategory = strArr["ozim"]!
            break
        case 1: vC.nameCategory = strArr["ota_onam"]!
            break
        case 2: vC.nameCategory = strArr["fond"]!
            break
        case 3: vC.nameCategory = strArr["oilam"]!
            break
        case 4: vC.nameCategory = strArr["investitsiya"]!
            break
        case 5: vc = storyboard.instantiateViewController(withIdentifier: "nav7") as! UINavigationController
            break
            
        default: break
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func plus(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav3") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func debt(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav6") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func minus(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nav4") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    func load() {
        settingArr = realm.objects(SettingsData.self)
        incomeArr = realm.objects(IncomData.self)
        moneyArr = realm.objects(MoneyData.self)
        debtArr = realm.objects(DebtData.self)
    }
    
}


