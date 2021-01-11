//
//  ViewController.swift
//  Random_Facts
//
//  Created by Aryaa Saravanakumar on 11/01/2021.
//

import UIKit

var coloursOn: Bool = UserDefaults.standard.bool(forKey: "coloursOn")

class ViewController: UIViewController {

    @IBOutlet var factLabel: UILabel!
    @IBOutlet var reloadButtonOutlet: UIBarButtonItem!
    
    var facts: [fact] = []
    let randomFactAPI = "https://uselessfacts.jsph.pl/random.json?language=en" //api to call to
    
    var bufferCheck = 1
    let colours: [UIColor] = [UIColor(red: 192/255, green: 255/255, blue: 74/255, alpha: 1), UIColor(red: 255/255, green: 158/255, blue: 84/255, alpha: 1), UIColor(red: 255/255, green: 77/255, blue: 77/255, alpha: 1), UIColor(red: 255/255, green: 252/255, blue: 77/255, alpha: 1), UIColor(red: 87/255, green: 255/255, blue: 174/255, alpha: 1), UIColor(red: 233/255, green: 143/255, blue: 255/255, alpha: 1), UIColor(red: 120/255, green: 205/255, blue: 255/255, alpha: 1), UIColor(red: 120/255, green: 142/255, blue: 255/255, alpha: 1)]
    var previousColour = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(gotResponse), name: Notification.Name("GotFact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tooManyAttempts), name: Notification.Name("TooManyAttempts"), object: nil)
        
        reloadButtonOutlet.isEnabled = true
        
        if isFirstTimeOpening() == true
        {
            coloursOn = true
            UserDefaults.standard.setValue(coloursOn, forKey: "coloursOn")
        }
        
        previousColour = Int.random(in: 0...colours.count - 1)
        getResponse(urlString: randomFactAPI)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        bufferCheck += 1
        getResponse(urlString: randomFactAPI)
        facts.remove(at: 0) //so the list doesnt become really large
    }
    
    @objc func gotResponse()
    {
        //the response has been added to the fact list
        bufferCheck -= 1
        
        if bufferCheck == 0
        {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    var randomNumber = Int.random(in: 0...self.colours.count - 1)
                    while randomNumber == self.previousColour
                    {
                        randomNumber = Int.random(in: 0...self.colours.count - 1)
                    }
                    self.previousColour = randomNumber
                    //we have a new colour
                    self.factLabel.text = self.facts[self.facts.count - 1].text
                    
                    //change the background colour, if coloursOn is true
                    if coloursOn == true
                    {
                        self.view.backgroundColor = self.colours[randomNumber]
                    }
                    else
                    {
                        self.view.backgroundColor = UIColor.systemBackground
                    }
                }
                
            }
        }
    }
    
    @objc func tooManyAttempts()
    {
        reloadButtonOutlet.isEnabled = false
        DispatchQueue.main.async {
            self.factLabel.text = "You're Reading Too Fast"
        }
        print("wait")
        do
        {
            sleep(5)
        }
        print("go")
        getResponse(urlString: randomFactAPI)
        reloadButtonOutlet.isEnabled = false
    }
    
    func getResponse(urlString: String)
    {
        if let url = URL(string: urlString)
        {
            URLSession.shared.dataTask(with: url)
            { data, response, error in
                
                if let data = data
                {
                    if let jsonString = String(data: data, encoding: .utf8)
                    {
                        if jsonString == "Too Many Attempts."
                        {
                            //tell the user to slow down
                            print("Too fast")
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TooManyAttempts")))
                        }
                        else
                        {
                            //we can just decode the json string and add it to facts
                            let decoder = JSONDecoder()
                            let jsonData = jsonString.data(using: .utf8)
                            let decodedFact = try! decoder.decode(fact.self, from: jsonData!)
                            
                            //now add it to the list
                            self.facts.append(decodedFact)
                            print(decodedFact)
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "GotFact")))
                        }
                    }
                }
                
            }.resume()
        }
    }
    
    func isFirstTimeOpening() -> Bool {
      let defaults = UserDefaults.standard

      if(defaults.integer(forKey: "hasRun") == 0) {
          defaults.set(1, forKey: "hasRun")
          return true
      }
      return false

    }
    
    struct fact: Decodable
    {
        let id: String
        let text: String
        let source: String
        let source_url: String
        let language: String
        let permalink: String
    }

}

extension Array
{
    mutating func replace(at: Int, with: Element)
    {
        if at != self.count - 1
        {
            self.remove(at: at)
            self.insert(with, at: at)
        }
        else
        {
            self.remove(at: at)
            self.append(with)
        }
    }
}
