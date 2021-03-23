//
//  NewBlanketViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/20/21.
//

import UIKit

class NewBlanketViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    let blanket = Blanket(zip: "", logs: nil, colors: nil, location: nil)

    @IBOutlet weak var zipTextField: UITextField!
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
        self.blanket.zipcode = zipTextField.text ?? "98110" // backup placeholder
        generateLocationObject()
    }
    
    func generateColorBracket()  {
        networkManager.getAPIresponse(query: [self.blanket.zipcode], endpoint: .historicalAvgs) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(weather):
                DispatchQueue.main.async {
                    let brackets = WeatherBracket(APIresponse: weather as! WeatherAvgsResponse,
                                                  colors: ColorPresets.transPride)
                    print("From zip \(self.blanket.zipcode) generated the following brackets:")
                    print("\(brackets)")
                    self.blanket.colors = brackets
                    Blanket.saveBlanket(blanket: self.blanket)
                    self.dismiss(animated: true, completion: {
                        self.viewWillAppear(true)
                    })
                }
            }
        }
    }
    
    func generateLocationObject() {
        networkManager.getAPIresponse(query: [self.blanket.zipcode], endpoint: .latlong) { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(loc):
                DispatchQueue.main.async {
                    let loc = Location(APIresponse: loc as! LatLongResponse)
                    print("From zip \(self.blanket.zipcode) generated the following location:")
                    print("\(loc)")
                    self.blanket.location = loc
                    Blanket.saveBlanket(blanket: self.blanket)
                    self.generateColorBracket()
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
