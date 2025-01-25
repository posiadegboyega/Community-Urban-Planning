;; Project NFT Contract

(define-non-fungible-token project-nft uint)

(define-data-var nft-counter uint u0)

(define-map token-metadata uint {
    proposal-id: uint,
    contributor: principal,
    contribution-amount: uint,
    timestamp: uint
})

(define-public (mint-project-nft (proposal-id uint) (contribution-amount uint))
    (let
        ((new-id (+ (var-get nft-counter) u1)))
        (try! (nft-mint? project-nft new-id tx-sender))
        (map-set token-metadata new-id {
            proposal-id: proposal-id,
            contributor: tx-sender,
            contribution-amount: contribution-amount,
            timestamp: block-height
        })
        (var-set nft-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? project-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get nft-counter)
)

