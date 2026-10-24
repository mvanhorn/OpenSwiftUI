//
//  WindowControllerTests.swift
//  OpenSwiftUITests

#if os(macOS)
import AppKit
import OpenAttributeGraphShims
@testable import OpenSwiftUI
import Testing

@MainActor
@Suite(.disabled(if: attributeGraphVendor == .oag))
struct WindowControllerTests {
    @Test(arguments: [
        (nil as CGSize?, CGSize(width: 200, height: 100), CGSize(width: 500, height: 300)),
        (CGSize(width: 640, height: 480), CGSize(width: 200, height: 100), CGSize(width: 640, height: 480)),
        (nil, CGSize(width: 700, height: 400), CGSize(width: 700, height: 400)),
        (CGSize(width: 640, height: 300), CGSize(width: 700, height: 400), CGSize(width: 700, height: 400)),
    ])
    func contentSizing(defaultSize: CGSize?, minimum: CGSize, expectedSize: CGSize) throws {
        _ = NSApplication.shared
        let hostingVC = NSHostingController(rootView: Color.red.frame(
            minWidth: minimum.width,
            maxWidth: 750,
            minHeight: minimum.height,
            maxHeight: 500
        ))
        let controller = WindowController(hostingVC, defaultSize: defaultSize)
        let window = try #require(controller.window)
        defer { window.close() }

        #expect(window.contentRect(forFrameRect: window.frame).size == expectedSize)
        #expect(window.styleMask.contains(.resizable))
        #expect(window.contentMinSize == minimum)
        #expect(window.contentMaxSize.width >= 1_000_000)
        #expect(window.contentMaxSize.height >= 1_000_000)

        window.setContentSize(CGSize(width: 800, height: 600))
        hostingVC.view.needsUpdateConstraints = true
        hostingVC.view.updateConstraintsForSubtreeIfNeeded()
        hostingVC.view.layoutSubtreeIfNeeded()
        #expect(window.contentRect(forFrameRect: window.frame).size == CGSize(width: 800, height: 600))
    }
}
#endif
