//
//  coloursTrueFalse.swift
//  Random_Facts
//
//  Created by Aryaa Saravanakumar on 11/01/2021.
//

import UIKit

class coloursTrueFalse: UITableViewCell {

    
    @IBOutlet var colourSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchChanged(_ sender: Any) {
        if colourSwitch.isOn == true
        {
            coloursOn = true
        }
        else
        {
            coloursOn = false
        }
        print(coloursOn)
    }
}
