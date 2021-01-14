//
//  ViewController.swift
//  GitHubViewerMVC
//
//  Created by Andrei Dobysh on 27.11.20.
//

import UIKit
import Combine

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.isEnabled = true
            textField.becomeFirstResponder()
        }
    }
    private var viewModel = RepositoryViewModel()
    
    @IBAction func goAction(_ sender: Any) {
        // unused
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = viewModel.name
        binding()
    }
    
    func binding() {
        textField.textPublisher
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellable)
        
        viewModel.$repos
           .receive(on: DispatchQueue.main)
           .sink { [weak self] items in
              self?.tableView.reloadData()
           }
           .store(in: &cancellable)
    }
    
    private var cancellable = Set<AnyCancellable>()

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.item(for: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryCell.self)) as? RepositoryCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = item.titleMessage
        cell.descriptionLabel.text = item.descriptionMessage
        return cell
    }
    
}
