import Vapor
import Fluent


final class ModelDTO<T: Model>: Content {
    var data: T
    var category: String
    
    init (from foodChoice: T) {
        data = foodChoice
        category = String(describing: T.self)
    }
}

