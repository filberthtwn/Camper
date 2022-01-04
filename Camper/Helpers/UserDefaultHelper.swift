//
//  UserDefaultHelper.swift
//  Camper
//
//  Created by Filbert Hartawan on 29/11/21.
//

import Foundation

class UserDefaultHelper {
    static let shared = UserDefaultHelper()
    
    func setupAccessToken(_ accessToken:String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(accessToken, forKey: "access_token")
        userDefaults.synchronize()
    }
    
    func getAccessToken() -> String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    func setupRefreshToken(_ refreshToken:String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(refreshToken, forKey: "refresh_token")
        userDefaults.synchronize()
    }
    
    func getRefreshToken() -> String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    func setupCurrentUser(_ user: User){
        do {
            let encodedUser = try JSONEncoder().encode(user)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedUser, forKey: "current_user")
            userDefaults.synchronize()
        }catch(let error) {
            print(error)
        }
    }
    
    func getCurrentUser()->User?{
        if let data = UserDefaults.standard.data(forKey: "current_user"){
            do {
                return try JSONDecoder().decode(User.self, from: data)
            }catch(let error){
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func deleteCurrentUser(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "access_token")
        userDefaults.removeObject(forKey: "refresh_token")
        userDefaults.removeObject(forKey: "current_user")
        userDefaults.synchronize()
    }
    
    func setupOpenedPopup(popupId: Int){
        var openedPopupIds = getOpenedPopups()
        openedPopupIds.append(popupId)
        let userDefaults = UserDefaults.standard
        userDefaults.set(openedPopupIds, forKey: "opened_popups")
        userDefaults.synchronize()
    }
    
    func getOpenedPopups() -> [Int]{
        return UserDefaults.standard.array(forKey: "opened_popups") as? [Int] ?? []
    }
}
