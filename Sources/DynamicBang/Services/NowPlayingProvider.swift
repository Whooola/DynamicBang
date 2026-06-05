import AppKit
import MediaPlayer

@Observable
final class NowPlayingProvider {
    private(set) var title: String = ""
    private(set) var artist: String = ""
    private(set) var isPlaying: Bool = false
    private(set) var albumArt: NSImage?
    private var timer: Timer?

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
        if let info = MPNowPlayingInfoCenter.default().nowPlayingInfo {
            title = info[MPMediaItemPropertyTitle] as? String ?? ""
            artist = info[MPMediaItemPropertyArtist] as? String ?? ""
            isPlaying = !title.isEmpty
            if let artData = info[MPMediaItemPropertyArtwork] as? MPMediaItemArtwork {
                albumArt = artData.image(at: NSSize(width: 32, height: 32))
            }
            return
        }

        if let track = getMusicAppTrack() {
            title = track.title
            artist = track.artist
            isPlaying = true
            return
        }

        if let track = getSpotifyTrack() {
            title = track.title
            artist = track.artist
            isPlaying = true
            return
        }

        isPlaying = false
        title = ""
        artist = ""
    }

    private func getMusicAppTrack() -> (title: String, artist: String)? {
        let script = """
        if application "Music" is running then
            tell application "Music"
                if player state is playing then
                    return name of current track & "|||" & artist of current track
                end if
            end tell
        end if
        """
        return runAppleScriptAndParse(script)
    }

    private func getSpotifyTrack() -> (title: String, artist: String)? {
        let script = """
        if application "Spotify" is running then
            tell application "Spotify"
                if player state is playing then
                    return name of current track & "|||" & artist of current track
                end if
            end tell
        end if
        """
        return runAppleScriptAndParse(script)
    }

    private func runAppleScriptAndParse(_ script: String) -> (title: String, artist: String)? {
        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let result = appleScript?.executeAndReturnError(&error)
        guard error == nil, let output = result?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines),
              !output.isEmpty
        else { return nil }

        let parts = output.components(separatedBy: "|||")
        guard parts.count == 2 else { return nil }
        return (parts[0].trimmingCharacters(in: .whitespaces),
                parts[1].trimmingCharacters(in: .whitespaces))
    }
}
