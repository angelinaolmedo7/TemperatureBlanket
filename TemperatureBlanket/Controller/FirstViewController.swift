//
//  FirstViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/20/21.
//

import UIKit

class FirstViewController: UIViewController {
    
    var networkManager = NetworkManager()
    var blanket: Blanket? = nil
    
    let cal: Calendar = Calendar(identifier: .gregorian)
    let formatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        Blanket.clearBlanket()  // for debug purposes

        // Do any additional setup after loading the view.
    }
    
    func proceedToBlanket() {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: "blanketLoaded", sender: nil)
        }
    }
    
    func proceedToNewBlanket() {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: "newBlanket", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let blanket = Blanket.retrieveBlanket() {
            self.blanket = blanket
            self.catchUpLogsAndProceed()
        }
        else {
            proceedToNewBlanket()
        }
    }
    
    // this should maybe be moved?
    func catchUpLogsAndProceed() {
        let year = self.blanket!.logs
        if year.isCaughtUp(cal: cal) {
            print("The records are caught up.")
            // we can save the blanket (redundant?) and move forward
            Blanket.saveBlanket(blanket: self.blanket)
            proceedToBlanket()
        }
        else {
            print("-----------Attempting to catch up-----------")
            // get the index for the last day recorded
            let lastDay = year.indexOfLastDay()
            // if nil, the calendar is empty. start it at jan 1
            let day: Date
            if lastDay == nil {
                day = formatter.date(from: "2021-01-01T01:00:00")!
            }
            else {
                let previousDay = year.dayFromInd(ind: lastDay!)!.date
                day = Calendar.current.date(byAdding: .day, value: 1, to: previousDay)!
            }
            
            let q = self.blanket!.location!.darkSkysCall(date: day)
            
            networkManager.getAPIresponse(query: q, endpoint: .dayInTime) { result in
                switch result {
                case let .failure(error):
                    print(error)
                case let .success(dayInTime):
                    DispatchQueue.main.async {
//                        print("From zip \(self.blanket!.zipcode) generated the following temp:")
//                        print("\(dayInTime)")
                        
                        // find a better way to do this
                        let ind = self.blanket!.logs.indexOfEmpty()
                        self.blanket!.logs.addDay(week: ind!.0, date: day, api: dayInTime as! DayInTimeResponse)
                        
                        // recursively call until full
                        self.catchUpLogsAndProceed()
                    }
                }
            }
        }
        
    }
    
//    func fetchWeather() {
//        networkManager.getAvgWeather() { result in
//            switch result {
//            case let .success(weather):
//                print(weather)
//            case let .failure(error):
//              print(error)
//            }
//        }
//        networkManager.getWeather() { result in
//            switch result {
//            case let .success(weather):
//                print(weather)
//                self.weather = weather
//            case let .failure(error):
//              print(error)
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
