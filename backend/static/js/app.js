document.addEventListener('DOMContentLoaded', () => {
    // Initialize Web3
    let web3;
    if (typeof window.ethereum !== 'undefined') {
        web3 = new Web3(window.ethereum);
    } else {
        alert('Please install MetaMask!');
        return;
    }

    // Wallet connection
    const connectWalletBtn = document.getElementById('connectWalletBtn');
    if (connectWalletBtn) {
        connectWalletBtn.addEventListener('click', connectWallet);
    }

    // NFT creation form
    const createForm = document.getElementById('createNftForm');
    if (createForm) {
        createForm.addEventListener('submit', handleCreateNft);
    }

    async function connectWallet() {
        try {
            // Request account access
            const accounts = await window.ethereum.request({
                method: 'eth_requestAccounts'
            });

            const walletAddress = accounts[0];

            // Create modal element
            const modalElement = document.createElement('div');
            modalElement.classList.add('modal', 'fade');
            modalElement.id = 'walletModal';
            modalElement.innerHTML = `
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Connect Wallet</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Wallet Address</label>
                                <input type="text" class="form-control" id="walletAddress" value="${walletAddress}" readonly>
                            </div>
                            <div id="connectSteps">
                                <p>1. Please sign the message in your wallet to verify ownership</p>
                                <div class="text-center">
                                    <div class="spinner-border" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>
                            <div id="signatureResult" class="d-none">
                                <div class="alert alert-success">Wallet connected successfully!</div>
                            </div>
                        </div>
                    </div>
                </div>
            `;

            // Add modal to DOM
            document.body.appendChild(modalElement);

            // Initialize and show modal
            const walletModal = new bootstrap.Modal(modalElement);
            walletModal.show();

            // Generate and sign message
            const message = `Please sign this message to verify ownership of ${walletAddress}`;
            const signature = await web3.eth.personal.sign(message, walletAddress, '');

            // Send to backend for verification
            const response = await fetch('/connect', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    signature,
                    message,
                    address: walletAddress
                })
            });

            const result = await response.json();
            if (result.success) {
                document.getElementById('connectSteps').classList.add('d-none');
                document.getElementById('signatureResult').classList.remove('d-none');
                setTimeout(() => {
                    walletModal.hide();
                    // Cleanup modal
                    document.body.removeChild(modalElement);
                    window.location.reload();
                }, 1500);
            } else {
                alert('Connection failed: ' + (result.error || 'Unknown error'));
                document.body.removeChild(modalElement);
            }
        } catch (error) {
            console.error('Wallet connection error:', error);
            alert('Error connecting wallet: ' + error.message);

            // Cleanup modal if exists
            const modalElement = document.getElementById('walletModal');
            if (modalElement) {
                document.body.removeChild(modalElement);
            }
        }
    }

    async function handleCreateNft(e) {
        e.preventDefault();

        const form = e.target;
        const formData = new FormData(form);
        const progress = document.getElementById('mintProgress');
        const progressBar = progress.querySelector('.progress-bar');
        const progressText = document.getElementById('progressText');
        const progressPercent = document.getElementById('progressPercent');

        // Show progress
        progress.classList.remove('d-none');
        updateProgress(0, 'Preparing metadata...');

        try {
            // ... existing code ...
        } catch (error) {
            console.error('NFT creation error:', error);
            updateProgress(0, `Error: ${error.message}`);
            progressBar.classList.remove('progress-bar-animated', 'bg-success');
            progressBar.classList.add('bg-danger');

            // Show detailed error if available
            try {
                const errorData = await error.response.json();
                if (errorData.error) {
                    progressText.textContent = `Error: ${errorData.error}`;
                }
                if (errorData.message) {
                    progressText.textContent += ` - ${errorData.message}`;
                }
            } catch (parseError) {
                console.error('Error parsing error response:', parseError);
            }
        }

        function updateProgress(percent, text) {
            progressBar.style.width = `${percent}%`;
            progressText.textContent = text;
            progressPercent.textContent = `${percent}%`;
        }
    }
});