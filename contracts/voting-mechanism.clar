;; Voting Mechanism Contract

(define-map votes { proposal-id: uint, voter: principal } { vote-count: uint })

(define-public (cast-vote (proposal-id uint) (vote-count uint))
    (let
        ((current-votes (default-to { vote-count: u0 } (map-get? votes { proposal-id: proposal-id, voter: tx-sender }))))
        (asserts! (< (get vote-count current-votes) u100) (err u401))
        (map-set votes { proposal-id: proposal-id, voter: tx-sender } { vote-count: (+ (get vote-count current-votes) vote-count) })
        (update-proposal-votes proposal-id vote-count)
        (ok true)
    )
)

(define-private (update-proposal-votes (proposal-id uint) (new-votes uint))
    (let
        ((proposal (unwrap! (contract-call? .project-proposal get-proposal proposal-id) (err u404))))
        (contract-call? .project-proposal update-proposal-status proposal-id "active")
        (map-set proposals proposal-id
            (merge proposal { votes: (+ (get votes proposal) new-votes) }))
    )
)

(define-read-only (get-votes (proposal-id uint) (voter principal))
    (default-to { vote-count: u0 } (map-get? votes { proposal-id: proposal-id, voter: voter }))
)

