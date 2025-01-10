import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let startButton = UIButton()
    private let searchBar = UISearchBar()
    private let filterButton = UIButton()
    private let viewModel = WordListViewModel()
    private let disposeBag = DisposeBag()
    private let noResultsLabel = UILabel() // 검색 결과 없을 때 표시용

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

        // Search Bar 설정
        searchBar.placeholder = "Search words"
        view.addSubview(searchBar)

        // TableView 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VocabularyCell.self, forCellReuseIdentifier: "VocabularyCell")
        view.addSubview(tableView)

        // 필터 버튼 설정
        filterButton.setTitle("Show All", for: .normal)
        filterButton.setTitleColor(.systemBlue, for: .normal)
        filterButton.layer.cornerRadius = 8
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.systemBlue.cgColor
        view.addSubview(filterButton)

        // 시작 버튼 설정
        startButton.setTitle("시작할까요?", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        view.addSubview(startButton)

        // No Results Label 설정
        noResultsLabel.text = "No results found"
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
        view.addSubview(noResultsLabel)

        // SnapKit 오토레이아웃
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        filterButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-8)
        }

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.height.equalTo(50)
        }

        noResultsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindViewModel() {
        // 검색어와 ViewModel 바인딩
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)

        // 필터 버튼과 ViewModel 바인딩
        filterButton.rx.tap
            .withLatestFrom(viewModel.showMemorizedOnly)
            .map { !$0 }
            .bind(to: viewModel.showMemorizedOnly)
            .disposed(by: disposeBag)

        // 필터 버튼 제목 업데이트
        viewModel.showMemorizedOnly
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] showMemorizedOnly in
                self?.filterButton.setTitle(showMemorizedOnly ? "Show All" : "Show Memorized", for: .normal)
            })
            .disposed(by: disposeBag)

        // TableView 데이터 바인딩
        viewModel.filteredVocabularies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vocabularies in
                self?.noResultsLabel.isHidden = !vocabularies.isEmpty
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
        return viewModel.numberOfFilteredVocabularies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as? VocabularyCell else {
            return UITableViewCell()
        }
        if let vocab = viewModel.filteredVocabulary(at: indexPath.row) {
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
}
