//
//  NewBlanketViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/20/21.
//

import UIKit

class NewBlanketViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    let blanket = Blanket(logs: [], colors: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func createBlanketPressed(_ sender: Any) {
        
        generateColorBracket()
        
    }
    
    func generateColorBracket()  {
        networkManager.getAvgWeather() { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(weather):
                DispatchQueue.main.async {
                    let brackets = WeatherBracket(APIresponse: weather,
                                                  colors: ColorPresets.transPride)
                    self.blanket.colors = brackets
                    Blanket.saveBlanket(blanket: self.blanket)
                    self.dismiss(animated: true, completion: {
                        self.viewWillAppear(true)
                    })
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
