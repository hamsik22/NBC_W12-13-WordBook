import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let startButton = UIButton()
    var viewModel: WordCardStackViewModel
    private let disposeBag = DisposeBag()
    private let sidebarButton = UIBarButtonItem(image: UIImage(systemName: "sidebar.right"), style: .plain, target: nil, action: nil)
    private let searchBar = UISearchBar()
    private var filteredVocabularies: [Word] = []
    private var isSidebarVisible = false

    init(viewModel: WordCardStackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchWords()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "Voca"
        navigationItem.rightBarButtonItem = sidebarButton

        view.addSubview(searchBar)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VocabularyCell.self, forCellReuseIdentifier: "VocabularyCell")
        view.addSubview(tableView)

        startButton.setTitle("시작할까요?", for: .normal)
        startButton.backgroundColor = .srBlue600Primary
        startButton.setTitleColor(.sr100White, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(startButton)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(startButton.snp.top).offset(-8)
        }

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.height.equalTo(50)
        }

        // 사이드바 초기화
        setupSidebar()
    }
    
    @objc private func start() {
        viewModel.fetchWords() // 데이터를 최신화합니다.
        let wordCardStackVC = WordCardStackViewController(with: viewModel)
        navigationController?.pushViewController(wordCardStackVC, animated: true)
    }

    private func bindViewModel() {
        viewModel.vocabularies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vocabularies in
                self?.filteredVocabularies = vocabularies
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)


        sidebarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleSidebar()
            })
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.filterVocabulary(with: query)
            })
            .disposed(by: disposeBag)
    }

    private func filterVocabulary(with query: String) {
        if query.isEmpty {
            viewModel.vocabularies
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] vocabularies in
                    self?.filteredVocabularies = vocabularies
                    self?.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        } else {
            viewModel.vocabularies
                .map { vocabularies in
                    vocabularies.filter {
                        $0.name.lowercased().contains(query.lowercased()) ||
                        $0.definition.lowercased().contains(query.lowercased())
                    }
                }
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] filteredVocabularies in
                    self?.filteredVocabularies = filteredVocabularies
                    self?.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setupSidebar() {
        let sidebarVC = SidebarViewController()
        addChild(sidebarVC)
        view.addSubview(sidebarVC.view)
        sidebarVC.didMove(toParent: self)

        sidebarVC.view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(300)
            make.trailing.equalToSuperview().offset(300) // 초기 위치: 화면 밖
        }

        sidebarVC.onItemSelected = { [weak self] selectedItem in
            self?.isSidebarVisible = false
            self?.toggleSidebar()
            self?.viewModel.fetchItems(forCategory: selectedItem) // 선택된 카테고리로 데이터 갱신
        }
    }

    private func toggleSidebar() {
        isSidebarVisible.toggle()
        if let sidebarVC = children.first(where: { $0 is SidebarViewController }) as? SidebarViewController {
            sidebarVC.view.snp.updateConstraints { make in
                make.trailing.equalToSuperview().offset(isSidebarVisible ? 0 : 300)
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVocabularies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as? VocabularyCell else {
            return UITableViewCell()
        }

        let word = filteredVocabularies[indexPath.row]
        let isMemorized = viewModel.memorizedCards.contains(word.id)

        cell.configure(with: word, isMemorized: isMemorized)

        cell.onMemorizeToggle = { [weak self] in
            self?.viewModel.toggleMemorization(for: word.id)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }
}
