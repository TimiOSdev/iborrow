//
//  OptionTableViewController.swift
//  iborrow
//
//  Created by sudo on 3/1/19.
//  Copyright © 2019 sudo. All rights reserved.
//

import UIKit
import MessageUI
import FittedSheets

class OptionTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    var memberImage: Data?
    var memberNumber: String?
    let options = ["View Image", "Send a text"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.tableHeaderView?.backgroundColor = UIColor.white
        return "What would you like to do?"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            let vc = segue.destination as! ImageViewController
            vc.myImages = UIImage(data: memberImage!)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        if #available(iOS 13.0, *) {
            view.tintColor = UIColor.systemBackground
            header.textLabel?.textColor = UIColor.label
        } else {
            view.tintColor = UIColor.white
            header.textLabel?.textColor = UIColor.black
        }
        header.textLabel?.textAlignment = .center
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let enumValue = options[indexPath.row]
        cell.textLabel?.text = enumValue
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        
        switch currentCell?.textLabel?.text {
        case "Send a text":
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            guard let number = memberNumber else { return }
            composeVC.recipients = ["\(number)"]
            composeVC.body = "Hello, I was wondering if you are done with my item? Is there a time you could return it?"
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            }
        case "View Image":
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            controller.myImages = UIImage(data: memberImage!)
            let sheet = SheetViewController(controller: controller, sizes: [.fullScreen])
            sheet.adjustForBottomSafeArea = true
            
            self.present(sheet, animated: false, completion: nil)
            performSegue(withIdentifier: "toSecond", sender: self)
        default: return
        }
    }
}
