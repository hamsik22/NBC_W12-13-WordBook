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
    private let sidebarButton = UIBarButtonItem(image: UIImage(systemName: "sidebar.right"), style: .plain, target: nil, action: nil)

    private lazy var sidebarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -2, height: 0)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var sidebarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "단어집 목록"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sidebarTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SidebarCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private var isSidebarVisible = false
    private let wordCategories = ["기본 단어집", "고급 단어집", "테스트 단어집"]
    private let noResultsLabel = UILabel() // 검색 결과 없을 때 표시용

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchVocabulary()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // 네비게이션 바 설정
        navigationItem.title = "Voca"
        navigationItem.rightBarButtonItem = sidebarButton // 버튼 추가

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

        // 사이드바 설정
        view.addSubview(sidebarView)
        sidebarView.addSubview(sidebarTitleLabel) // wp
        sidebarView.addSubview(sidebarTableView) // 사이드바에 TableView 추가

        sidebarView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(300) // 사이드바 너비
            make.trailing.equalTo(view.snp.trailing).offset(300) // 기본 숨김 상태
        }
        
        // 사이드바 제목에 여백을 추가하여 다이나믹 아일랜드에 가리지 않게 함
        sidebarTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8) // 다이나믹 아일랜드로부터 여백 추가
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        sidebarTableView.snp.makeConstraints { make in
            make.top.equalTo(sidebarTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
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

        // Rx로 네비게이션 버튼 동작 처리
        sidebarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleSidebar()
            })
            .disposed(by: disposeBag)

        // 사이드바 TableView 데이터 설정
        Observable.just(wordCategories)
            .bind(to: sidebarTableView.rx.items(cellIdentifier: "SidebarCell", cellType: UITableViewCell.self)) { index, wordCategory, cell in
                cell.textLabel?.text = wordCategory
                cell.textLabel?.textColor = .black
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            }
            .disposed(by: disposeBag)

        // 사이드바 TableView 셀 선택 이벤트 처리
        sidebarTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print("Selected word category: \(self?.wordCategories[indexPath.row] ?? "")")
                self?.toggleSidebar()
            })
            .disposed(by: disposeBag)
    }

    private func toggleSidebar() {
        isSidebarVisible.toggle()

        // 네비게이션 바 제목 숨기기/복원
        navigationItem.title = isSidebarVisible ? nil : "Voca"

        // 사이드바 위치 애니메이션
        sidebarView.snp.updateConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(isSidebarVisible ? 0 : 300)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
//
//@available(iOS 17.0, *)
//#Preview {
//    UINavigationController(rootViewController: WordListViewController())
//}
