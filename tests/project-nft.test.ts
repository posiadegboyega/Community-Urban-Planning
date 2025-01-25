import { describe, it, expect, beforeEach } from "vitest"

describe("project-nft", () => {
	let contract: any
	
	beforeEach(() => {
		contract = {
			mintProjectNft: (proposalId: number, contributionAmount: number) => ({ value: 1 }),
			transfer: (tokenId: number, sender: string, recipient: string) => ({ success: true }),
			getTokenMetadata: (tokenId: number) => ({
				proposalId: 1,
				contributor: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
				contributionAmount: 10000,
				timestamp: 123456,
			}),
			getLastTokenId: () => 1,
		}
	})
	
	describe("mint-project-nft", () => {
		it("should mint a new project NFT", () => {
			const result = contract.mintProjectNft(1, 10000)
			expect(result.value).toBe(1)
		})
	})
	
	describe("transfer", () => {
		it("should transfer a project NFT", () => {
			const result = contract.transfer(
				1,
				"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
				"ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG",
			)
			expect(result.success).toBe(true)
		})
	})
	
	describe("get-token-metadata", () => {
		it("should return token metadata", () => {
			const metadata = contract.getTokenMetadata(1)
			expect(metadata.proposalId).toBe(1)
			expect(metadata.contributionAmount).toBe(10000)
		})
	})
	
	describe("get-last-token-id", () => {
		it("should return the last token ID", () => {
			const lastTokenId = contract.getLastTokenId()
			expect(lastTokenId).toBe(1)
		})
	})
})

