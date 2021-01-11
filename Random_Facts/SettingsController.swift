//
//  SettingsController.swift
//  Random_Facts
//
//  Created by Aryaa Saravanakumar on 11/01/2021.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SettingsController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coloursCell", for: indexPath) as! coloursTrueFalse
        if coloursOn == true
        {
            cell.colourSwitch.isOn = true
        }
        else
        {
            cell.colourSwitch.isOn = false
        }
        return cell
    }
    
    
}
