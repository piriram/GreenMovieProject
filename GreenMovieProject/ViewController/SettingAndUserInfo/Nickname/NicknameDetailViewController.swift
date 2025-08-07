//
//  NicknameDetailViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit
import Toast
//TODO: 열거형으로 관리하기
final class NicknameDetailViewController: UIViewController {
    var initialNickname: String? = ""
    let nicknameTextField = UITextField()
    let statusLabel = UILabel()
    var onNicknameClosure: ((String) -> Void)?
    let underline = UIView()
    var status:NicknameStatus = .shortOrLong
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "닉네임 설정"
        configureUI()
        configureLayout()
        configureData()
        configureAction()
    }
    
    func configureUI() {
        view.addSubview(nicknameTextField)
        view.addSubview(statusLabel)
        nicknameTextField.addSubview(underline)
        nicknameTextField.textColor = .white
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        
        underline.backgroundColor = .lightGray

        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .primary
        statusLabel.textAlignment = .left
        statusLabel.numberOfLines = 1
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureStatusLabel() {
        status = confirmValidateNickname()
        statusLabel.text = status.result.message
        statusLabel.textColor = status.result.color
    }
    
    func confirmValidateNickname() -> NicknameStatus{
        guard let text = nicknameTextField.text,!text.isEmpty else {
            return .shortOrLong
        }
        
        if text.count < 2 || text.count >= 10 {
            return .shortOrLong
        }
        
        /// 숫자가 들어있는지 확인
        let hasNumber = text.contains { char in
            return char.isNumber
        }

        if hasNumber{
            return .containsNumber
        }
        
        /// 이상한 문자가 있는지 확인
        let unvalidChars:Set<Character> = ["@","#","$","%"]
        let hasUnvalidChar = text.contains { char in
            return unvalidChars.contains(char)
        }
        
        if hasUnvalidChar{
            return .containsSymbol
        }
        return .valid
    }
    
    func configureData(){
        nicknameTextField.text = initialNickname
        configureStatusLabel() // 이작업은 NicknameUpdateViewController때문에 닉네임 텍스트필드가 초기화된다음 시행
    }
    
    func configureAction(){
        navigationItem.leftBarButtonItem = .actionBackBarButton(target: self, action: #selector(navBackButtonClicked))
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nicknameTextField.becomeFirstResponder()
    }
    
    @objc private func navBackButtonClicked() {
        if status == .valid {
            onNicknameClosure?(nicknameTextField.text!)
            navigationController?.popViewController(animated: true)
        }
        else{
            ToastHelper.centerToast(view: self.view, message: status.result.message)
        }
    }
    
    @objc func textFieldDidChange() {
        configureStatusLabel()
    }
}

