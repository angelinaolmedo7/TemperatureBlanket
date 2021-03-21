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

    override func viewDidLoad() {
        super.viewDidLoad()
        Blanket.clearBlanket()

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
        fetchWeather()
        if let blanket = Blanket.retrieveBlanket() {
            self.blanket = blanket
            print(self.blanket)
            proceedToBlanket()
        }
        else {
            proceedToNewBlanket()
        }
    }
    
    func fetchWeather() {
        networkManager.getAvgWeather() { result in
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
