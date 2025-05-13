<script lang="ts">
  import { accounts, activeAccount, translations, atm, notify, popupDetails } from "../../store/stores";
  import AccountTransactionItem from "./AccountTransactionItem.svelte";
  import { convertToCSV } from "../../utils/convertToCSV";
  import { setClipboard } from "../../utils/setClipboad";
  import { formatMoney } from "../../utils/misc";
  import { get } from 'svelte/store';
  import { onMount } from 'svelte';
  
  let transSearch = '';
  let balanceElement;
  
  $: account = $activeAccount && $accounts && Array.isArray($accounts) 
      ? $accounts.find((accountItem: any) => $activeAccount === accountItem?.id) 
      : null;

  function handleClickExportData() {
      if (!account) {
          console.log("No card selected");
          notify.set("No card selected!");
          setTimeout(() => {
              notify.set("");
          }, 3500);
          return;
      }
      
      if (!account.transactions || !Array.isArray(account.transactions) || account.transactions.length === 0) {
          notify.set("No transactions to export!");
          setTimeout(() => {
              notify.set("");
          }, 3500);
          return;
      }
      
      const csv = convertToCSV(account.transactions);
      setClipboard(csv);
      notify.set("Data copied to clipboard!");
      setTimeout(() => {
          notify.set("");
      }, 3500);
  }
  
  let isAtm: boolean = false;
  atm.subscribe((usingAtm: boolean) => {
      isAtm = usingAtm;
  });
  
  function handleButton(id:string, type:string) {
      const $accounts = get(accounts);
      if (!$accounts || !Array.isArray($accounts)) return;
      let account = $accounts.find((accountItem: any) => id === accountItem?.id);
      if (!account) return;
      popupDetails.update(() => ({ actionType: type, account }));
  }

  function displayBalance(amount) {
    if (!amount && amount !== 0) return '';
    return formatMoney(amount);
  }
</script>

