//
//  SVGRendering.swift
//  
//  Copyright © 2022 René Hexel, all rights reserved.
//  Created by Rene Hexel on 14/5/2022.
//

import Foundation
import CSVGCairo

public extension SVGCairo {
    /// Scaling mode to use
    enum ScalingMode: Int, RawRepresentable {
        /// Scale width and height indepenently
        case independent = 0
        /// Scale to fit target size
        case aspectFit = 1
        /// Scale to fit target size
        case aspectFill = 2
    }
    /// Alignment to use
    enum Alignment: Int, RawRepresentable {
        /// Scale width and height indepenently
        case leading = 0
        /// Scale to fit target size
        case centre = 1
        /// Scale to fit target size
        case trailing = 2
        /// Alternative spelling for `centre`
        public var center: Alignment { .centre }
    }
    /// Render into the given Cairo context
    /// - Returns: Status indicating success or failure
    /// - Parameters:
    ///   - context: Cairo context to render into
    ///   - scale: Scaling factor to use
    ///   - scalingMode: The scaling mode to use
    ///   - horizontalAlignment: The horizontal alignment to use
    ///   - verticalAlignment: The vertical alignment to use
    ///   - red: Red component of the rendering source colour
    ///   - green:  Green component of the rendering source colour
    ///   - blue: Blue component of the rendering source colour
    ///   - alpha: Alpha component of the rendering source colour
    @inlinable func render(context: UnsafeMutablePointer<cairo_t>, scale: Double?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        render(context: context, scaleX: scale, scaleY: scale, width: nil, height: nil, scalingMode: scalingMode, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, red: red, green: green, blue: blue, alpha: alpha)
    }
    /// Render into the given Cairo context
    /// - Returns: Status indicating success or failure
    /// - Parameters:
    ///   - context: Cairo context to render into
    ///   - scaleX: Horizontal scaling factor to use
    ///   - scaleY: Vertiacal scaling factor to use
    ///   - scalingMode: The scaling mode to use
    ///   - horizontalAlignment: The horizontal alignment to use
    ///   - verticalAlignment: The vertical alignment to use
    ///   - red: Red component of the rendering source colour
    ///   - green:  Green component of the rendering source colour
    ///   - blue: Blue component of the rendering source colour
    ///   - alpha: Alpha component of the rendering source colour
    @inlinable func render(context: UnsafeMutablePointer<cairo_t>, scaleX: Double, scaleY: Double, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        render(context: context, scaleX: scaleX, scaleY: scaleY, width: nil, height: nil, scalingMode: scalingMode, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, red: red, green: green, blue: blue, alpha: alpha)
    }
    /// Render into the given Cairo context
    /// - Returns: Status indicating success or failure
    /// - Parameters:
    ///   - context: Cairo context to render into
    ///   - width: The width of the rendered image in pixels
    ///   - height: The height of the rendered image in pixels
    ///   - scalingMode: The scaling mode to use
    ///   - horizontalAlignment: The horizontal alignment to use
    ///   - verticalAlignment: The vertical alignment to use
    ///   - red: Red component of the rendering source colour
    ///   - green:  Green component of the rendering source colour
    ///   - blue: Blue component of the rendering source colour
    ///   - alpha: Alpha component of the rendering source colour
    @inlinable func render(context: UnsafeMutablePointer<cairo_t>, width: Int?, height: Int?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        render(context: context, scaleX: nil, scaleY: nil, width: width, height: height, scalingMode: scalingMode, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, red: red, green: green, blue: blue, alpha: alpha)
    }
    /// Render into the given Cairo context
    /// - Returns: Status indicating success or failure
    /// - Parameters:
    ///   - context: Cairo context to render into
    ///   - width: The width of the rendered image in pixels
    ///   - height: The height of the rendered image in pixels
    ///   - scaleX: Horizontal scale to use
    ///   - scaleY: Vertical scale to use
    ///   - scalingMode: The scaling mode to use
    ///   - horizontalAlignment: The horizontal alignment to use
    ///   - verticalAlignment: The vertical alignment to use
    ///   - red: Red component of the rendering source colour
    ///   - green:  Green component of the rendering source colour
    ///   - blue: Blue component of the rendering source colour
    ///   - alpha: Alpha component of the rendering source colour
    func render(context: UnsafeMutablePointer<cairo_t>, scaleX: Double?, scaleY: Double? = nil, width: Int?, height: Int?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        let (svgWidth, svgHeight) = size
        var svgw = Double(svgWidth)
        var svgh = Double(svgHeight)
        var resizingScaleX = scaleX ?? 1
        var resizingScaleY = scaleY ?? resizingScaleX
        if let width = width.flatMap(Double.init) {
            resizingScaleX = width / svgw
            if let height = height.flatMap(Double.init) {
                resizingScaleY = height / svgh
                if scalingMode == .aspectFit {
                    let scale = min(resizingScaleX, resizingScaleY)
                    resizingScaleX = scale
                    resizingScaleY = scale
                    var 𝜟x = 0.0, 𝜟y = 0.0
                    if horizontalAlignment != .leading  { 𝜟x = (width  - svgw * scale) }
                    if horizontalAlignment == .trailing { 𝜟x /= 2 }
                    if verticalAlignment != .leading    { 𝜟y = (height - svgh * scale) / 2 }
                    if verticalAlignment == .trailing   { 𝜟y /= 2 }
                    cairo_translate(context, 𝜟x, 𝜟y)
                } else if scalingMode == .aspectFill {
                    let scale = max(resizingScaleX, resizingScaleY)
                    resizingScaleX = scale
                    resizingScaleY = scale
                }
            } else { // only width was given
                if scalingMode == .independent {
                    resizingScaleY = 1
                } else {
                    resizingScaleY = resizingScaleX
                }
            }
        } else if let height = height.flatMap(Double.init) {
            resizingScaleY = height / svgh
            if scalingMode == .independent {
                resizingScaleX = 1
            } else {
                resizingScaleX = resizingScaleY
            }
        } else { // neither width nor height was given
            svgw *= resizingScaleX
            svgh *= resizingScaleY
        }
        cairo_scale(context, resizingScaleX, resizingScaleY)
        cairo_set_source_rgba(context, red, green, blue, alpha)
        return render(context: context)
    }
}
