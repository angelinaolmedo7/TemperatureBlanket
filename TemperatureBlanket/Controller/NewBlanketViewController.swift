//
//  NewBlanketViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/20/21.
//

import UIKit

class NewBlanketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func createBlanketPressed(_ sender: Any) {
        let blanket = Blanket(logs: [], colors: [])
        Blanket.saveBlanket(blanket: blanket)
        self.dismiss(animated: true, completion: {
            self.viewWillAppear(true)
        })
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
