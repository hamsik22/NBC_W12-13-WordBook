# iOS Vocabulary API

swift 프로그래밍 관련 용어, 함수, 타입에 대한 정보를 제공하는 `RESTful API`입니다.

## API 개요
- Base URL: `https://iosvocabulary-default-rtdb.firebaseio.com/`
- 데이터 형식 : JSON
- 인증 : 불필요 (공개 API)

## 카테고리 정보

### 전체 카테고리 목록 조회
```http
GET https://iosvocabulary-default-rtdb.firebaseio.com/categories.json
```

### 응답 예시 : 
```json
{
  "cat1": {
    "id": "1",
    "name": "Swift 내장 함수"
  },
  "cat2": {
    "id": "2",
    "name": "Swift 내장 키워드"
  },
  "cat3": {
    "id": "3",
    "name": "Swift 내장 클래스 및 구조체"
  },
  "cat4": {
    "id": "4",
    "name": "개발영어"
  },
  "cat5": {
    "id": "5",
    "name": "마케팅 용어"
  }
}
```

### 특정 카테고리 정보 조회
```http
GET https://iosvocabulary-default-rtdb.firebaseio.com/categories/cat1.json
```

### 응답 예시:
```json
{
  "id": "1",
  "name": "Swift 내장 함수"
}
```

---
## 항목 조회
### 전체 데이터 조회
```http
GET https://iosvocabulary-default-rtdb.firebaseio.com/.json
```

### 특정 카테고리의 항목 조회
```http
GET https://iosvocabulary-default-rtdb.firebaseio.com/items/category1.json
```

### 응답 예시:
```json
{
  "item1": {
    "definition": "콘솔에 출력",
    "details": "nil",
    "id": 1,
    "name": "print",
    "subName": "nil",
    "tag": "출력 함수"
  },
  "item2": {
    "definition": "문자열 전체를 대문자로 전환",
    "details": "nil",
    "id": 2,
    "name": "uppercased",
    "subName": "nil",
    "tag": "문자열 함수"
  }
  // ... 더 많은 항목들
}
```

### 특정 항목 조회
```http
GET https://iosvocabulary-default-rtdb.firebaseio.com/items/category1/
item1.json
```

### 응답 예시:
```json
{
  "definition": "콘솔에 출력",
  "details": "nil",
  "id": 1,
  "name": "print",
  "subName": "nil",
  "tag": "출력 함수"
}
```

---
## 사용 예시
### Swift (URLSession)
```swift
// 카테고리 목록 조회
guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/categories.json") else {
    print("Invalid URL")
    return
}

// DataTask
URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    
    guard let data = data else {
        print("No data received")
        return
    }
    
    do {
        let categories = try JSONDecoder().decode([String: Category].self, from: data)
        print(categories)
    } catch {
        print("Decoding error: \(error.localizedDescription)")
    }
}.resume()
```

### 에러 처리
```markdown
### 에러 처리
- 404 Not Found: 요청한 리소스를 찾을 수 없음
- 400 Bad Request: 잘못된 요청 구문, 유효하지 않은 요청
- 503 Service Unavailable: 서버 과부하 또는 유지보수로 인한 일시적 서비스 중단
```

---
## 데이터 모델
### Category
```swift
struct Category: Codable {
  id: string;		// 카테고리의 고유 식별자
  name: string;		// 카테고리의 이름
}
```

### Item
```swift
struct Item: Codable {
  definition: string;	// 용어나 함수의 정의
  details: string;		// 추가 설명이나 예시
  id: number;			// 항목의 고유 식별자
  name: string;			// 항목의 이름
  subName: string;		// 항목의 이름 줄임말에 대한 풀네임
  tag: string;			// 항목의 분류 태그
}
```
