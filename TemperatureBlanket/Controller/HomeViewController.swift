//
//  HomeViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/23/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var yesterdayWeatherLabel: UILabel!
    @IBOutlet weak var yesterdayWeatherColorView: UIView!
    @IBOutlet weak var todayWeatherColorView: UIView!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    
    var blanket: Blanket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blanket = Blanket.retrieveBlanket()! // you shouldn't be able to get to this screen without a blanket

        // Do any additional setup after loading the view.
        setColorsAndLabels()
    }
    
    func setColorsAndLabels() {
        let yesterday = blanket.logs.dayFromInd(ind: blanket.logs.indexOfLastDay() ?? (0,0))
        let yesterdayColor = blanket.colors!.getColor(temp: yesterday!.temp)
        self.yesterdayWeatherColorView.backgroundColor = yesterdayColor
        self.yesterdayWeatherLabel.text = "Yesterday's Avg. Temp.: \(yesterday!.temp)°F"
        
        
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
