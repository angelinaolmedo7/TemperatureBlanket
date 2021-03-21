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

    @IBOutlet weak var palettePickerView: UIPickerView!
    @IBOutlet weak var paletteDisplayStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.palettePickerView.delegate = self
        self.palettePickerView.dataSource = self
        
        updatePaletteDisplay()
    }
    
    func updatePaletteDisplay(palette: ColorPalette=ColorPresets.palettes.first!) {
        var colorInd = 0
        for view in paletteDisplayStackView.arrangedSubviews {
            view.backgroundColor = UIColor(hex: palette.colors[colorInd])
            colorInd += 1
        }
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

extension NewBlanketViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
       
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ColorPresets.palettes.count
    }
       
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ColorPresets.palettes[row].name
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(ColorPresets.palettes[row])
        self.updatePaletteDisplay(palette: ColorPresets.palettes[row])
    }
}
