//
//  SnapshotWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class SnapshotWorker: Worker {
    
    public func snapshot(snapshotId: String) -> API.Result<Snapshot> {
        get(path: "/snapshots/\(snapshotId)")
    }
    
    public func snapshot(snapshotId: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        get(path: "/snapshots/\(snapshotId)", completion: completion)
    }
    
    public func trace(traceId: String) -> API.Result<Snapshot> {
        get(path: "/snapshots/trace/\(traceId)")
    }
    
}
