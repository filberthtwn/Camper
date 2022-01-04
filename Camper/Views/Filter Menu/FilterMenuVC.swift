//
//  FilterMenuVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 22/11/21.
//

import UIKit

class FilterMenuVC: UIViewController {

    var categories:[Category] = []
    
    @IBOutlet var closeBtn: CamperViewButton!
    @IBOutlet var categoryTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViews(){
        closeBtn.delegate = self
        categoryTV.register(UINib(nibName: "CategoryTVCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
    }
}

extension FilterMenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTVCell
        cell.configure(category: categories[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

extension FilterMenuVC: CamperButtonDelegate {
    func didButtonClicked(_ sender: CamperViewButton) {
        dismiss(animated: true, completion: nil)
    }
}
