//
//  SnapshotWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class SnapshotWorker<Error: ServerError & Decodable>: Worker<Error> {
    
    public func snapshot(snapshotID: String) -> API.Result<Snapshot> {
        get(path: "/snapshots/\(snapshotID)")
    }
    
    public func snapshot(snapshotID: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        get(path: "/snapshots/\(snapshotID)", completion: completion)
    }
    
    public func trace(traceID: String) -> API.Result<Snapshot> {
        get(path: "/snapshots/trace/\(traceID)")
    }
    
}
