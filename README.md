# ArtProvenance

ArtProvenance is a blockchain-based digital art authentication and provenance tracking platform built on Stacks blockchain, ensuring transparent verification of digital artwork authenticity and ownership history.

## Features

- **Artwork Registration**: Artists can register digital artworks with creation details
- **Provenance Tracking**: Complete history of artwork creation and authentication
- **Expert Authentication**: Certified art experts can verify artwork authenticity
- **Immutable Records**: Blockchain-based records prevent art fraud and forgery

## Smart Contract Functions

### Administration
- `add-art-authenticator`: Register certified art experts for authentication

### Artist Functions
- `register-artwork`: Register new digital artwork with creation details
- `get-artist-portfolio`: View all artworks registered by an artist

### Authentication
- `authenticate-artwork`: Art experts can verify artwork authenticity
- `is-art-authenticator`: Check if an address is a certified authenticator

### Data Retrieval
- `get-artwork`: View complete artwork details and authentication status

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to verify the contract
4. Deploy using Clarinet or Stacks CLI

## For Artists

Register digital artworks by providing:
- Artwork title
- Creation process details
- Creation timestamp
- Studio location

## For Art Authenticators

Certified experts can review and authenticate artworks, providing collectors with confidence in artwork authenticity.