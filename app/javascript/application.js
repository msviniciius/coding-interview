import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import UsersFilterController from "./controllers/users_filter_controller"

const application = Application.start()
application.register("users_filter", UsersFilterController)