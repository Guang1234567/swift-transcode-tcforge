
import Foundation

import CBinding_Avi

public class AviLib {
    private static let TAG = "AviLib"

    private var pAvi_t: UnsafeMutablePointer<avi_t>?

    // Prevent direct instantiation.
    public init() {}

    deinit {
        defer { pAvi_t?.deallocate() }
        if let pAvi_t = pAvi_t {
            if AVI_close(pAvi_t) == 0 {
                // success
            }
        }
    }

    public func open(_ aviFilePath: String) -> Bool {
        aviFilePath.withCString { pFileName in
            pAvi_t = AVI_open_input_file(pFileName, 1)
        }

        guard pAvi_t != nil else {
            return false
        }

        return true
    }

    public func getWidth() -> Int32 {
        if let pAvi_t = pAvi_t {
            return AVI_video_width(pAvi_t)
        } else {
            return -1
        }
    }

    public func getHeight() -> Int32 {
        if let pAvi_t = pAvi_t {
            return AVI_video_height(pAvi_t)
        } else {
            return -1
        }
    }

    public func getFrameRate() -> Double {
        if let pAvi_t = pAvi_t {
            return AVI_frame_rate(pAvi_t)
        } else {
            return -1
        }
    }

    /// - Return  frameSize
    public func readFrame(vidbuf: UnsafeMutablePointer<Int8>, keyframe: UnsafeMutablePointer<Int32>) -> Int {
        if let pAvi_t = pAvi_t {
            return AVI_read_frame(pAvi_t, vidbuf, keyframe)
        } else {
            return -1
        }
    }
}