<section class="flex-1 overflow-hidden flex flex-col">
  {#if account}

<div class="bg-fleeca-card rounded-xl mb-6 shadow-lg overflow-hidden border border-fleeca-border">
    <!-- Top section with balance and account info -->
    <div class="p-6 bg-gradient-to-r from-fleeca-green/90 to-fleeca-dark-green text-white">
        <div class="flex justify-between items-start mb-4">
            <div>
                <h2 class="text-xs uppercase tracking-wider text-white/80 font-medium mb-1">
                    {account.type === "personal" || account.type === "Personal" ? "Personal Account" : account.type === "business" || account.type === "Business" ? "Business Account" : account.organisation || "Personal Account"}
                </h2>
                <div class="flex items-center">
                    <i class="fas fa-university mr-2"></i>
                    <span class="font-medium">{account.name}</span>
                </div>
                <div class="text-xs text-white/80 mt-1">{account.id}</div>
            </div>
            {#if account.isFrozen}
                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-500/20 text-white border border-red-500/30">
                    <i class="fa-solid fa-lock mr-1 text-xs"></i> {$translations.frozen || 'Frozen'}
                </span>
            {/if}
        </div>
        
        <div class="mb-4">
            <h2 class="text-sm text-white/80 font-medium mb-1">{$translations.balance || 'Available Balance'}</h2>
            <div 
                bind:this={balanceElement} 
                class="text-4xl font-bold"
                style="transition: none;"
            >
                {displayBalance(account.amount)}
            </div>
        </div>
    </div>
    
    <!-- Chart section -->
    

<div class="border-t border-b border-fleeca-border"></div>
    

    {#if !account.isFrozen}
        <div class="grid grid-cols-3 gap-3 p-4 bg-fleeca-card">
            {#if !isAtm}
                <button 
                    class="flex items-center justify-center py-3 px-2 bg-fleeca-green text-white rounded-lg font-medium hover:bg-fleeca-dark-green transition-all shadow-sm" 
                    on:click={() => handleButton(account.id, "deposit")}
                >
                    <i class="fas fa-arrow-down text-white mr-2"></i>
                    <span>{$translations.deposit_but || 'Deposit'}</span>
                </button>
            {/if}
            <button 
                class="flex items-center justify-center py-3 px-2 bg-fleeca-hover text-fleeca-text rounded-lg font-medium hover:bg-fleeca-bg transition-all border border-fleeca-border shadow-sm" 
                on:click={() => handleButton(account.id, "withdraw")}
            >
                <i class="fas fa-arrow-up mr-2"></i>
                <span>{$translations.withdraw_but || 'Withdraw'}</span>
            </button>
            <button 
                class="flex items-center justify-center py-3 px-2 bg-fleeca-hover text-fleeca-text rounded-lg font-medium hover:bg-fleeca-bg transition-all border border-fleeca-border shadow-sm" 
                class:col-span-2={isAtm}
                on:click={() => handleButton(account.id, "transfer")}
            >
                <i class="fas fa-exchange-alt mr-2"></i>
                <span>{$translations.transfer_but || 'Transfer'}</span>
            </button>
        </div>
    {/if}
</div>
    
<div class="mb-4 flex justify-between items-center">
    <h3 class="text-xl font-semibold text-fleeca-text flex items-center font-display">
        <div class="w-8 h-8 rounded-lg bg-fleeca-green/10 flex items-center justify-center mr-3 border border-fleeca-green/20">
            <i class="fa-solid fa-receipt text-fleeca-green"></i>
        </div>
        {$translations.transactions || 'Transactions'}
    </h3>
    
    {#if !isAtm && account.transactions && account.transactions.length > 0}
        <button 
            class="py-1 px-3 bg-fleeca-hover text-fleeca-text rounded-md text-xs font-medium hover:bg-fleeca-bg transition-colors border border-fleeca-border flex items-center" 
            on:click|preventDefault={handleClickExportData}
        >
            <i class="fa-solid fa-file-export mr-1"></i>
            {$translations.export_data || 'Export Data'}
        </button>
    {/if}
</div>

<div class="relative mb-4">
    <input 
        type="text" 
        class="w-full rounded-lg border border-fleeca-border p-3 pl-10 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all" 
        placeholder={$translations.trans_search || 'Search transactions...'} 
        bind:value={transSearch}
    >
    <i class="fa-solid fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-fleeca-text-secondary"></i>
</div>

<div class="overflow-y-auto flex-1 pr-2 hide-scrollbar bg-fleeca-bg rounded-lg p-4 border border-fleeca-border">
    {#if account.transactions && Array.isArray(account.transactions) && account.transactions.length > 0}
        {#if account.transactions.filter(item => item && item.message && typeof item.message === 'string' && 
            (item.message.toLowerCase().includes((transSearch || '').toLowerCase()) || 
            (item.trans_id && typeof item.trans_id === 'string' && item.trans_id.toLowerCase().includes((transSearch || '').toLowerCase())) || 
            (item.receiver && typeof item.receiver === 'string' && item.receiver.toLowerCase().includes((transSearch || '').toLowerCase())))).length > 0}
        <div class="space-y-3 animate-fadeIn">
            {#each account.transactions.filter(item => item && item.message && typeof item.message === 'string' && 
                (item.message.toLowerCase().includes((transSearch || '').toLowerCase()) || 
                (item.trans_id && typeof item.trans_id === 'string' && item.trans_id.toLowerCase().includes((transSearch || '').toLowerCase())) || 
                (item.receiver && typeof item.receiver === 'string' && item.receiver.toLowerCase().includes((transSearch || '').toLowerCase())))) as transaction (transaction.trans_id)}
                <AccountTransactionItem {transaction}/>
            {/each}
        </div>
    {:else}
        <div class="text-center py-8 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn shadow-sm">
            <div class="w-16 h-16 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-4">
                <i class="fa-solid fa-receipt text-fleeca-text-secondary text-2xl"></i>
            </div>
            <h3 class="text-fleeca-text font-medium">{$translations && $translations.trans_not_found ? $translations.trans_not_found : 'No transactions found'}</h3>
        </div>
    {/if}
{:else}
    <div class="text-center py-8 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn shadow-sm">
        <div class="w-16 h-16 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-4">
            <i class="fa-solid fa-receipt text-fleeca-text-secondary text-2xl"></i>
        </div>
        <h3 class="text-fleeca-text font-medium">{$translations && $translations.trans_not_found ? $translations.trans_not_found : 'No transactions found'}</h3>
    </div>
{/if}
</div>
{:else}
    <div class="flex-1 flex items-center justify-center">
    <div class="text-center py-12 px-6 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn max-w-md shadow-md">
        <div class="w-20 h-20 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-6">
            <i class="fas fa-credit-card text-fleeca-green text-3xl"></i>
        </div>
        <h3 class="text-fleeca-text font-medium text-xl mb-3 font-display">{$translations && $translations.select_account ? $translations.select_account : 'Select a card'}</h3>
        <p class="text-fleeca-text-secondary">Choose a card from the left to view details and manage your finances</p>
    </div>
</div>
{/if}
</section>

<style>
  :global(.text-4xl) {
    transition: none !important;
    animation: none !important;
  }
  
  :global(.money-counter),
  :global(.digit) {
    transition: none !important;
    animation: none !important;
  }
</style>
