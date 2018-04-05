import Vapor

extension Droplet {

    public func setupRoutes() throws {

        let postsController = PostsController(drop: self)
        postsController.addRoutes(to: self)

        let apiPostController = ApiPostController()
        apiPostController.addRoutes(to: self)

        let apiUsersController = ApiUsersController()
        apiUsersController.addRoutes(to: self)
    }
}
