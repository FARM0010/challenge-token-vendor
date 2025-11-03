# 🏵️ Token Vendor — SpeedRunEthereum Challenge

A minimal ERC‑20 + vending machine dApp built with **Scaffold‑ETH 2** (Next.js + Viem + Wagmi + Hardhat). The app lets users **buy** your ERC‑20, **transfer** it, and **sell it back** to the Vendor using the standard **approve → transferFrom** pattern.

> This repository is a completed submission for the **Token Vendor** challenge on [speedrunethereum.com](https://speedrunethereum.com/challenge/token-vendor).

---

## 🚀 Live

- **App**: [https://nextjs-llt7ljkl8-dormins-projects.vercel.app/](https://nextjs-llt7ljkl8-dormins-projects.vercel.app/)
- **Network**: Sepolia (chain id **11155111**)
- **Contracts**
  - `Vendor` — **0x98219Dc8ECAFDe3B5ed9dAd5DD8bc14963Dd0F87**
  - `YourToken` — **0x35f5CB22E33E7063514a26b3D8680B3Bc86F8176**

Paste any address above into a block explorer to view code/txs.

---

## ✨ What’s inside

- **YourToken.sol** — ERC‑20 (OpenZeppelin). Fixed supply, minted in the constructor to deployer.
- **Vendor.sol** — Vending machine contract:
  - `tokensPerEth = 100`
  - `buyTokens()` payable — swaps ETH → tokens
  - `sellTokens(uint256)` — requires prior `approve`, swaps tokens → ETH
  - `withdraw()` — owner‑only, withdraws all ETH
  - Events: `BuyTokens`, `SellTokens`, `Withdraw`
- **Deploy script** transfers `1000 * 10**18` tokens to the Vendor and transfers Vendor ownership to the **frontend/owner** address.

---

## 🛠 Quickstart (local)

> Recommended Node: **v20.18.x** (Hardhat does not officially support Node 21).

```bash
# 1) Install deps (root)
yarn

# 2) Start local chain
cd packages/hardhat
yarn chain

# 3) In a new terminal: deploy locally
cd packages/hardhat
yarn deploy --reset

# 4) In a third terminal: start the dapp
cd packages/nextjs
yarn start
# open http://localhost:3000
```

### Environment

`packages/hardhat/.env`
```
ALCHEMY_API_KEY=
ETHERSCAN_V2_API_KEY=
DEPLOYER_PRIVATE_KEY_ENCRYPTED={...}
FRONTEND_ADDRESS=0xyourOwnerWallet
```

`packages/nextjs/.env.local` (optional; defaults are provided)
```
NEXT_PUBLIC_ALCHEMY_API_KEY=
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=
```

> Ensure `.env*` files are **gitignored**. Do **not** commit private keys or encrypted key blobs.

---

## 🔍 Verify (optional)

From `packages/hardhat`:

```bash
yarn verify --network sepolia 0x35f5CB22E33E7063514a26b3D8680B3Bc86F8176   # YourToken (no args)
yarn verify --network sepolia 0x98219Dc8ECAFDe3B5ed9dAd5DD8bc14963Dd0F87  "0x35f5CB22E33E7063514a26b3D8680B3Bc86F8176"  # Vendor(tokenAddress)
```

---

## 📋 How to use (on Sepolia)

1. Connect wallet (burner or MetaMask) on Sepolia.
2. **Buy**: enter tokens to buy → wallet pays `amount / tokensPerEth` ETH.
3. **Transfer**: send tokens to any address via `transfer`.
4. **Sell**: `approve(Vendor, amount)` then `sellTokens(amount)` to receive ETH back.

---

## 🧩 Tech stack

- Solidity, Hardhat, hardhat‑deploy
- OpenZeppelin ERC20, Ownable
- Next.js (app router), Viem, Wagmi, RainbowKit
- Tailwind + daisyUI

---

## ✅ Submission notes

- `tokensPerEth` hard‑coded to **100**.
- Vendor preloaded with **1000 YTK** in the deploy script.
- Vendor ownership transferred to `FRONTEND_ADDRESS` from `.env`.
- Frontend route: `/token-vendor` includes **Buy / Transfer / Approve+Sell** UX and shows balances.

---

## 🔐 Security

- Addresses are public by design. **Never** commit private keys, mnemonics or the encrypted key JSON.
- Keep owner funds in a non‑burner wallet.

---

## 📦 Scripts

```bash
# Deploy to Sepolia
cd packages/hardhat
yarn deploy --network sepolia --reset

# Verify on Sepolia (see Verify above)

# Build frontend
cd packages/nextjs
yarn build

# Deploy frontend to Vercel (once linked)
vercel --prod
```

---

## 📄 License

MIT