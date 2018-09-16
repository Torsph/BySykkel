import Foundation
import UIKit

public class BySykkelViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    let viewModel: BySykkelViewModel

    public init(viewModel: BySykkelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        setup()
    }

    func setup() {
        title = "List"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BySykkelViewController: BySykkelViewModelDelegate {
    public func didLoad() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    public func didFail(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension BySykkelViewController: UITableViewDelegate {

}

extension BySykkelViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stations?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        guard let data = viewModel.stations?[indexPath.row] else {
            fatalError("Data is missing")
        }

        cell.textLabel?.text = "\(data.id) - \(data.title)"
        cell.detailTextLabel?.text = "Locks: \(data.number_of_locks) - Free/Occupied: \(data.availability?.bikes ?? 0)/\(data.availability?.locks ?? 0)"

        return cell
    }
}
