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
        
        setupContainerView()
        setupNameLabel()
        setupDefinitionLabel()
        setupMemorizeTag()
        setupTagLabel()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleMemorizeToggle() {
        onMemorizeToggle?()
        // UIButtonConfiguration을 사용하여 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.memorizeTag.backgroundColor =
                self.memorizeTag.backgroundColor == .systemBlue ? .systemGray : .systemBlue
        }
    }
    
    func configure(with word: Word, isMemorized: Bool) {
        nameLabel.text = word.name
        definitionLabel.text = word.definition

        var configuration = UIButton.Configuration.filled()
        configuration.title = isMemorized ? "Memorize" : "Not Memorize"
        configuration.baseBackgroundColor = isMemorized ? .systemGreen : .systemGray
        configuration.cornerStyle = .capsule

        memorizeTag.configuration = configuration
    }

    private func setupContainerView() {
        containerView.backgroundColor = .sr100White
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .sr900Black
        nameLabel.accessibilityIdentifier = "VocabularyCell.NameLabel"
        containerView.addSubview(nameLabel)
    }

    private func setupDefinitionLabel() {
        definitionLabel.font = UIFont.systemFont(ofSize: 14)
        definitionLabel.textColor = .sr700Gray
        definitionLabel.numberOfLines = 0
        definitionLabel.accessibilityIdentifier = "VocabularyCell.DefinitionLabel"
        containerView.addSubview(definitionLabel)
    }

    private func setupMemorizeTag() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Not Memorize"
        configuration.baseBackgroundColor = .srBlue600Primary
        configuration.cornerStyle = .capsule
        
        memorizeTag.configuration = configuration
        memorizeTag.accessibilityLabel = "Memorization Toggle"
        memorizeTag.accessibilityHint = "Double tap to toggle memorization state"
        memorizeTag.accessibilityTraits = .button
        memorizeTag.addTarget(self, action: #selector(handleMemorizeToggle), for: .touchUpInside)
        containerView.addSubview(memorizeTag)
    }

    private func setupTagLabel() {
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        tagLabel.textColor = .sr900Black
        tagLabel.textAlignment = .center
        tagLabel.clipsToBounds = true
        tagLabel.accessibilityIdentifier = "VocabularyCell.TagLabel"
        tagLabel.accessibilityTraits = .staticText
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
