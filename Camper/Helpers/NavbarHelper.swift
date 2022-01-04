//
//  NavbarHelper.swift
//  Camper
//
//  Created by Filbert Hartawan on 27/12/21.
//

import Foundation
import UIKit

class NavbarHelper{
    static func setup(){
        /// Setup Navigation Background Color to Transparent
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        /// Setup Navigation Back Button Color to Black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .black
        
        /// Rempve Navigation Back Button Title
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
    }
}
