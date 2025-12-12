//
//  ExchangeListViewController.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit

class ExchangeListViewController: UIViewController {
    
    var coordinator: AppCoordinator?
    private var viewModel: ExchangeListViewModelProtocol
    
    // MARK: - UI Components
    // Barra de Busca
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar exchange..."
        searchController.searchBar.tintColor = .customOrange
        return searchController
    }()
    
    // Filtro de favorito
    private lazy var filterControl: UISegmentedControl = {
        let segments = ["Todos", "Favoritos"]
        let segmentedControl = UISegmentedControl(items: segments)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .secondarySystemBackground
        segmentedControl.selectedSegmentTintColor = .customOrange
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    // Table
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return tableView
    }()
    
    // Loading
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .customOrange
        return indicator
    }()
    
    // Label de lista vazia
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhuma exchange encontrada"
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Init
    init(viewModel: ExchangeListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupUI()
        bindViewModel()
        viewModel.fetchExchanges()
    }
    
    // MARK: - Setup
    private func setupAppearance() {
        title = "Exchanges"
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupUI() {
        view.addSubview(filterControl)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            filterControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: filterControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - ViewModel Action
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }
    
    private func handleState(_ state: ExchangeListViewState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            emptyStateLabel.isHidden = true
            
        case .success:
            loadingIndicator.stopAnimating()
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
            tableView.reloadData()
            
        case .empty:
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            emptyStateLabel.isHidden = false
            emptyStateLabel.text = "Nenhum resultado encontrado."
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            emptyStateLabel.isHidden = false
            emptyStateLabel.text = message
            
        case .idle:
            break
        }
    }
    
    // MARK: - Actions
    @objc private func filterChanged() {
        let type = ListFilterType(rawValue: filterControl.selectedSegmentIndex) ?? .all
        viewModel.filterChanged(to: type)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ExchangeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedExchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.identifier, for: indexPath) as? ExchangeCell else {
            return UITableViewCell()
        }
        
        let exchange = viewModel.displayedExchanges[indexPath.row]
        let isFavorite = viewModel.isFavorite(exchangeId: exchange.id)
        
        cell.configure(with: exchange, isFavorite: isFavorite)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exchange = viewModel.displayedExchanges[indexPath.row]
        coordinator?.showDetails(exchangeId: exchange.id)
    }
}

// MARK: - Search Results Updating
extension ExchangeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.search(query: text)
    }
}

// MARK: - Cell Delegate (Favoritar)
extension ExchangeListViewController: ExchangeCellDelegate {
    func didTapFavorite(on cell: ExchangeCell) {
        guard let id = cell.exchangeId else { return }
        
        // Feedback tátil para o usuário sentir que clicou
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        viewModel.toggleFavorite(exchangeId: id)
    }
}
