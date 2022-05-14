//
//  ConvenienceAdditions.swift
//  
//  Copyright © 2022 René Hexel, all rights reserved.
//  Created by Rene Hexel on 14/5/2022.
//
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension SVGCairo {
    /// Width of the view port
    @inlinable var width: Int {
        get { size.width }
        set { size.width = newValue }
    }
    /// Height of the view port
    @inlinable var height: Int {
        get { size.height }
        set { size.height = newValue }
    }
    /// Parse the given file
    /// - Parameter fileURL: URL representing the file to parse
    /// - Returns: Status indicating success or failure
    @inlinable func parse(fileURL: URL) -> SVGCairoStatus {
        precondition(fileURL.isFileURL)
        return parse(fileName: fileURL.path)
    }
    /// Parse SVG from the given URL
    /// - Parameter url: URL pointing to the SVG to parse
    /// - Returns: Status indicating success or failure
    @inlinable func parse(url: URL) throws -> SVGCairoStatus {
        parse(data: try Data(contentsOf: url, options: .mappedIfSafe))
    }
    /// Parse SVG from the given URL
    /// - Parameter url: URL pointing to the SVG to parse
    /// - Returns: Status indicating success or failure
    @available(macOS 12.0, *)
    @inlinable func parse(url: URL) async throws -> SVGCairoStatus {
        let session = URLSession()
        let svgData = try await session.data(from: url).0
        return parse(data: svgData)
    }
    /// Parse the given SVG data
    /// - Parameter data: The data containing the SVG to parse
    /// - Returns: Status indicating success or failure
    @inlinable func parse(data: Data) -> SVGCairoStatus {
        data.withUnsafeBytes { buf in
            (buf.baseAddress?.assumingMemoryBound(to: CChar.self)).map {
                parse(buffer: $0, size: size_t(buf.count))
            } ?? .invalidCall
        }
    }
    /// Parse the given SVG data chunk
    /// - Parameter chunk: The data containing the SVG chunk to parse
    /// - Returns: Status indicating success or failure
    @inlinable func parse(chunk: Data) -> SVGCairoStatus {
        chunk.withUnsafeBytes { buf in
            (buf.baseAddress?.assumingMemoryBound(to: CChar.self)).map {
                parse(chunk: $0, size: size_t(buf.count))
            } ?? .invalidCall
        }
    }
}
