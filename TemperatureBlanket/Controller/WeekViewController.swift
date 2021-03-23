//
//  WeekViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import UIKit

class WeekViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var blanket: Blanket!
    var activeWeek: Int!

    @IBOutlet weak var weekViewController: UITableView!
    @IBOutlet weak var weekPicker: UIPickerView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blanket = Blanket.retrieveBlanket()! // you shouldn't be able to get to this screen without a blanket
        self.activeWeek = (blanket.logs.indexOfLastDay() ?? (0,0)).0
        
        // Do any additional setup after loading the view.
        self.weekViewController.delegate = self
        self.weekViewController.dataSource = self
        
        self.weekPicker.delegate = self
        self.weekPicker.dataSource = self
        
        self.weekPicker.selectRow(activeWeek, inComponent: 0, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return self.blanket.logs.weeks[self.activeWeek].days.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "WeekCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        // Get the day object for the cell
        let day = self.blanket.logs.dayFromInd(ind: (self.activeWeek, indexPath.row))!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        
        var comp = "COMPLETE"
        if !day.complete {
            comp = "IN\(comp)"
        }
        
        myCell.textLabel!.text = "\(formatter.string(from: day.date)) | \(day.temp)°F | \(comp)"
        myCell.backgroundColor = blanket.colors?.getColor(temp: day.temp)
            
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle completed
        self.blanket.logs.dayFromInd(ind: (activeWeek, indexPath.row))!.toggleCompleted()
        Blanket.saveBlanket(blanket: self.blanket)
        self.weekViewController.reloadRows(at: [indexPath], with: .left)
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

extension WeekViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        return self.blanket.logs.indexOfLastDay()!.0 + 1
    }
       
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activeWeek = row
        self.weekViewController.reloadData()
    }
}
