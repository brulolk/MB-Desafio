//
//  SceneDelegate.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator? // Mantém referência forte para o coordinator não morrer

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Inicializa o Coordinator
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
