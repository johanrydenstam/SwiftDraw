//
//  DOM.swift
//  SwiftVG
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright © 2016 WhileLoop Pty Ltd. All rights reserved.
//

public struct DOM {
    public typealias Float = Swift.Float
    public typealias Coordinate = Swift.Float
    public typealias Length = Swift.Int
    public typealias Opacity = Swift.Float
    public typealias Bool = Swift.Bool
}

extension DOM {
    struct Point {
        var x: Coordinate
        var y: Coordinate
        
        init(_ x: Coordinate, _ y: Coordinate) {
            self.x = x
            self.y = y
        }
        
        init(_ point: (Coordinate, Coordinate)) {
            self.x = point.0
            self.y = point.1
        }
    }
    
    enum FillRule: String {
        case nonzero
        case evenodd
    }

    enum Transform {
        case matrix(a: Float, b: Float, c: Float, d: Float, e: Float, f: Float)
        case translate(tx: Float, ty: Float)
        case scale(sx: Float, sy: Float)
        case rotate(angle: Float, cx: Float, cy: Float)
        case skewX(angle: Float)
        case skewY(angle: Float)
    }
}

extension DOM.Point: Equatable {
    static func ==(lhs: DOM.Point, rhs: DOM.Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension DOM.Transform: Equatable {
    static func ==(lhs: DOM.Transform, rhs: DOM.Transform) -> Bool {
        switch(lhs, rhs) {
        case (.matrix(let lval), .matrix(let rval)):
            return lval == rval
        case (.translate(let lval), .translate(let rval)):
            return lval == rval
        case (.scale(let lval), .scale(let rval)):
            return lval == rval
        case (.rotate(let lval), .rotate(let rval)):
            return lval == rval
        case (.skewX(let lval), .skewX(let rval)):
            return lval == rval
        case (.skewY(let lval), .skewY(let rval)):
            return lval == rval
        default:
            return false
        }
    }
}