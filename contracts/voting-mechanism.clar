;; Government API Integration Contract

(define-map project-feasibility uint {
    is-feasible: bool,
    reason: (string-ascii 200)
})

(define-map project-updates uint (list 10 {
    update: (string-utf8 500),
    timestamp: uint
}))

(define-data-var government-authority principal tx-sender)

(define-public (set-project-feasibility (proposal-id uint) (is-feasible bool) (reason (string-ascii 200)))
    (begin
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (ok (map-set project-feasibility proposal-id {
            is-feasible: is-feasible,
            reason: reason
        }))
    )
)

(define-public (add-project-update (proposal-id uint) (update (string-utf8 500)))
    (let
        ((current-updates (default-to (list) (map-get? project-updates proposal-id))))
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (ok (map-set project-updates proposal-id
            (unwrap-panic (as-max-len?
                (append current-updates (tuple (update update) (timestamp block-height)))
                u10
            ))
        ))
    )
)

(define-read-only (get-project-feasibility (proposal-id uint))
    (map-get? project-feasibility proposal-id)
)

(define-read-only (get-project-updates (proposal-id uint))
    (map-get? project-updates proposal-id)
)

(define-public (transfer-authority (new-authority principal))
    (begin
        (asserts! (is-eq tx-sender (var-get government-authority)) (err u403))
        (ok (var-set government-authority new-authority))
    )
)

