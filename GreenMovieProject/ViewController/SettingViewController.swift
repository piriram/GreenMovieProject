//
//  SettingViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class SettingViewController: UIViewController {
    
    let profileCardView = ProfileCardView()
    let tableView = UITableView(frame: .zero, style: .plain)
    let items = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "설정"
        
        configureNicknameCard()
        configureTableView()
        configureLayout()
    }
    
    func configureNicknameCard() {
        view.addSubview(profileCardView)
        
        profileCardView.configure(
            nickname: UserInfoManager.shared.readNickname() ?? "",
            joinDate: "\(UserInfoManager.shared.getFormattedJoinDate()) 가입",
            boxNum: HeartManager.shared.heartCount()
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileCardTouched))
        profileCardView.addGestureRecognizer(tap)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func configureLayout() {
        profileCardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileCardView.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func profileCardTouched() {
        let nextViewController = ViewController() // 임시
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.row]
        
        if selectedItem == "탈퇴하기" {
            print("탈퇴하기 누름")
            HeartManager.shared.removeAllHeart()
            UserInfoManager.shared.deleteUserInfo()
            
            
            let onboardingVC = OnboardingViewController()
            let nav = UINavigationController(rootViewController: onboardingVC)
            
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = windowScene.delegate as? SceneDelegate {
                delegate.window?.rootViewController = nav
                delegate.window?.makeKeyAndVisible()
            }
            
        }
    }
    
}
