//
//  main.swift
//  AutoLauncher
//
//  Created by Niclas Jeppsson on 09/04/2023.
//

import Cocoa

let delegate = AutoLauncherAppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
