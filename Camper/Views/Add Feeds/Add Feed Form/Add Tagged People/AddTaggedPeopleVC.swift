//
//  AddTaggedPeopleVC.swift
//  Camper
//
//  Created by Filbert Hartawan on 20/12/21.
//

import UIKit

protocol AddTaggedPeopleDelegate{
    func didTaggedPeopleSelected(users: [User])
}

class AddTaggedPeopleVC: UIViewController {

    @IBOutlet var addPeopleBtn: UIButton!
    @IBOutlet var taggedPeopleTV: UITableView!
    
    private var isLoaded = false
    
    var delegate: AddTaggedPeopleDelegate?
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        title = "태그 된 사람"
        setupNavbar()
        
        taggedPeopleTV.register(UINib(nibName: "UserTVCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    private func setupNavbar(){
        navigationItem.showDismissIcon()
        navigationItem.showRightButton(target: self, title: "완료", do: #selector(doneAction))
    }
    
    @IBAction func addTaggedPeople(_ sender: Any) {
        let searchPeopleVC = SearchTaggedPeopleVC()
        searchPeopleVC.delegate = self
        let navVC = UINavigationController(rootViewController: searchPeopleVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    @objc private func doneAction(){
        delegate?.didTaggedPeopleSelected(users: users)
        dismiss(animated: true, completion: nil)
    }
}

extension AddTaggedPeopleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTVCell
        cell.delegate = self
        cell.configure(with: user, isRemoveable: true)
        return cell
    }
}

extension AddTaggedPeopleVC: SearchTaggedPeopleDelegate {
    func didSelectFollower(follower: User) {
        if !users.contains(where: { $0.id == follower.id }){
            users.append(follower)
            taggedPeopleTV.reloadData()
        }
    }
}

extension AddTaggedPeopleVC: UserCellDelegate {
    func didRemoveUser(user: User) {
        users.removeAll(where: { $0.id == user.id })
        taggedPeopleTV.reloadData()
    }
}
