//
//  SettingViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {
    
    let profileCardView = ProfileCardView()
    let tableView = UITableView(frame: .zero, style: .plain)
    let items = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "설정"
        
        configureUI()
        
        configureLayout()
    }
    func configureUI(){
        configureProfileCard()
        configureTableView()
    }
    func configureProfileCard() {
        view.addSubview(profileCardView)
        
        profileCardView.configureData(
            nickname: UserInfoManager.shared.readNickname() ?? "",
            joinDate: "\(UserInfoManager.shared.readFormattedJoinDate()) 가입",
            boxNum: HeartManager.shared.readHeartCount()
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
        
        profileCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // 뷰가 화면에 나타나기 진전마다 호출
        super.viewWillAppear(animated)
        NotificationHelper.addObserver(self,
                                       selector: #selector(didUpdateProfileCard),
                                       name: NotificationHelper.updateNickname)
        NotificationHelper.addObserver(self,
                                       selector: #selector(didUpdateProfileCard),
                                       name: NotificationHelper.updateHeart)
    }
    
    @objc func profileCardTouched() {
        goProfileCard()
    }
    @objc func didUpdateProfileCard(){
        configureProfileCard()
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
            let alert = UIAlertController(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                
                HeartManager.shared.deleteAllHeart()
                UserInfoManager.shared.deleteUserInfo()
                RecentSearchManager.shared.deleteAllKeyword()
                
                let onboardingVC = OnboardingViewController()
                let nav = UINavigationController(rootViewController: onboardingVC)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = windowScene.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = nav
                    delegate.window?.makeKeyAndVisible()
                }
            }))
            
            present(alert, animated: true)
            
        }
    }
    
}
