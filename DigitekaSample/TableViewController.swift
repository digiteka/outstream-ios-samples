//
//  ViewController.swift
//  DigitekaSample
//
//  Created by Gilles SAMPIERI on 19/04/2021.
//

import UIKit
import DigitekaSDK

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Detail"
        default:
            break
        }
      
        return cell
    }
}


class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
