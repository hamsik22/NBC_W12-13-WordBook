import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let startButton = UIButton()
    private let viewModel = WordListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchVocabulary() // 네트워크 데이터 가져오기
    }

    private func setupUI() {
        view.backgroundColor = .white

        // 네비게이션 바 설정
        navigationItem.title = "Voca"

        // TableView 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VocabularyCell.self, forCellReuseIdentifier: "VocabularyCell")
        view.addSubview(tableView)

        // 시작 버튼 설정
        startButton.setTitle("시작할까요?", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        view.addSubview(startButton)

        // SnapKit 오토레이아웃
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-8)
        }

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.height.equalTo(50)
        }
    }

    private func bindViewModel() {
        // ViewModel의 vocabularies Observable이 업데이트될 때 TableView를 리로드
        viewModel.vocabularies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        // TableView 셀 선택 이벤트 처리
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.toggleMemorizeState(at: indexPath.row)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            .disposed(by: disposeBag)
    }

    // UITableViewDataSource 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfVocabularies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as? VocabularyCell else {
            return UITableViewCell()
        }
        if let vocab = viewModel.vocabulary(at: indexPath.row) {
            cell.nameLabel.text = vocab.name
            cell.definitionLabel.text = vocab.definition
            cell.memorizeTag.setTitle(vocab.didMemorize ? "외웠어요" : "외우지 않았어요", for: .normal)
            cell.memorizeTag.backgroundColor = vocab.didMemorize ? .systemGreen : .systemGray

            cell.onMemorizeToggle = { [weak self] in
                self?.viewModel.toggleMemorizeState(at: indexPath.row)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }

    // UITableViewDelegate 구현 (추가적인 동작을 필요로 한다면 여기에 작성 가능)
}
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: WordListViewController())
}
