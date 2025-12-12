//
//  ExchangeDetailViewController.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit
import SafariServices

class ExchangeDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ExchangeDetailViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground // Placeholder visual
        return imageView
    }()
    
    private let headerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    // Cards de Informação
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    // Labels
    private let dateLabel = UILabel()
    private let makerFeeLabel = UILabel()
    private let takerFeeLabel = UILabel()
    
    // Descrição
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // Botão Web
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Visitar Website", for: .normal)
        button.backgroundColor = .customOrange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        return button
    }()
    
    // Seção de Moedas
    private let coinsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Principais Moedas"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let coinsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .customOrange
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    init(viewModel: ExchangeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetch()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Detalhes"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        headerStack.addArrangedSubview(logoImageView)
        headerStack.addArrangedSubview(nameLabel)
        
        infoStack.addArrangedSubview(createInfoCard(title: "Lançamento", valueLabel: dateLabel))
        infoStack.addArrangedSubview(createInfoCard(title: "Maker Fee", valueLabel: makerFeeLabel))
        infoStack.addArrangedSubview(createInfoCard(title: "Taker Fee", valueLabel: takerFeeLabel))
        
        contentStack.addArrangedSubview(headerStack)
        contentStack.addArrangedSubview(infoStack)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(websiteButton)
        contentStack.addArrangedSubview(UIView()) // Spacer
        contentStack.addArrangedSubview(coinsTitleLabel)
        contentStack.addArrangedSubview(coinsStack)
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createInfoCard(title: String, valueLabel: UILabel) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.font = .systemFont(ofSize: 15, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .left
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        
        return container
    }
    
    // MARK: - Binding & Update
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.handleState(state)
        }
    }
    
    private func handleState(_ state: DetailViewState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            scrollView.isHidden = true
            
        case .success:
            updateData()
            loadingIndicator.stopAnimating()
            scrollView.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.scrollView.alpha = 1
            }
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func updateData() {
        guard let detail = viewModel.detail else { return }
        nameLabel.text = detail.name
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        style.alignment = .justified
        descriptionLabel.attributedText = NSAttributedString(
            string: detail.description.isEmpty ? "Descrição indisponível." : detail.description,
            attributes: [
                .paragraphStyle: style,
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        if let url = URL(string: detail.logoURL) {
            logoImageView.load(url: url)
        }
        
        dateLabel.text = detail.launchedAt
        makerFeeLabel.text = detail.makerFee != nil ? String(format: "%.2f%%", detail.makerFee!) : "--"
        takerFeeLabel.text = detail.takerFee != nil ? String(format: "%.2f%%", detail.takerFee!) : "--"
        
        websiteButton.isHidden = detail.website.isEmpty
        
        renderCoinsList()
    }
    
    private func renderCoinsList() {
        coinsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if viewModel.coins.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "A listagem de pares de mercado é restrita ao plano 'Startup' da API CoinMarketCap (Erro 403). Atualize o plano para visualizar."
            emptyLabel.numberOfLines = 0
            emptyLabel.textAlignment = .center
            emptyLabel.font = .italicSystemFont(ofSize: 14)
            emptyLabel.textColor = .customOrange
            
            let container = UIView()
            container.backgroundColor = .secondarySystemBackground
            container.layer.cornerRadius = 12
            container.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
                emptyLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
                emptyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                emptyLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
            ])
            coinsStack.addArrangedSubview(container)
            return
        }
        
        for coin in viewModel.coins {
            let row = createCoinRow(coin: coin)
            coinsStack.addArrangedSubview(row)
        }
    }
    
    private func createCoinRow(coin: Coin) -> UIView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fill
        rowStackView.spacing = 8
        
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 8
        
        let symbolLabel = UILabel()
        symbolLabel.text = coin.pairName
        symbolLabel.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        symbolLabel.textColor = .label
        
        let priceLabel = UILabel()
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        priceLabel.text = formatter.string(from: NSNumber(value: coin.price))
        priceLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        priceLabel.textColor = .secondaryLabel
        priceLabel.textAlignment = .right
        
        rowStackView.addArrangedSubview(symbolLabel)
        rowStackView.addArrangedSubview(priceLabel)
        
        container.addSubview(rowStackView)
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rowStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            rowStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            rowStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            rowStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    // MARK: - Actions
    @objc private func openWebsite() {
        guard let urlString = viewModel.detail?.website, let url = URL(string: urlString) else { return }
        let safariView = SFSafariViewController(url: url)
        present(safariView, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
