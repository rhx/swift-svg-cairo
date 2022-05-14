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
    /// Transformation information for rendering
    struct RenderingTransformation {
        /// Target width
        var width = 0.0
        /// Target height
        var height = 0.0
        /// Horizontal scaling
        var scaleX = 1.0
        /// Vertical scaling
        var scaleY = 1.0
        /// Horizontal translation
        var dx = 0.0
        /// Vertical translation
        var dy = 0.0
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
    /// - Returns: Status indicating success or failure
    func render(context: UnsafeMutablePointer<cairo_t>, scaleX: Double?, scaleY: Double? = nil, width: Int?, height: Int?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        let transformation = renderingTransformation(scaleX: scaleX, scaleY: scaleY, width: width, height: height, scalingMode: scalingMode, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        cairo_translate(context, transformation.dx, transformation.dy)
        cairo_scale(context, transformation.scaleX, transformation.scaleY)
        cairo_set_source_rgba(context, red, green, blue, alpha)
        return render(context: context)
    }
    /// Create transformation information for rendering into a given Cairo context
    /// - Parameters:
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
    /// - Returns: Transformation parameters for rendering
    func renderingTransformation(scaleX: Double?, scaleY: Double? = nil, width: Int?, height: Int?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre) -> RenderingTransformation {
        let (svgWidth, svgHeight) = size
        var transformation = RenderingTransformation(width: Double(svgWidth), height: Double(svgHeight), scaleX: scaleX ?? 1, scaleY: scaleY ?? scaleX ?? 1, dx: 0, dy: 0)
        if let width = width.flatMap(Double.init) {
            transformation.scaleX = width / transformation.width
            if let height = height.flatMap(Double.init) {
                transformation.scaleY = height / transformation.height
                if scalingMode == .aspectFit {
                    let scale = min(transformation.scaleX, transformation.scaleY)
                    transformation.scaleX = scale
                    transformation.scaleY = scale
                    if horizontalAlignment != .leading  { transformation.dx = (width  - transformation.width * scale) }
                    if horizontalAlignment == .trailing { transformation.dx /= 2 }
                    if verticalAlignment != .leading    { transformation.dy = (height - transformation.height * scale) / 2 }
                    if verticalAlignment == .trailing   { transformation.dy /= 2 }
                } else if scalingMode == .aspectFill {
                    let scale = max(transformation.scaleX, transformation.scaleY)
                    transformation.scaleX = scale
                    transformation.scaleY = scale
                }
            } else { // only width was given
                if scalingMode == .independent {
                    transformation.scaleY = 1
                } else {
                    transformation.scaleY = transformation.scaleX
                }
            }
        } else if let height = height.flatMap(Double.init) {
            transformation.scaleY = height / transformation.height
            if scalingMode == .independent {
                transformation.scaleX = 1
            } else {
                transformation.scaleX = transformation.scaleY
            }
        } else { // neither width nor height was given
            transformation.width  *= transformation.scaleX
            transformation.height *= transformation.scaleY
        }
        return transformation
    }
    /// Render into a PNG file with the given name
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
    /// - Returns: Status indicating success or failure
    func renderToPNG(fileName: UnsafePointer<CChar>, scaleX: Double? = nil, scaleY: Double? = nil, width: Int?, height: Int?, scalingMode: ScalingMode = .aspectFit, horizontalAlignment: Alignment = .centre, verticalAlignment: Alignment = .centre, red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) -> SVGCairoStatus {
        let transformation = renderingTransformation(scaleX: scaleX, scaleY: scaleY, width: width, height: height, scalingMode: scalingMode, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        guard let surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, CInt(transformation.width + 0.5), CInt(transformation.height + 0.5)) else { return .noMemory }
        defer { cairo_surface_destroy(surface) }
        guard let context = cairo_create(surface) else { return .noMemory }
        defer { cairo_destroy(context) }
        cairo_save(context)
        cairo_set_operator(context, CAIRO_OPERATOR_CLEAR)
        cairo_paint(context)
        cairo_restore(context)
        cairo_translate(context, transformation.dx, transformation.dy)
        cairo_scale(context, transformation.scaleX, transformation.scaleY)
        cairo_set_source_rgba(context, red, green, blue, alpha)
        let status = render(context: context)
        guard status == .success else { return status }
        guard cairo_surface_write_to_png(surface, fileName) == CAIRO_STATUS_SUCCESS else { return .ioError }
        return .success
    }
}
