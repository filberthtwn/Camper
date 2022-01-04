//
//  AddLocationVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit

class AddLocationVC: UIViewController {

    @IBOutlet var locationTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavbar()
    }
    
    private func setupViews(){
        hideKeyboardWhenTappedAround()
        locationTV.register(UINib(nibName: "LocationTVCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }
    
    private func setupNavbar(){
        navigationItem.showDismissIcon()
        
        let searchTF = NavbarTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        searchTF.customDelegate = self
        searchTF.placeholder = "위치를 검색하세요"
        navigationItem.titleView = searchTF
    }
}

extension AddLocationVC: NavbarSearchViewDelegate{
    func textFieldDidChange(text: String) {
        print("ABC")
    }
}

extension AddLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        return cell
    }
}
