import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    var audioPlayer: AVAudioPlayer?
    var selectedSoundURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.soundButton, .browseButton]
        return touchBar
    }

}

extension ViewController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        switch identifier {
        case .soundButton:
            let button = NSButton(title: "Play Sound", target: self, action: #selector(playSound))
            item.view = button
        case .browseButton:
            let button = NSButton(title: "Browse", target: self, action: #selector(browseForSound))
            item.view = button
        default:
            return nil
        }
        return item
    }
    
    @objc func playSound() {
        guard let soundURL = selectedSoundURL else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    @objc func browseForSound() {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["mp3"]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        
        openPanel.begin { (result) in
            if result == .OK {
                self.selectedSoundURL = openPanel.urls.first
            }
        }
    }
    
}

extension NSTouchBarItem.Identifier {
    static let soundButton = NSTouchBarItem.Identifier("com.yourcompany.soundButton")
    static let browseButton = NSTouchBarItem.Identifier("com.yourcompany.browseButton")
}
