import UIKit

class SidebarViewController: UIViewController {

    // 클로저를 정의
    var onItemSelected: ((String) -> Void)?

    private var categories: [Category] = []  // Category 객체 배열로 변경
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCategories()
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

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

            do {
                // JSON 데이터를 Dictionary 형태로 디코딩
                let categoriesDict = try JSONDecoder().decode([String: Category].self, from: data)
                let categories = categoriesDict.values.sorted { $0.name < $1.name }

                DispatchQueue.main.async {
                    self?.categories = categories
                    self?.tableView.reloadData() // 테이블뷰 갱신
                }
            } catch {
                print("디코딩 실패: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

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
        // 선택된 카테고리의 id를 클로저로 전달
        onItemSelected?(selectedCategory.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
