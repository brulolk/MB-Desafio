//
//  UIImageView+Async.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit

extension UIImageView {
    
    func load(url: URL) {
        self.image = nil
        self.alpha = 0
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.image = image
                    UIView.animate(withDuration: 0.3) {
                        self.alpha = 1
                    }
                }
            } catch {
                self.backgroundColor = .secondarySystemBackground
            }
        }
    }
}
