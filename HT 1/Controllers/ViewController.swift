//
//  ViewController.swift
//  HT 1
//
//  Created by Маргарита Мальцева on 02.12.2020.
//

import UIKit

class ViewController: UIViewController {

    //https://swapi.dev/api/people/
    
    @IBOutlet weak var tableView: UITableView!
    
    var peopleList: [People] = ([
        People(name: "Name1", gender: "Gender1"),
        People(name: "Name2", gender: "Gender2")
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    //MARK:- Load Data
    private func loadData() {
        let url = URL(string: "https://swapi.dev/api/people")!
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
        let response = response as! HTTPURLResponse
              guard let data = data else{
                return
    }
            do {
        
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [ [String: Any?] ]
                for object in jsonArray {
                    if let name = object["name"] as? String,
                       let gender = object["gender"] as? String {
                        self.peopleList.removeAll()
                        self.peopleList.append(People(name: name, gender: gender))
                }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
            }
        catch (let jsonError) {
            print(jsonError)
        }
        }
        
        task.resume()
    }
        
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}
//MARK:- Table Views Delegate & Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleListCell", for: indexPath)
        
        let personList = peopleList[indexPath.row]
        
        cell.textLabel?.text = personList.name
        cell.detailTextLabel?.text = personList.gender
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
