//
//  RecentSearchView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class RecentSearchView: UIView {
    
    var keywords: [String] = []
    
    let titleLabel = UILabel()
    
    var keywordClosure: ((String) -> Void)?
    let scrollView = UIScrollView()
    lazy var keywordStackView = setupStackView()
    lazy var deleteAllButton = createClearAllButton()
    
    lazy var emptyView = EmptyMessageView(message: "최근 검색어 내역이 없습니다.")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureUI()
        configureLayout()
        configureAction()
        
        
    }
    func configureUI() {
        addSubview(titleLabel)
        addSubview(scrollView)
        addSubview(deleteAllButton)
        addSubview(emptyView)
        scrollView.addSubview(keywordStackView)
        
        titleLabel.text = "최근 검색어"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        
        
    }
    func setupStackView()-> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.clipsToBounds = true
        return stackView
    }
    func createClearAllButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadKeywords() {
        keywords = RecentSearchManager.shared.readKeywords()
        keywordStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for keyword in keywords {
            let chipView = createChip(for: keyword)
            keywordStackView.addArrangedSubview(chipView)
        }
        showEmptyView()
    }
    
    func showEmptyView() {
        if keywords.isEmpty {
            emptyView.show()
            deleteAllButton.isHidden = true
        }
        else{
            emptyView.hide()
            deleteAllButton.isHidden = false
        }
    }
    
    /// 외부에서 호출하여 키워드를 새로 갱신하는 함수
    func updateKeywords(_ newKeywords: [String]) {
        self.keywords = newKeywords
        reloadKeywords()
        showEmptyView()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-4)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(34)
            make.bottom.equalToSuperview()
        }
        
        keywordStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
    }
    
    
    func configureAction(){
        deleteAllButton.addTarget(self, action: #selector(clearAllButtonClicked), for: .touchUpInside)
        reloadKeywords()
    }
    func createChip(for keyword: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        
        let label = UILabel()
        label.text = keyword
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        
        let deleteButton = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)

        deleteButton.configuration = config
        deleteButton.addTarget(self, action: #selector(deleteKeywordClicked(_:)), for: .touchUpInside)
        deleteButton.tag = keywords.firstIndex(of: keyword) ?? -1

        container.addSubview(label)
        container.addSubview(deleteButton)
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chipTouched(_ :)))
        container.addGestureRecognizer(tap)
        container.tag = keywords.firstIndex(of: keyword) ?? -1
        return container
    }
    @objc func chipTouched(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return } // 딥다이빙
        let index = view.tag
        let keyword =  keywords[index]
        keywordClosure?(keyword)
    }
    
    @objc func deleteKeywordClicked(_ sender: UIButton) {
        let index = sender.tag
        let removed = keywords[index]
        RecentSearchManager.shared.deleteOneKeyword(removed)
        reloadKeywords()
    }
    @objc func clearAllButtonClicked() {
        RecentSearchManager.shared.deleteAllKeyword()
        keywords = []
        reloadKeywords()
        emptyView.show()
        deleteAllButton.isHidden = true
    }
    
}



