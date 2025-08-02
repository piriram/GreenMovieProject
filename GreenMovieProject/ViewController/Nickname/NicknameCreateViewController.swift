//
//  NicknameSettingViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit

final class NicknameCreateViewController: UIViewController {
    
    let nicknameTextField = UITextField()
    let editButton = UIButton(type: .system)
    let completeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "닉네임 설정"
        
        configureUI()
        configureLayout()
        nicknameTextField.text = NicknameManager.shared.readNickname() ?? ""
    }
    
    func configureUI() {
        // 텍스트 필드 (편집 불가)
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
        
        // 편집 버튼
        editButton.setTitle("편집", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 15
        editButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        
        // 완료 버튼
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.primary, for: .normal)
        completeButton.layer.borderColor = UIColor.primary.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 24
        completeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        
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
    
  
    
    @objc func didTapEdit() {
        let detailVC = NicknameReadViewController()
        detailVC.initialNickname = nicknameTextField.text
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func didTapComplete() {
        navigationController?.popViewController(animated: true)
    }
}
