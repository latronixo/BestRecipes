import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animation: LottieAnimation?
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    
    init(
        animation: LottieAnimation?,
        loopMode: LottieLoopMode = .playOnce,
        animationSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.animation = animation
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
    }
    
    init(
        name: String,
        loopMode: LottieLoopMode = .playOnce,
        animationSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.animation = LottieAnimation.named(name)
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = contentMode
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Remove existing animation view
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let animation = animation else { return }
        
        let animationView = LottieAnimationView(animation: animation)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: uiView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor)
        ])
        
        animationView.play()
    }
}

// MARK: - Convenience Extensions
extension LottieView {
    func playbackMode(_ mode: PlaybackMode) -> LottieView {
        switch mode {
        case .playing(let loopMode):
            return LottieView(
                animation: self.animation,
                loopMode: loopMode,
                animationSpeed: self.animationSpeed,
                contentMode: self.contentMode
            )
        case .paused:
            // For paused mode, we'll need to modify the view to not auto-play
            return self
        }
    }
}

enum PlaybackMode {
    case playing(LottieLoopMode)
    case paused
}
