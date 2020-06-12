//
//  ViewController.swift
//  Exchange
//
//  Created by Аня on 07.06.2020.
//  Copyright © 2020 Аня. All rights reserved.
//

import UIKit
struct Currency: Decodable {
var rates: [String: Double]
var base: String
var date: String
}

class ViewController: UIViewController {
    @IBOutlet weak var Segment1: UISegmentedControl!
    @IBOutlet weak var Segment2: UISegmentedControl!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    
    var numberFromField_1: Double = 0
    var numberFromField_2: Double = 0
    var selectedSegment1: Int = 0
    var selectedSegment2: Int = 1
    var isDot: Bool = false
    var course: Double = 74.0
    var courses: [String: Double] = ["RUBUSD": 0.015,
    "RUBEUR": 0.013,
    "RUBGBP": 0.012,
    "USDRUB": 68.18,
    "USDEUR": 0.88,
    "USDGBP": 0.78,
    "EURRUB": 77.1,
    "EURUSD": 1.13,
    "EURGBP": 0.89,
    "GBPRUB": 86.92,
    "GBPUSD": 1.27,
    "GBPEUR": 1.13
    ]
    
    var pair: String = ""
    var exchangeRates: [String: Double] = [:]

    func fetchData() {
    guard var url = URL( string: "https://api.exchangeratesapi.io/latest?base=RUB") else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in

    guard let data = data else { return }
    guard error == nil else { return }

    do {
    let values = try JSONDecoder().decode(Currency.self, from: data)
        
    self.exchangeRates = values.rates
    self.courses["RUBUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
    self.courses["RUBEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
    self.courses["RUBGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
    } catch let error {
        print(error)
    }
    }.resume()

    url = URL( string: "https://api.exchangeratesapi.io/latest?base=USD")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in

    guard let data = data else { return }
    guard error == nil else { return }

    do {
    let values = try JSONDecoder().decode(Currency.self, from: data)
    self.exchangeRates = values.rates
    self.courses["USDRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
    self.courses["USDEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
    self.courses["USDGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
    } catch let error {
        print(error)
    }
    }.resume()

    url = URL( string: "https://api.exchangeratesapi.io/latest?base=EUR")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in

    guard let data = data else { return }
    guard error == nil else { return }

    do {
    let values = try JSONDecoder().decode(Currency.self, from: data)
    self.exchangeRates = values.rates
    self.courses["EURRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
    self.courses["EURUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
    self.courses["EURGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
    } catch let error {
        print(error)
    }
    }.resume()

    url = URL( string: "https://api.exchangeratesapi.io/latest?base=GBP")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in

    guard let data = data else { return }
    guard error == nil else { return }

    do {
    let values = try JSONDecoder().decode(Currency.self, from: data)
    self.exchangeRates = values.rates
    self.courses["GBPRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
    self.courses["GBPUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
    self.courses["GBPEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
    } catch let error {
        print(error)
    }
    }.resume()
    }
    
    func convert () {
        pair = ""
        switch selectedSegment1 {
        case 0:
            pair += "RUB"
        case 1:
            pair += "USD"
        case 2:
            pair += "EUR"
        case 3:
            pair += "GBP"
        default:
            pair += ""
        }
        switch selectedSegment2 {
        case 0:
            pair += "RUB"
        case 1:
            pair += "USD"
        case 2:
            pair += "EUR"
        case 3:
            pair += "GBP"
        default:
            pair += ""
        }
        if (pair != "USDUSD") && (pair != "RUBRUB") && (pair != "EUREUR") && (pair != "GBPGBP") {
            course = courses[pair]!
        }
        numberFromField_2 = Double(round(100000*numberFromField_1*course)/100000)
        Label2.text = String(numberFromField_2)
    }
    
    @IBAction func Numbers(_ sender: UIButton) {
        if sender.tag != 100 {
            Label1.text = Label1.text! + String(sender.tag)
            numberFromField_1 = Double(Label1.text!)!
            convert()
        }
        if isDot == false && sender.tag == 100 {
            isDot = true
            if Label1.text == ""{
                Label1.text = "0."
                numberFromField_1 = Double(Label1.text!)!
                convert()
            }
            else {
                Label1.text = Label1.text! + "."
                numberFromField_1 = Double(Label1.text!)!
                convert()
            }
        }
    }
    
    @IBAction func Trash(_ sender: UIButton) {
        isDot = false
        Label1.text = ""
        Label2.text = ""
        numberFromField_1 = 0.0
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        if Label1.text!.last != "." {
            Label1.text = String(Label1.text!.dropLast())
            if Label1.text != "" {
                numberFromField_1 = Double(Label1.text!)!
                convert()
            }
            else {
                numberFromField_1 = 0.0
                convert()
            }
        }
        else {
            isDot = false
            Label1.text = String(Label1.text!.dropLast())
            numberFromField_1 = Double(Label1.text!)!
            convert()
        }
    }
    
    @IBAction func ChangeSegment1(_ sender: UISegmentedControl) {
        Segment2.setEnabled(true, forSegmentAt: 0)
        Segment2.setEnabled(true, forSegmentAt: 1)
        Segment2.setEnabled(true, forSegmentAt: 2)
        Segment2.setEnabled(true, forSegmentAt: 3)
        selectedSegment1 = sender.selectedSegmentIndex
        Segment2.setEnabled(false, forSegmentAt: selectedSegment1)
        convert()
    }
    @IBAction func ChangeSegment2(_ sender: UISegmentedControl) {
        Segment1.setEnabled(true, forSegmentAt: 0)
        Segment1.setEnabled(true, forSegmentAt: 1)
        Segment1.setEnabled(true, forSegmentAt: 2)
        Segment1.setEnabled(true, forSegmentAt: 3)
        selectedSegment2 = sender.selectedSegmentIndex
        Segment1.setEnabled(false, forSegmentAt: selectedSegment2)
        convert()
    }
    
    @IBAction func Switch(_ sender: UIButton) {
        Segment1.selectedSegmentIndex = selectedSegment2
        Segment2.selectedSegmentIndex = selectedSegment1
        ChangeSegment1(Segment1)
        ChangeSegment2(Segment2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Segment1.setEnabled(false, forSegmentAt: 1)
        Segment2.setEnabled(false, forSegmentAt: 0)
        fetchData()
    }
    override var shouldAutorotate: Bool {
    return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return.portrait
    }
}
