import Vapor
import FluentPostgreSQL
import Leaf

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(LeafProvider())

    config.prefer(LeafRenderer.self, for: TemplateRenderer.self)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    var databases = DatabaseConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                                  port: 5432,
                                                  username: "vapor",
                                                  database: "vapor",
                                                  password: "password")

    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Post.self, database: .psql)
    services.register(migrations)
}