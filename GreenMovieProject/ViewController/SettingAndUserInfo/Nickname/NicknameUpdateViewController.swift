//
//  NicknameUpdateViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/4/25.
//
import UIKit
import SnapKit

final class NicknameUpdateViewController: BaseViewController {
    
    let nicknameTextField = UITextField()
    let editButton = UIButton(type: .system)
    let completeButton = UIButton(type: .system)
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "닉네임 수정"
        
        configureUI()
        configureLayout()
        nicknameTextField.text = UserInfoManager.shared.readNickname() ?? ""
    }
    
    func configureUI() {
        nicknameTextField.textColor = .white
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        nicknameTextField.isUserInteractionEnabled = false
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        nicknameTextField.addSubview(underline)
        underline.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
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
        
        view.addSubview(nicknameTextField)
        view.addSubview(editButton)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(editButton.snp.leading).offset(-8)
            $0.height.equalTo(30)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(52)
            $0.height.equalTo(30)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    
    
    @objc func goEditClicked() {
        let detailVC = NicknameDetailViewController()
        detailVC.initialNickname = nicknameTextField.text
        detailVC.onNicknameClosure = { [weak self] updatedNickname in
            self?.nicknameTextField.text = updatedNickname
            
        }
//        detailVC.configureStatusLabel()// 이떄 하면 텍스트가 빈값이라 원하는 작동이 안나옴
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    @objc func completButtonClicked() {
        
        guard let nicknameTextFieldText = nicknameTextField.text else { return }
        if nicknameTextFieldText.isEmpty {
            return
        }
        UserInfoManager.shared.createNickname(nicknameTextFieldText)
        
        dismiss(animated: true)
       
    }
}
