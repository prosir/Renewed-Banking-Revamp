<script lang="ts">
  import { activeAccount, popupDetails, atm } from "../../store/stores";
  import { get } from 'svelte/store';
  export let account:any;

  function handleAccountClick(id: any) {
      activeAccount.update(() => id);
  };

  let isAtm: boolean = false;
  atm.subscribe((usingAtm: boolean) => {
      isAtm = usingAtm !== undefined ? usingAtm : false;
  });

  $: isActive = $activeAccount === account.id;
  
  function formatCardNumber(id: string) {
    let baseNumber = id.replace(/\D/g, '');
    if (baseNumber.length === 0) {
      baseNumber = Array.from(id.substring(0, 16))
        .map(char => char.charCodeAt(0) % 10)
        .join('');
    }
    
    baseNumber = baseNumber.padEnd(16, '0').substring(0, 16);
    
    return baseNumber.replace(/(.{4})/g, '$1 ').trim();
  }
  
  const cvv = Math.floor(Math.random() * 900) + 100;
  
  const platinumThreshold = parseInt(localStorage.getItem('platinumThreshold') || '50000');

  let cardType = "PERSONAL";
  let cardBackground = "bg-gradient-to-br from-fleeca-green to-fleeca-dark-green";
  
  const orgNames = ["police", "ambulance", "ems", "sheriff", "fire", "government", "lspd", "bcso"];
  
  function isSpecialOrg(account) {
    if (!account.name || typeof account.name !== 'string') return false;
    const lowerName = account.name.toLowerCase();
    return orgNames.some(org => lowerName.includes(org));
  }
  
  $: {
    if (account.creator) {
      cardType = "BUSINESS";
      cardBackground = "bg-gradient-to-br from-gray-800 to-gray-900";
    } 
    else if ((account.type && 
             (account.type.toLowerCase() === "org" || account.type.toLowerCase() === "organization")) || 
             isSpecialOrg(account)) {
      cardType = "ORGANIZATION";
      cardBackground = "bg-gradient-to-br from-gray-800 to-gray-700";
    }
    else {
      if (account.amount > platinumThreshold) {
        cardType = "PLATINUM";
        cardBackground = "bg-gradient-to-br from-gray-900 to-gray-800";
      } else {
        cardType = "PERSONAL";
        cardBackground = "bg-gradient-to-br from-fleeca-green to-fleeca-dark-green";
      }
    }
  }
  
  const cardHolder = account.name.toUpperCase();
  
  let isFlipped = false;
  
  function toggleFlip(event) {
    event.stopPropagation();
    isFlipped = !isFlipped;
  }
</script>

