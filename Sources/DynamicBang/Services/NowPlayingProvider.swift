import AppKit
import Darwin

@Observable
final class NowPlayingProvider {
    private(set) var title: String = ""
    private(set) var artist: String = ""
    private(set) var isPlaying: Bool = false
    private(set) var albumArt: NSImage?
    private var timer: Timer?

    private typealias MRGetNowPlayingInfo = @convention(c) (
        DispatchQueue,
        @convention(block) @escaping (CFDictionary?) -> Void
    ) -> Void

    private var mrGetNowPlaying: MRGetNowPlayingInfo?
    private var didAttemptLoad = false

    func start() {
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    var displayText: String {
        guard isPlaying, !title.isEmpty else { return "" }
        if artist.isEmpty {
            return title
        }
        return "\(title) — \(artist)"
    }

    private func update() {
        if let mr = loadMRMediaRemote() {
            mr(DispatchQueue.main) { [weak self] info in
                guard let self, let info = info as? [String: Any] else {
                    self?.clearNowPlaying()
                    return
                }
                let t = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String ?? ""
                let a = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? ""
                let rate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double ?? 0

                DispatchQueue.main.async {
                    if !t.isEmpty, rate > 0 {
                        self.title = t
                        self.artist = a
                        self.isPlaying = true
                        if let artData = info["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                            self.albumArt = NSImage(data: artData)
                        } else {
                            self.albumArt = nil
                        }
                    } else {
                        self.clearNowPlaying()
                    }
                }
            }
        } else {
            clearNowPlaying()
        }
    }

    private func loadMRMediaRemote() -> MRGetNowPlayingInfo? {
        if didAttemptLoad { return mrGetNowPlaying }
        didAttemptLoad = true
        guard let handle = dlopen(
            "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote",
            RTLD_NOW
        ) else { return nil }
        guard let sym = dlsym(handle, "MRMediaRemoteGetNowPlayingInfo") else { return nil }
        mrGetNowPlaying = unsafeBitCast(sym, to: MRGetNowPlayingInfo.self)
        return mrGetNowPlaying
    }

    private func clearNowPlaying() {
        isPlaying = false
        title = ""
        artist = ""
        albumArt = nil
    }
}
