import UIKit
import SnapKit

class SidebarViewController: UIViewController {

    // 카테고리가 선택되었을 때 실행될 클로저
    var onItemSelected: ((String) -> Void)?

    // 카테고리 데이터 배열
    private var categories: [Category] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCategories()
    }

    // MARK: - UI 설정
    private func setupUI() {
        view.backgroundColor = .systemGray6

        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - 카테고리 데이터 가져오기
    private func fetchCategories() {
        guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/categories.json") else {
            print("잘못된 URL입니다.")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("데이터 요청 실패: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("데이터가 없습니다.")
                return
            }

            self?.decodeCategories(from: data)
        }
        task.resume()
    }

    // MARK: - JSON 데이터 디코딩
    private func decodeCategories(from data: Data) {
        do {
            // JSON 데이터를 Dictionary로 변환
            let categoriesDict = try JSONDecoder().decode([String: Category].self, from: data)
            let sortedCategories = categoriesDict.values.sorted { $0.name < $1.name }

            DispatchQueue.main.async {
                self.categories = sortedCategories
                self.tableView.reloadData()
            }
        } catch {
            print("디코딩 실패: \(error.localizedDescription)")
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SidebarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        onItemSelected?(selectedCategory.id) // 선택된 카테고리 ID를 전달
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
