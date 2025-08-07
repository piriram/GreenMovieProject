//
//  NicknameSettingViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit

final class NicknameCreateViewController: BaseViewController {
    
    let nicknameTextField = UITextField()
    let editButton = UIButton(type: .system)
    let completeButton = UIButton(type: .system)
    var underline = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "닉네임 설정"
        
        configureUI()
        configureLayout()
        nicknameTextField.text = UserInfoManager.shared.readNickname() ?? ""
    }
    
    func configureUI() {
        view.addSubview(nicknameTextField)
        view.addSubview(editButton)
        view.addSubview(completeButton)
        nicknameTextField.addSubview(underline)
        nicknameTextField.textColor = .white
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        nicknameTextField.isUserInteractionEnabled = false // 편집 불가
        underline.backgroundColor = .lightGray
        editButton.setTitle("편집", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 15
        editButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        editButton.addTarget(self, action: #selector(goEditClicked), for: .touchUpInside)
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.primary, for: .normal)
        completeButton.layer.borderColor = UIColor.primary.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 24
        completeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        completeButton.addTarget(self, action: #selector(completButtonClicked), for: .touchUpInside)
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(editButton.snp.leading).offset(-8)
            make.height.equalTo(30)
        }

        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(52)
            make.height.equalTo(30)
        }

        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }

    }
    
    
    
    @objc func goEditClicked() {
        let detailVC = NicknameDetailViewController()
        detailVC.initialNickname = nicknameTextField.text
        detailVC.onNicknameClosure = { [weak self] updatedNickname in
            self?.nicknameTextField.text = updatedNickname
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    @objc func completButtonClicked() {
        //        UserInfoManager.shared.createJoinDate(Date())
        guard let nicknameTextFieldText = nicknameTextField.text else { return }
        if nicknameTextFieldText.isEmpty {
            return
        }
        UserInfoManager.shared.createUserInfo(nicknameTextFieldText, Date())
        
        let tabBarController = MainViewController()
        
        // 씬딜리게이트 윈도우에 메인뷰컨 연결
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarController
            sceneDelegate.window?.makeKeyAndVisible()
        }
        //        navigationController?.popViewController(animated: true)
    }
}
