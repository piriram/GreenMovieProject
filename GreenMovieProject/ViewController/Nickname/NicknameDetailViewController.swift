//
//  NicknameDetailViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class NicknameDetailViewController: UIViewController {
    
    var initialNickname: String? = ""
    
    let nicknameTextField = UITextField()
    let statusLabel = UILabel()
    var onNicknameClosure: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "닉네임 설정"
        configureUI()
        configureLayout()
        nicknameTextField.text = initialNickname
        nicknameTextField.becomeFirstResponder()
        confirmValidateNickname()
    }
    
    func configureUI() {
        nicknameTextField.textColor = .white
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        nicknameTextField.addSubview(underline)
        underline.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .primary
        statusLabel.textAlignment = .left
        statusLabel.numberOfLines = 1
        
        view.addSubview(nicknameTextField)
        view.addSubview(statusLabel)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(navBackButtonClicked))
        backButton.tintColor = .primary
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func textFieldDidChange() {
        confirmValidateNickname()
    }
    
    func confirmValidateNickname() {
        guard let text = nicknameTextField.text else {
            statusLabel.text = ""
            return
        }
        
        if text.count < 2 || text.count >= 10 {
            statusLabel.textColor = .systemRed
            statusLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            return
        }
        
        if text.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            statusLabel.textColor = .systemRed
            statusLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            return
        }
        
        let disallowedSet = CharacterSet(charactersIn: "@#$%")
        if text.rangeOfCharacter(from: disallowedSet) != nil {
            statusLabel.textColor = .systemRed
            statusLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            return
        }
        
        statusLabel.textColor = .primary
        statusLabel.text = "사용할 수 있는 닉네임이에요"
    }
    
    @objc private func navBackButtonClicked() {
        if let nickname = nicknameTextField.text,
           nickname.count >= 2,
           nickname.count < 10,
           nickname.rangeOfCharacter(from: .decimalDigits) == nil,
           nickname.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) == nil {
            
            
            onNicknameClosure?(nickname)
        }
        navigationController?.popViewController(animated: true)
       
    }
    
}
