// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CommandController from "./command_controller"
application.register("command", CommandController)

import CommandPaletteController from "./command_palette_controller"
application.register("command-palette", CommandPaletteController)

import MealController from "./meal_controller"
application.register("meal", MealController)

import ScannerController from "./scanner_controller"
application.register("scanner", ScannerController)


