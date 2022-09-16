import Foundation

open class AsynchronousOperation: Operation {
    @objc enum State: Int {
        case ready
        case executing
        case finished
    }

    private static let stateKey = "state"
    private var rawState = State.ready

    @objc dynamic var state: State {
        get {
            return stateQueue.sync {
                return rawState
            }
        }
        set {
            willChangeValue(forKey: AsynchronousOperation.stateKey)
            stateQueue.sync(flags: .barrier) {
                rawState = newValue
            }
            didChangeValue(forKey: AsynchronousOperation.stateKey)
        }
    }

    private let stateQueue = DispatchQueue(
        label: "com.Malibu.ConcurrentOperation",
        attributes: .concurrent
    )

    var handleResponse: ((URLRequest?, Data?, URLResponse?, Error?) -> Void)?
    var makeUrlRequest: (() throws -> URLRequest)?

    override public final var isAsynchronous: Bool {
        return true
    }

    override public final var isReady: Bool {
        return super.isReady && state == .ready
    }

    override public final var isExecuting: Bool {
        return state == .executing
    }

    override public final var isFinished: Bool {
        return state == .finished
    }

    override public final func start() {
        super.start()

        guard !isCancelled else {
            state = .finished
            return
        }

        state = .executing
        execute()
    }

    // MARK: - KVO

    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return [AsynchronousOperation.stateKey]
    }

    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return [AsynchronousOperation.stateKey]
    }

    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return [AsynchronousOperation.stateKey]
    }

    // MARK: - Execute

    /// Subclasses must implement this without calling `super`.
    open func execute() {
        fatalError("Subclasses must implement `execute`.")
    }

    /// Moves the operation into a completed state.
    public final func finish() {
        state = .finished
    }

    func extractUrlRequest() throws -> URLRequest {
        guard let makeUrlRequest = makeUrlRequest else {
            throw NetworkError.invalidRequestURL
        }
        return try makeUrlRequest()
    }
}
