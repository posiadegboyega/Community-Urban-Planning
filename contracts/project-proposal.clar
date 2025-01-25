;; Project Proposal Contract

(define-data-var proposal-counter uint u0)

(define-map proposals uint {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    proposer: principal,
    status: (string-ascii 20),
    votes: uint,
    funds-required: uint,
    funds-raised: uint,
    created-at: uint
})

(define-public (submit-proposal (title (string-ascii 100)) (description (string-utf8 1000)) (funds-required uint))
    (let
        ((new-id (+ (var-get proposal-counter) u1)))
        (map-set proposals new-id {
            title: title,
            description: description,
            proposer: tx-sender,
            status: "pending",
            votes: u0,
            funds-required: funds-required,
            funds-raised: u0,
            created-at: block-height
        })
        (var-set proposal-counter new-id)
        (ok new-id)
    )
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
    (let
        ((proposal (unwrap! (map-get? proposals proposal-id) (err u404))))
        (asserts! (is-eq tx-sender (get proposer proposal)) (err u403))
        (ok (map-set proposals proposal-id
            (merge proposal { status: new-status })))
    )
)

(define-read-only (get-proposal (proposal-id uint))
    (map-get? proposals proposal-id)
)

(define-read-only (get-proposal-count)
    (var-get proposal-counter)
)

