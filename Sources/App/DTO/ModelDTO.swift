import Vapor
import Fluent


final class ModelDTO<T: Model>: Content {
    var data: T
    var category: String
    
    init (from model: T) {
        data = model
        category = String(describing: T.self)
    }
}
