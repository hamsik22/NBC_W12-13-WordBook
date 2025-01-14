import UIKit
import SnapKit

class VocabularyCell: UITableViewCell {
    let containerView = UIView()
    let nameLabel = UILabel()
    let definitionLabel = UILabel()
    let memorizeTag = UIButton()
    let tagLabel = UILabel()
    
    var onMemorizeToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureContainerView()
        configureNameLabel()
        configureDefinitionLabel()
        configureMemorizeTag()
        configureTagLabel()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleMemorizeToggle() {
        onMemorizeToggle?()
        // 애니메이션 추가
        UIView.animate(withDuration: 0.3, animations: {
            self.memorizeTag.backgroundColor = self.memorizeTag.backgroundColor == .systemBlue ? .systemGray : .systemBlue
        })
    }

    private func configureContainerView() {
        containerView.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
    }

    private func configureNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.accessibilityIdentifier = "VocabularyCell.NameLabel"
        containerView.addSubview(nameLabel)
    }

    private func configureDefinitionLabel() {
        definitionLabel.font = UIFont.systemFont(ofSize: 14)
        definitionLabel.textColor = .darkGray
        definitionLabel.numberOfLines = 0
        definitionLabel.accessibilityIdentifier = "VocabularyCell.DefinitionLabel"
        containerView.addSubview(definitionLabel)
    }

    private func configureMemorizeTag() {
        memorizeTag.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        memorizeTag.layer.cornerRadius = 8
        memorizeTag.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        memorizeTag.accessibilityLabel = "Memorization Toggle"
        memorizeTag.accessibilityHint = "Double tap to toggle memorization state"
        memorizeTag.addTarget(self, action: #selector(handleMemorizeToggle), for: .touchUpInside)
        containerView.addSubview(memorizeTag)
    }

    private func configureTagLabel() {
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        tagLabel.textColor = .black
        tagLabel.textAlignment = .center
        tagLabel.clipsToBounds = true
        tagLabel.accessibilityIdentifier = "VocabularyCell.TagLabel"
        containerView.addSubview(tagLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(16)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.lessThanOrEqualTo(memorizeTag.snp.leading).offset(-8)
        }

        memorizeTag.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalTo(containerView).offset(-16)
            make.height.equalTo(24)
        }

        definitionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.bottom.lessThanOrEqualTo(containerView).offset(-16)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).offset(-8)
            make.bottom.equalTo(containerView).offset(-8)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(50)
        }
    }
}
