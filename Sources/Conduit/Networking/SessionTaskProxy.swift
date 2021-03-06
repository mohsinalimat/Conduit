//
//  SessionTaskProxy.swift
//  Conduit
//
//  Created by John Hammerlund on 7/28/16.
//  Copyright © 2017 MINDBODY. All rights reserved.
//

import Foundation

/// Allows limited access to a network task created via a URLSessionClient
public protocol SessionTaskProxyType {

    /// Reports download progress
    var downloadProgressHandler: SessionTaskProgressHandler? { get set }

    /// Reports upload progress
    var uploadProgressHandler: SessionTaskProgressHandler? { get set }

    /// Cancels the task, or schedules it to be canceled
    func cancel()

    /// Suspends the task, or schedules it to be suspended
    func suspend()

    /// Resumes the task if it was previously suspended
    func resume()

}

final class SessionTaskProxy: SessionTaskProxyType {

    var downloadProgressHandler: SessionTaskProgressHandler?

    var uploadProgressHandler: SessionTaskProgressHandler?

    weak var task: URLSessionDataTask? {
        didSet {
            guard let task = self.task else {
                return
            }

            if shouldImmediatelyCancel {
                task.cancel()
            }
            else if shouldImmediatelySuspend {
                task.suspend()
            }
        }
    }

    private var shouldImmediatelyCancel: Bool = false {
        didSet {
            task?.cancel()
        }
    }
    private var shouldImmediatelySuspend: Bool = false {
        didSet {
            task?.suspend()
        }
    }

    func cancel() {
        shouldImmediatelyCancel = true
    }

    func suspend() {
        shouldImmediatelySuspend = true
    }

    func resume() {
        task?.resume()
    }

}
