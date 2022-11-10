import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cntlr = routes.grouped("user")
        cntlr.post(use: create)
        cntlr.get("login", use: loginGet)
        let basicAuthProtected = cntlr.grouped(User.authenticator())
        basicAuthProtected.post("login", use: loginPost)
        
    }

    func create(req: Request) async throws -> User {
        try Create.validate(content: req)
        let create = try req.content.decode(Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            login: create.login,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        return user
    }
    
    func loginPost(req: Request) async throws -> UserToken {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return token
    }
    
    func loginGet(req: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: "WWW-Authenticate", value: "Basic realm='Login Required'")
        return Response(status: .unauthorized, headers: headers)
    }
}


extension UserController {
    struct Create: Content {
        var login: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension UserController.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("login", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
    
