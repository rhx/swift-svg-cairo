import CSVGCairo

/// An SVG rendering class using cairo.
public class SVGCairo {
    /// Pointer to the underlying `svg_cairo_t`.
    @usableFromInline var svgc: UnsafeMutablePointer<svg_cairo_t>!

    /// Designated initialiser.
    @inlinable public init?() {
        guard svg_cairo_create(&svgc) == .success else { return nil }
    }
    @inlinable deinit {
        svg_cairo_destroy(svgc)
    }
    /// Parse the file at the given path.
    /// - Parameter fileName: The name of the file to parse
    /// - Returns: Status indicating success or failure
    @inlinable public func parse(fileName: UnsafePointer<CChar>) -> SVGCairoStatus {
        svg_cairo_parse(svgc, fileName)
    }
    /// Parse the given file at the given path.
    /// - Parameter file: A `FILE` pointer representing the file to parse
    /// - Returns: Status indicating success or failure
    @inlinable public func parse(file: UnsafeMutablePointer<FILE>) -> SVGCairoStatus {
        svg_cairo_parse_file(svgc, file)
    }
    /// Parse in-memory SVG.
    /// - Parameters:
    ///   - buffer: Pointer to the memory location containing the SVG source
    ///   - size: Size of the buffer in bytes
    /// - Returns: Status indicating success or failure
    @inlinable public func parse(buffer: UnsafePointer<CChar>, size: size_t) -> SVGCairoStatus {
        svg_cairo_parse_buffer(svgc, buffer, size)
    }
    /// Begin parsing SVG chunks
    /// - Returns: Status indicating success or failure
    @inlinable public func parseChunkBegin() -> SVGCairoStatus {
        svg_cairo_parse_chunk_begin(svgc)
    }
    /// Parse a chunk of in-memory SVG.
    /// - Parameters:
    ///   - chunk: Pointer to the memory location containing the SVG chunk
    ///   - size: Size of the buffer in bytes
    /// - Returns: Status indicating success or failure
    @inlinable public func parse(chunk: UnsafePointer<CChar>, size: size_t) -> SVGCairoStatus {
        svg_cairo_parse_chunk(svgc, chunk, size)
    }
    /// End parsing SVG chunks
    /// - Returns: Status indicating success or failure
    @inlinable public func parseChunkEnd() -> SVGCairoStatus {
        svg_cairo_parse_chunk_end(svgc)
    }
    /// Render into the given Cairo context
    /// - Parameter context: Cairo context to render into
    /// - Returns: Status indicating success or failure
    @inlinable public func render(context: UnsafeMutablePointer<cairo_t>) -> SVGCairoStatus {
        svg_cairo_render(svgc, context)
    }
    /// The view port dimensions for this SVG
    @inlinable public var size: (width: Int, height: Int) {
        get {
            var width = CUnsignedInt(0)
            var height = CUnsignedInt(0)
            svg_cairo_get_size(svgc, &width, &height)
            return (width: Int(width), height: Int(height))
        }
        set {
            svg_cairo_set_viewport_dimension(svgc, CUnsignedInt(newValue.width), CUnsignedInt(newValue.height))
        }
    }
}
