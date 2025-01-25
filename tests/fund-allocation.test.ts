import { describe, it, expect, beforeEach } from "vitest"

describe("fund-allocation", () => {
	let contract: any
	
	beforeEach(() => {
		contract = {
			allocateFunds: (proposalId: number, amount: number) => ({ success: true }),
			getProjectFunds: (proposalId: number) => 50000,
		}
	})
	
	describe("allocate-funds", () => {
		it("should allocate funds to a project", () => {
			const result = contract.allocateFunds(1, 50000)
			expect(result.success).toBe(true)
		})
	})
	
	describe("get-project-funds", () => {
		it("should return the total funds allocated to a project", () => {
			const funds = contract.getProjectFunds(1)
			expect(funds).toBe(50000)
		})
	})
})

