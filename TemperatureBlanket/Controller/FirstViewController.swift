//
//  FirstViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/20/21.
//

import UIKit

class FirstViewController: UIViewController {
    
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        clearLogs()
        fetchWeather()
//        retrieveLogs()
    }
    
    func fetchWeather() {
        networkManager.getWeather() { result in
            switch result {
            case let .success(weather):
                print(weather)
//                self.weather = weather
            case let .failure(error):
              print(error)
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
