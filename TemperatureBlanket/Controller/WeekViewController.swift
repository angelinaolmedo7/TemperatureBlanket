//
//  WeekViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import UIKit

class WeekViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var weekViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.weekViewController.delegate = self
        self.weekViewController.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return 7
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "WeekCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        // Get references to labels of cell
        myCell.textLabel!.text = "hh"
            
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
