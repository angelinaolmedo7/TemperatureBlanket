//
//  HomeViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/23/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var networkManager = NetworkManager()
    var blanket: Blanket!

    @IBOutlet weak var yesterdayWeatherLabel: UILabel!
    @IBOutlet weak var yesterdayWeatherColorView: UIView!
    @IBOutlet weak var yesterdayDateLabel: UILabel!
    @IBOutlet weak var todayWeatherColorView: UIView!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blanket = Blanket.retrieveBlanket()! // you shouldn't be able to get to this screen without a blanket

        // Do any additional setup after loading the view.
        setColorsAndLabels()
    }
    
    func setColorsAndLabels() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        
        let yesterday = blanket.logs.dayFromInd(ind: blanket.logs.indexOfLastDay() ?? (0,0))
        let yesterdayColor = blanket.colors!.getColor(temp: yesterday!.temp)
        self.yesterdayWeatherColorView.backgroundColor = yesterdayColor
        self.yesterdayWeatherLabel.text = "Yesterday's Avg. Temperature: \(yesterday!.temp)°F"
        self.yesterdayDateLabel.text = formatter.string(from: yesterday!.date)
        self.todayDateLabel.text = formatter.string(from: Date())
        
        networkManager.getAPIresponse(query: [blanket.zipcode], endpoint: .weather) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(weather):
                DispatchQueue.main.async {
                    let tempK = (weather as! WeatherResponse).main!.temp!
                    let temp = Int(Main.kelvinToF(kel: tempK))
                    self.todayWeatherLabel.text = "Current Temperature: \(temp)°F*"
                    self.todayWeatherColorView.backgroundColor = self.blanket.colors!.getColor(temp: temp)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
