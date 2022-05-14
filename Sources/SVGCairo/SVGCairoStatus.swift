//
//  SVGCairoStatus.swift
//  
//
//  Created by Rene Hexel on 14/5/2022.
//
import CSVGCairo

public extension SVGCairo {
    /// Cairo SVG parsing/rendering status information
    typealias SVGCairoStatus = svg_cairo_status_t
}

public extension SVGCairo.SVGCairoStatus {
    /// Last operation was successful
    static let success = SVG_CAIRO_STATUS_SUCCESS
    /// Running out of memory
    static let noMemory = SVG_CAIRO_STATUS_NO_MEMORY
    /// An Input/Output error ocurred
    static let ioError = SVG_CAIRO_STATUS_IO_ERROR
    /// The provided file was not found
    static let fileNotFound = SVG_CAIRO_STATUS_FILE_NOT_FOUND
    /// A provided value was invalid
    static let invalidValue = SVG_CAIRO_STATUS_INVALID_VALUE
    /// The last call was invalid
    static let invalidCall = SVG_CAIRO_STATUS_INVALID_CALL
    /// Error trying to parse the given SVG
    static let parseError = SVG_CAIRO_STATUS_PARSE_ERROR
}
