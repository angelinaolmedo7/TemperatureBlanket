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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blanket = Blanket.retrieveBlanket()! // you shouldn't be able to get to this screen without a blanket
        self.activeWeek = (blanket.logs.indexOfLastDay() ?? (0,0)).0

        // Do any additional setup after loading the view.
        self.weekViewController.delegate = self
        self.weekViewController.dataSource = self
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
        
        myCell.textLabel!.text = "\(day.temp)"
        myCell.backgroundColor = blanket.colors?.getColor(temp: day.temp)
            
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
//        selectedItem =
        // Manually call segue to detail view controller
        
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
