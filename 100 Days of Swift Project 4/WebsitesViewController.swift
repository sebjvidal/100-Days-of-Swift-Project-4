//
//  WebsitesViewController.swift
//  100 Days of Swift Project 4
//
//  Created by Seb Vidal on 17/11/2021.
//

import UIKit

class WebsitesViewController: UITableViewController {

    let websites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteCell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "WebViewView") as? ViewController {
            detailViewController.websiteURL = URL(string: "https://\(websites[indexPath.row])")!
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}
