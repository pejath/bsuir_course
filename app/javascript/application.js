// Entry point for the build script in your package.json

import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

const application = Application.start()
Turbo.session.drive = false
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
