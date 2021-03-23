//
//  CalendarViewController.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarCollectionView.register(CalendarCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "calendarCell")

        calendarCollectionView.reloadData()
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

extension CalendarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = width
        print("\(width), \(height)")
        return CGSize(width: width, height: height)
        
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 30  // placeholder
    }

    func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // calendarCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell",
                                                      for: indexPath) as! CalendarCollectionViewCell
        cell.setUp()
        print(cell)
        return cell
    }
}
