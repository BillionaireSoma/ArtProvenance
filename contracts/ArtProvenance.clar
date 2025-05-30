;; ArtProvenance - Digital art authenticity and ownership verification
(define-map digital-artworks uint {
  artist: principal,
  artwork-title: (string-utf8 64),
  creation-details: (string-utf8 256),
  creation-timestamp: uint,
  studio-location: (string-utf8 64),
  authenticated: bool
})

(define-map artist-portfolio principal (list 100 uint))
(define-map art-authenticators principal bool)
(define-data-var artwork-id-counter uint u0)

;; Error codes
(define-constant err-not-artist (err u300))
(define-constant err-not-authenticator (err u301))
(define-constant err-artwork-not-found (err u302))
(define-constant err-unauthorized-action (err u403))
(define-constant err-portfolio-full (err u304))
(define-constant err-invalid-principal-address (err u305))
(define-constant err-invalid-artwork-title (err u306))
(define-constant err-invalid-creation-details (err u307))
(define-constant err-invalid-timestamp (err u308))
(define-constant err-invalid-studio-location (err u309))
(define-constant err-invalid-artwork-id (err u310))

;; Contract curator for authentication management
(define-constant contract-curator tx-sender)

;; Add art authenticator
(define-public (add-art-authenticator (authenticator principal))
  (begin
    ;; Check if sender is contract curator
    (asserts! (is-eq tx-sender contract-curator) err-unauthorized-action)
    
    ;; Validate authenticator principal
    (asserts! (not (is-eq authenticator 'SP000000000000000000002Q6VF78)) err-invalid-principal-address)
    
    ;; Add authenticator to registry
    (ok (map-set art-authenticators authenticator true))
  )
)

;; Register digital artwork
(define-public (register-artwork 
  (artwork-title (string-utf8 64)) 
  (creation-details (string-utf8 256)) 
  (creation-timestamp uint) 
  (studio-location (string-utf8 64)))
  (let
    ((artwork-id (var-get artwork-id-counter))
     (artist tx-sender)
     (current-portfolio (default-to (list) (map-get? artist-portfolio artist))))
    
    ;; Validate inputs
    (asserts! (> (len artwork-title) u0) err-invalid-artwork-title)
    (asserts! (> (len creation-details) u0) err-invalid-creation-details)
    (asserts! (> creation-timestamp u0) err-invalid-timestamp)
    (asserts! (> (len studio-location) u0) err-invalid-studio-location)
    
    ;; Check portfolio capacity
    (asserts! (< (len current-portfolio) u100) err-portfolio-full)
    
    ;; Store artwork information
    (map-set digital-artworks artwork-id {
      artist: artist,
      artwork-title: artwork-title,
      creation-details: creation-details,
      creation-timestamp: creation-timestamp,
      studio-location: studio-location,
      authenticated: false
    })
    
    ;; Update artist's portfolio
    (let 
      ((updated-portfolio (unwrap-panic (as-max-len? (concat (list artwork-id) current-portfolio) u100))))
      (map-set artist-portfolio artist updated-portfolio)
    )
    
    ;; Increment artwork ID counter
    (var-set artwork-id-counter (+ artwork-id u1))
    
    (ok artwork-id)))

;; Authenticate artwork
(define-public (authenticate-artwork (artwork-id uint))
  (begin
    ;; Validate artwork ID
    (asserts! (< artwork-id (var-get artwork-id-counter)) err-invalid-artwork-id)
    
    (let
      ((artwork (unwrap! (map-get? digital-artworks artwork-id) err-artwork-not-found)))
      
      ;; Check if sender is art authenticator
      (asserts! (default-to false (map-get? art-authenticators tx-sender)) err-not-authenticator)
      
      ;; Update artwork authentication status
      (ok (map-set digital-artworks artwork-id (merge artwork {authenticated: true})))
    )
  )
)

;; Get artwork details
(define-read-only (get-artwork (artwork-id uint))
  (map-get? digital-artworks artwork-id))

;; Get artist's portfolio
(define-read-only (get-artist-portfolio (artist principal))
  (default-to (list) (map-get? artist-portfolio artist)))

;; Check authenticator status
(define-read-only (is-art-authenticator (address principal))
  (default-to false (map-get? art-authenticators address)))