// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CommandPaletteController from "./command_palette_controller"
application.register("command-palette", CommandPaletteController)

import ScannerController from "./scanner_controller"
application.register("scanner", ScannerController)
