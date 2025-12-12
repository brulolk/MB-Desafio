//
//  ExchangeCell.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit

protocol ExchangeCellDelegate: AnyObject {
    func didTapFavorite(on cell: ExchangeCell)
}

final class ExchangeCell: UITableViewCell {
    
    static let identifier = "ExchangeCell"
    weak var delegate: ExchangeCellDelegate?
    var exchangeId: Int? // Será usado no controle de favoritos
    
    // MARK: - UI Components
    // Card
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customCardBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Logo
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiarySystemFill // Placeholder visível
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Stack e Textos
    private let textStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let detailsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    // Botão Favorito
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Configuration
    func configure(with exchange: Exchange, isFavorite: Bool) {
        self.exchangeId = exchange.id
        nameLabel.text = exchange.name
        
        // Volume
        if let volume = exchange.volume {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 0
            volumeLabel.text = formatter.string(from: NSNumber(value: volume))
        } else {
            volumeLabel.text = "Vol: N/A"
        }
        
        // Data
        dateLabel.text = exchange.dateLaunched ?? "Data: --"
        
        // Logo
        let logoUrl = "https://s2.coinmarketcap.com/static/img/exchanges/64x64/\(exchange.id).png"
        if let url = URL(string: logoUrl) {
            logoImageView.load(url: url)
        }
        
        // Favorito
        let iconName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .customOrange : .systemGray
    }
    
    @objc private func favoriteTapped() {
        delegate?.didTapFavorite(on: self)
    }
    
    // MARK: - Layout
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(favoriteButton)
        
        textStack.addArrangedSubview(nameLabel)
        textStack.addArrangedSubview(detailsStack)
        detailsStack.addArrangedSubview(volumeLabel)
        
        let separator = UILabel()
        separator.text = "•"
        separator.textColor = .darkGray
        separator.font = .systemFont(ofSize: 12)
        detailsStack.addArrangedSubview(separator)
        
        detailsStack.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),
            
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 48),
            logoImageView.heightAnchor.constraint(equalToConstant: 48),
            
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            favoriteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            textStack.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
