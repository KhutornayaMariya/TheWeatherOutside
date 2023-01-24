//
//  HourlyViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 13.01.23.
//

import UIKit

protocol HourlyForecastViewControllerProtocol: AnyObject {
    func show(with dataItems: HourViewModel)
}

final class HourlyViewController: UIViewController {
    
    var interactor: HourlyForecastInteractor?
    
    private var viewModel: HourViewModel?
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .singleLine
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .clear
        view.register(HourOverviewCell.self, forCellReuseIdentifier: String(describing: HourOverviewCell.self))
        view.register(WeatherDiagramCell.self, forCellReuseIdentifier: String(describing: WeatherDiagramCell.self))
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        interactor?.updateData()
    }
    
    private func setUp() {
        view.backgroundColor = .background
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HourlyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case .diagram:
            return 1
        default:
            return viewModel?.hoursForecast.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        switch indexPath.section {
        case .diagram:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDiagramCell",for: indexPath) as! WeatherDiagramCell
            cell.configure(with: viewModel.diagramData)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HourOverviewCell.self), for: indexPath) as! HourOverviewCell
            cell.configure(with: viewModel.hoursForecast[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case .diagram:
            return "DAY".localized
        default:
            return nil
        }
    }
}

private extension Int {
    static let diagram: Int = 0
}

extension HourlyViewController: HourlyForecastViewControllerProtocol {
    func show(with dataItems: HourViewModel) {
        self.viewModel = dataItems
        title = viewModel?.locationTitle
        tableView.reloadData()
    }
}
