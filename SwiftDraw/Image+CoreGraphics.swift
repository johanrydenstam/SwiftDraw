//
//  Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 24/5/17.
//  Copyright 2020 Simon Whitty
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/swhitty/SwiftDraw
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#if canImport(CoreGraphics)
import CoreGraphics
import Foundation

public extension CGContext {

    func draw(_ image: SVG, fillColor: CGColor? = nil, in rect: CGRect? = nil)  {
        let defaultRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let renderer = CGRenderer(context: self)
        if let fillColor {
            renderer.setFill(color: fillColor)
        }

        guard let rect = rect, rect != defaultRect else {
            renderer.perform(image.commands)
            return
        }

        let scale = CGSize(width: rect.width / image.size.width,
                           height: rect.height / image.size.height)
        draw(image.commands, in: rect, scale: scale)
    }

    fileprivate func draw(_ commands: [RendererCommand<CGTypes>], in rect: CGRect, scale: CGSize = CGSize(width: 1.0, height: 1.0)) {
        let renderer = CGRenderer(context: self)
        saveGState()
        translateBy(x: rect.origin.x, y: rect.origin.y)
        scaleBy(x: scale.width, y: scale.height)
        renderer.perform(commands)
        restoreGState()
    }
}

public extension SVG {

    func pdfData(size: CGSize? = nil, insets: Insets = .zero) throws -> Data {
        let (bounds, pixelsWide, pixelsHigh) = makeBounds(size: size, scale: 1, insets: insets)
        var mediaBox = CGRect(x: 0.0, y: 0.0, width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))

        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData),
              let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw Error("Failed to create CGContext")
        }

        ctx.beginPage(mediaBox: &mediaBox)
        let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: mediaBox.size.height)
        ctx.concatenate(flip)
        ctx.draw(self, in: bounds)
        ctx.endPage()
        ctx.closePDF()

        return data as Data
    }

    private struct Error: LocalizedError {
        var errorDescription: String?

        init(_ message: String) {
            self.errorDescription = message
        }
    }
}

extension SVG {

    static func makeBounds(size: CGSize?,
                           defaultSize: CGSize,
                           scale: CGFloat,
                           insets: Insets) -> (bounds: CGRect, pixelsWide: Int, pixelsHigh: Int) {
        let viewport = CGSize(
            width: defaultSize.width - (insets.left + insets.right),
            height: defaultSize.height - (insets.top + insets.bottom)
        )

        let size = size ?? viewport

        let sx = size.width / viewport.width
        let sy = size.height / viewport.height

        let width = size.width * scale
        let height = size.height * scale
        let insets = insets.applying(sx: sx * scale, sy: sy * scale)
        let bounds = CGRect(x: -insets.left,
                            y: -insets.top,
                            width: width + insets.left + insets.right,
                            height: height + insets.top + insets.bottom)
        return (
            bounds: bounds,
            pixelsWide: Int(width),
            pixelsHigh: Int(height)
        )
    }
}

private extension SVG.Insets {
    func applying(sx: CGFloat, sy: CGFloat) -> Self {
        Self(
            top: top * sy,
            left: left * sx,
            bottom: bottom * sy,
            right: right * sx
        )
    }
}

private extension LayerTree.Size {
    init(_ size: CGSize) {
        self.width = LayerTree.Float(size.width)
        self.height = LayerTree.Float(size.height)
    }
}

#endif
