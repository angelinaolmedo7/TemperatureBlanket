//
//  SettingsViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/23/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var blanket: Blanket!

    @IBOutlet weak var colorViewsStack: UIStackView!
    @IBOutlet weak var colorLabelStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blanket = Blanket.retrieveBlanket()! // you shouldn't be able to get to this screen without a blanket

        // Do any additional setup after loading the view.
        self.updatePaletteDisplay()
    }
    
    func updatePaletteDisplay() {
        let colorBrackets = self.blanket.colors!.colorBrackets
        
        var colorInd = 0
        for view in colorViewsStack.arrangedSubviews {
            view.backgroundColor = colorBrackets[colorInd].getUIColor()
            colorInd += 1
        }
        colorInd = 0
        for view in colorLabelStack.arrangedSubviews {
            let min = String(colorBrackets[colorInd].minTemp ?? -100)
            let max = String(colorBrackets[colorInd].maxTemp ?? 200)
            
            // reformat this
            var txt = "\(min)°F - \(max)°F"
            if min == "-100" {
                txt = "Up to \(max)°F"
            }
            if max == "200" {
                txt = "\(min)°F and up"
            }
            (view as! UILabel).text = txt
            colorInd += 1
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
