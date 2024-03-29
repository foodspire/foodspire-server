import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

//    app.migrations.add(User.Migration())
//    app.migrations.add(UserToken.Migration())
    app.migrations.add(Restaurant.Migration())
    app.migrations.add(Delivery.Migration())
    try app.autoMigrate().wait()

    app.views.use(.leaf)

    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator())

    // register routes
    try routes(app)
}
