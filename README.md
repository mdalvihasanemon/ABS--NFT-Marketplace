
# 🚀 ABS NFT Marketplace

A cutting-edge decentralized NFT marketplace built on blockchain technology, enabling users to **mint, buy, sell, and trade NFTs** securely and transparently. Designed for creators, collectors, and investors, this platform offers a seamless experience with modern UI/UX and powerful Web3 integration.

Leveraging smart contracts, decentralized storage, and cross-chain compatibility, this project aims to foster a vibrant ecosystem for digital assets with trustless transactions and transparent provenance.

**Live Demo:** [https://abs-nft-platform.onrender.com/](https://abs-nft-platform.onrender.com/)

---

## 🌐 ABS NFT Marketplace Preview
![Image](https://github.com/user-attachments/assets/e0870ad7-e205-48bf-8783-205259402947)

## 🌐 The live ABS NFT Marketplace Website Preview

<div style="display: flex; flex-wrap: nowrap; gap: 10px; overflow-x: auto;">

<img src="https://github.com/user-attachments/assets/1b082cde-485e-427e-8f19-5d8f46fe0ba1" alt="Screenshot 1" width="250" />

<img src="https://github.com/user-attachments/assets/974d3358-2323-406e-9ae2-baf1ba8adfe2" alt="Screenshot 2" width="250" />

<img src="https://github.com/user-attachments/assets/158c587a-ce64-4db2-bdeb-2e5cad42d8ca" alt="Screenshot 3" width="250" />

<img src="https://github.com/user-attachments/assets/f679c87d-c0c9-4374-a222-7a7524fac249" alt="Screenshot 4" width="250" />

<img src="https://github.com/user-attachments/assets/56ced9e1-f2e9-43ef-90c1-0b7b9e5989ce" alt="Screenshot 5" width="250" />

<img src="https://github.com/user-attachments/assets/40de6d2e-bee2-4493-bd80-183af62fbe13" alt="Screenshot 6" width="250" />

<img src="https://github.com/user-attachments/assets/20cb76f4-2fc5-41c1-81cd-297512a95706" alt="Screenshot 7" width="250" />

</div>

---

## 📌 Features

* **NFT Minting & Metadata**
  Mint unique ERC-721/ERC-1155 NFTs with off-chain metadata stored on IPFS ensuring immutability and accessibility.

* **Decentralized Marketplace**
  Peer-to-peer trading with smart contract-enforced escrow and automatic payments eliminating intermediaries.

* **Multi-Wallet Support**
  Connect using MetaMask, WalletConnect, Coinbase Wallet, and other popular Web3 wallets for accessibility.

* **Real-Time Updates**
  Live marketplace data through event subscriptions and WebSocket integration for a fluid user experience.

* **Advanced Search & Filtering**
  Filter NFTs by category, price, creator, rarity, and popularity with optimized search indexing.

* **User Profiles & Social Features**
  Creator pages, follower system, and collection showcases empower community building.

* **Multi-Chain & Layer-2 Support**
  Ethereum Mainnet, Polygon, and testnets supported, with plans for BSC, Solana, and Layer-2 rollups.

* **Gas Fee Optimization**
  Layer-2 solutions and batching transactions reduce costs and increase throughput.

* **Analytics & Insights**
  Dashboard featuring sales trends, popular NFTs, user activity, and earnings breakdown.

---

## 🛠️ Tech Stack

### Frontend

* **React.js / Next.js** — Server-side rendering, SEO friendly, fast UI.
* **Tailwind CSS / Styled Components** — Efficient styling with modern CSS-in-JS and utility-first design.
* **Ethers.js / Web3.js** — Blockchain interaction libraries.
* **React Query / SWR** — Data fetching and caching for real-time UI updates.

### Backend & Blockchain

* **Solidity Smart Contracts**
  Implements ERC-721/ERC-1155 token standards and marketplace logic with OpenZeppelin libraries.

* **Hardhat / Truffle**
  Smart contract development, testing, and deployment frameworks.

* **Node.js & Express.js**
  Backend API for user profiles, notifications, and indexing blockchain events.

* **IPFS / Pinata / NFT.Storage**
  Decentralized storage for NFT metadata and digital assets.

* **The Graph (optional)**
  GraphQL API for querying blockchain data efficiently.

### Database

* **MongoDB / Firebase**
  Off-chain user data, transaction histories, and caching.

---

## 📂 Project Structure

```
nft-marketplace/
│── contracts/         # Solidity smart contracts (ERC721, marketplace)
│── scripts/           # Deployment & migration scripts
│── src/               # Frontend React/Next.js source
│   ├── components/    # UI components (buttons, modals)
│   ├── contexts/      # React contexts (wallet, theme)
│   ├── hooks/         # Custom hooks for blockchain & UI
│   ├── pages/         # Next.js page routes (Home, Profile)
│   ├── services/      # API and blockchain interaction logic
│   ├── styles/        # Global and modular styles
│── public/            # Static assets (images, icons)
│── test/              # Contract unit and integration tests
│── config/            # Environment & network config files
│── package.json       # Frontend dependencies & scripts
│── hardhat.config.js  # Hardhat setup
│── README.md          # Project documentation
```

---

## 🚀 Installation & Setup

### 1️⃣ Clone the repository

```bash
git clone https://github.com/yourusername/nft-marketplace.git
cd nft-marketplace
```

### 2️⃣ Install dependencies

```bash
npm install
```

### 3️⃣ Configure environment variables

Create a `.env` file with the following variables:

```bash
REACT_APP_INFURA_PROJECT_ID=your_infura_project_id
REACT_APP_IPFS_API_KEY=your_ipfs_api_key
REACT_APP_NETWORK=mumbai  # or mainnet, polygon
PRIVATE_KEY=your_wallet_private_key
MONGODB_URI=your_mongodb_connection_string
```

### 4️⃣ Compile and deploy smart contracts

```bash
npx hardhat compile
npx hardhat run scripts/deploy.js --network mumbai
```

### 5️⃣ Run development server

```bash
npm run dev
```

Visit `http://localhost:3000` to access the app.

---

## 🧪 Testing

### Smart contract tests

Run tests to verify contract functionality and security:

```bash
npx hardhat test
```

### Frontend tests (optional)

```bash
npm run test
```

---

## 🔐 Security Considerations

* Contracts audited using OpenZeppelin best practices.
* User wallet private keys never stored or transmitted.
* Smart contracts include reentrancy guards and input validation.
* IPFS metadata content addressed for immutability.
* Follow standard security protocols for environment secrets.
* Regular dependency audits using `npm audit`.

---

## 📈 Deployment & Production

For production deployment:

1. Use a secure Ethereum RPC provider (Infura, Alchemy).
2. Deploy contracts on mainnet or Polygon mainnet.
3. Use managed IPFS pinning services for metadata availability.
4. Host frontend on static site hosts like Vercel, Netlify, or AWS.
5. Monitor blockchain events and backend APIs for uptime.
6. Implement continuous integration & deployment (CI/CD) pipelines.

---

## ⚙️ API Reference (Backend)

The backend API provides endpoints for:

* **User Profiles:** Retrieve and update profile data.
* **NFT Metadata:** Access metadata and asset URLs.
* **Marketplace Listings:** Query NFTs for sale with filters.
* **Transaction History:** Fetch user’s NFT transactions.
* **Notifications:** Real-time alerts for bids, sales, and transfers.

Refer to `/src/services/api` folder for full API documentation and usage examples.

---

## 🛠️ Common Issues & Troubleshooting

| Issue                             | Solution                                          |
| --------------------------------- | ------------------------------------------------- |
| Wallet connection fails           | Ensure MetaMask is installed and unlocked         |
| Contract deployment errors        | Verify private key and network configuration      |
| IPFS upload timeouts              | Use a reliable IPFS pinning service like Pinata   |
| Transactions stuck/pending        | Check gas price and adjust accordingly            |
| Frontend 404 on refresh (Next.js) | Configure server or use `next.config.js` rewrites |

For further support, open an issue on GitHub or join our Discord community (link below).

---



## 🤝 Contributing

We welcome contributions of all kinds! Please follow these guidelines:

1. Fork the repo and create a branch.
2. Write clear, concise commit messages.
3. Ensure your code passes existing tests.
4. Add tests for new features or bug fixes.
5. Submit a Pull Request with a detailed description.

Please adhere to the [Code of Conduct](https://github.com/yourusername/nft-marketplace/blob/main/CODE_OF_CONDUCT.md).

---

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---


## 📞 Contact

**Authors:**

* MD Alvi Hasan Emon — [alvihasan179@gmail.com](mailto:alvihasan179@gmail.com)
* Tahmid Hasan Rafi — [tahmidhasanrafi9@gmail.com](mailto:tahmidhasanrafi9@gmail.com)

**Website:**
[Md Alvi Hasan Emon](https://alvihasanemon.blogspot.com/)

**LinkedIn:**
[Md Alvi Hasan Emon](https://www.linkedin.com/in/alvi-hasan-emon)

---




