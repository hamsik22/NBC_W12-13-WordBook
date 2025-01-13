import UIKit

class SidebarViewController: UIViewController {

    // 클로저를 정의
    var onItemSelected: ((String) -> Void)?

    private var items: [String] = []
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
                let names = categoriesDict.values.map { $0.name }.sorted()

                DispatchQueue.main.async {
                    self?.items = names
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
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        onItemSelected?(selectedItem) // 클로저 호출
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
