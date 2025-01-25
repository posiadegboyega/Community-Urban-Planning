;; Fund Allocation Contract

(define-map project-funds uint uint)

(define-public (allocate-funds (proposal-id uint) (amount uint))
    (let
        ((proposal (unwrap! (contract-call? .project-proposal get-proposal proposal-id) (err u404))))
        (asserts! (is-eq (get status proposal) "active") (err u403))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set project-funds proposal-id
            (+ (default-to u0 (map-get? project-funds proposal-id)) amount))
        (try! (update-proposal-funds proposal-id amount))
        (ok true)
    )
)

(define-private (update-proposal-funds (proposal-id uint) (new-funds uint))
    (let
        ((proposal (unwrap! (contract-call? .project-proposal get-proposal proposal-id) (err u404))))
        (let
            ((updated-funds (+ (get funds-raised proposal) new-funds))
             (required-funds (get funds-required proposal)))
            (if (>= updated-funds required-funds)
                (contract-call? .project-proposal update-proposal-status proposal-id "funded")
                (ok true)
            )
        )
    )
)

(define-read-only (get-project-funds (proposal-id uint))
    (default-to u0 (map-get? project-funds proposal-id))
)

