//
//  ViewController.swift
//  GitHubViewerMVC
//
//  Created by Andrei Dobysh on 27.11.20.
//

import UIKit

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private var viewModel = RepositoryViewModel()
    
    @IBAction func goAction(_ sender: Any) {
        viewModel.show(user: textField.text ?? "", completion: { [weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.update()
            }
        })
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func update() {
        tableView.reloadData()
    }

}

extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        let item = viewModel.item(for: indexPath.row)
        cell.titleLabel.text = item.titleMessage
        cell.descriptionLabel.text = item.descriptionMessage
        return cell
    }
    
}
