import Foundation

enum SomeEnum: Codable {
    case one
    case two

    var encoded: Data? {
        return try? JSONEncoder().encode(self)
    }
}


if let one = SomeEnum.one.encoded {
    UserDefaults.standard.set(one, forKey: "some_enum")

    if let value = UserDefaults.standard.object(forKey: "some_enum") as? Data {
        if let decodedValue = try? JSONDecoder().decode(SomeEnum.self, from: value) {
            print(decodedValue)
        }
    }
}