<div 
  class="card-container cursor-pointer {isActive ? 'active-card' : ''}"
  on:click={() => handleAccountClick(account.id)} 
  on:keydown={() => {}}>
  
  <div class="credit-card {isFlipped ? 'is-flipped' : ''}">
    <div class="card-face card-front {cardBackground} {account.isFrozen ? 'frozen' : ''}">
      <div class="card-content">
        <div class="card-header">
          <div class="bank-logo">
            <i class="fas fa-university text-white text-sm"></i>
            <span class="bank-name">FLEECA</span>
          </div>
          <div class="card-chip">
            <i class="fas fa-microchip text-xs"></i>
          </div>
        </div>
        
        <div class="type-badge-container">
          <span class="type-badge {cardType.toLowerCase()}-badge">{cardType}</span>
          
          {#if account.isFrozen}
            <span class="frozen-badge">
              <i class="fa-solid fa-lock text-xs"></i> FROZEN
            </span>
          {/if}
        </div>
        
        <div class="card-number">
          {formatCardNumber(account.id)}
        </div>
        
        <div class="card-details">
          <div class="card-holder">
            <div class="label">CARD HOLDER</div>
            <div class="value">{cardHolder}</div>
          </div>
        </div>
        
        <div class="card-network">
          <div class="network-circles">
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="card-face card-back {cardBackground}">
      <div class="magnetic-stripe"></div>
      
      <div class="signature-strip">
        <div class="signature">{cardHolder}</div>
        <div class="cvv-container">
          <span class="cvv-label">CVV</span>
          <span class="cvv-number">{cvv}</span>
        </div>
      </div>
      
      <div class="card-info">
        <p class="info-text">This card is property of Fleeca Bank.</p>
        <p class="info-text">Use subject to cardholder agreement.</p>
      </div>
      
      <div class="bank-logo-small">
        <i class="fas fa-university text-white text-xs"></i>
        <span class="bank-name-small">FLEECA BANK</span>
      </div>
    </div>
  </div>
  
  {#if isActive}
    <div class="selection-indicator"></div>
  {/if}
  
  <button 
    class="external-flip-button"
    on:click={toggleFlip}
    aria-label="Flip card">
    <i class="fas fa-sync-alt"></i>
  </button>
</div>

<style>
  .card-container {
    position: relative;
    width: 100%;
    max-width: 300px;
    margin: 0 auto 12px;
    perspective: 1000px;
    transition: transform 0.2s ease;
  }
  
  .credit-card {
    width: 100%;
    height: 160px;
    position: relative;
    transition: transform 0.6s;
    transform-style: preserve-3d;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  
  .credit-card.is-flipped {
    transform: rotateY(180deg);
  }
  
  .card-face {
    position: absolute;
    width: 100%;
    height: 100%;
    backface-visibility: hidden;
    border-radius: 12px;
    overflow: hidden;
  }
  
  .card-front {
    padding: 12px;
    color: white;
  }
  
  .card-back {
    transform: rotateY(180deg);
    padding: 0;
  }
  
  .frozen {
    position: relative;
  }
  
  .frozen::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: repeating-linear-gradient(
      45deg,
      rgba(255, 255, 255, 0.1),
      rgba(255, 255, 255, 0.1) 10px,
      rgba(255, 255, 255, 0.1) 10px,
      rgba(255, 255, 255, 0.2) 20px
    );
    pointer-events: none;
  }
  
  .card-content {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    z-index: 1;
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
  }
  
  .bank-logo {
    display: flex;
    align-items: center;
    gap: 4px;
  }
  
  .bank-name {
    font-size: 16px;
    font-weight: 700;
    letter-spacing: 1px;
  }
  
  .card-chip {
    width: 24px;
    height: 18px;
    background: linear-gradient(135deg, #e6c446 0%, #d4af37 100%);
    border-radius: 3px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: rgba(0, 0, 0, 0.6);
  }
  
  .type-badge-container {
    position: absolute;
    top: 36px;
    right: 12px;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 4px;
    z-index: 10;
  }
  
  .type-badge {
    padding: 2px 6px;
    border-radius: 3px;
    font-size: 8px;
    text-transform: uppercase;
    font-weight: bold;
    letter-spacing: 1px;
    display: inline-block;
  }
  
  .business-badge {
    background-color: rgba(255, 215, 0, 0.8);
    color: rgba(0, 0, 0, 0.8);
  }
  
  .organization-badge {
    background-color: rgba(70, 130, 180, 0.8);
    color: white;
  }
  
  .personal-badge {
    background-color: rgba(0, 165, 80, 0.8);
    color: white;
  }
  
  .platinum-badge {
    background: linear-gradient(135deg, rgba(212, 175, 55, 0.8), rgba(255, 215, 0, 0.8));
    color: rgba(0, 0, 0, 0.8);
  }
  
  .frozen-badge {
    background-color: rgba(255, 0, 0, 0.7);
    color: white;
    padding: 2px 6px;
    border-radius: 3px;
    font-size: 8px;
    letter-spacing: 1px;
    display: flex;
    align-items: center;
    gap: 3px;
  }
  
  .card-number {
    font-size: 14px;
    font-weight: 500;
    letter-spacing: 1px;
    text-align: center;
    margin: 6px 0;
    font-family: 'Courier New', monospace;
  }
  
  .card-details {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-top: 10px;
  }
  
  .card-holder {
    display: flex;
    flex-direction: column;
  }
  
  .label {
    font-size: 6px;
    opacity: 0.8;
    margin-bottom: 2px;
    letter-spacing: 1px;
  }
  
  .value {
    font-size: 10px;
    font-weight: 500;
    letter-spacing: 1px;
  }
  
  .card-network {
    position: absolute;
    bottom: 12px;
    right: 12px;
  }
  
  .network-circles {
    position: relative;
    width: 36px;
    height: 24px;
  }
  
  .circle {
    position: absolute;
    width: 18px;
    height: 18px;
    border-radius: 50%;
  }
  
  .circle-1 {
    background-color: rgba(255, 0, 0, 0.7);
    left: 0;
  }
  
  .circle-2 {
    background-color: rgba(255, 165, 0, 0.7);
    right: 0;
    mix-blend-mode: screen;
  }
  
  .magnetic-stripe {
    width: 100%;
    height: 40px;
    background-color: rgba(0, 0, 0, 0.8);
    margin-top: 20px;
  }
  
  .signature-strip {
    margin: 15px 10px;
    height: 30px;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 4px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10px;
  }
  
  .signature {
    font-family: 'Brush Script MT', cursive;
    color: #333;
    font-size: 14px;
  }
  
  .cvv-container {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
  }
  
  .cvv-label {
    font-size: 6px;
    color: #333;
  }
  
  .cvv-number {
    font-size: 12px;
    font-weight: bold;
    color: #333;
  }
  
  .card-info {
    padding: 0 10px;
    margin-top: 5px;
  }
  
  .info-text {
    color: rgba(255, 255, 255, 0.7);
    font-size: 6px;
    margin-bottom: 2px;
  }
  
  .bank-logo-small {
    position: absolute;
    bottom: 10px;
    right: 10px;
    display: flex;
    align-items: center;
    gap: 4px;
  }
  
  .bank-name-small {
    font-size: 8px;
    font-weight: 700;
    letter-spacing: 1px;
  }
  
  .selection-indicator {
    position: absolute;
    bottom: -5px;
    left: 50%;
    transform: translateX(-50%);
    width: 30px;
    height: 3px;
    background-color: var(--fleeca-green);
    border-radius: 3px;
  }

  .active-card {
    transform: scale(1.02);
    box-shadow: 0 0 12px 2px rgba(0, 165, 80, 0.4);
    z-index: 10;
  }

  .active-card .credit-card {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  }

  .external-flip-button {
    position: absolute;
    top: 10px;
    right: -40px;
    width: 30px;
    height: 30px;
    background-color: var(--fleeca-card);
    border: 1px solid var(--fleeca-border);
    border-radius: 50%;
    color: var(--fleeca-text);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.2s;
    z-index: 10;
  }

  .external-flip-button:hover {
    background-color: var(--fleeca-hover);
    transform: rotate(45deg);
  }
</style>
